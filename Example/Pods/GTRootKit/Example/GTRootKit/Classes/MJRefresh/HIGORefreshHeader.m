//
//  HigirlRefreshHeader.m
//  Higirl
//
//  Created by bailu on 5/27/15.
//  Copyright (c) 2015 ___MEILISHUO___. All rights reserved.
//

#import "HIGORefreshHeader.h"
#import "MJRefreshConst.h"
#import "UIView+MJExtension.h"
#import <objc/message.h>
#import "UIScrollView+MJExtension.h"

const CGFloat circleRadius = 10.0;
const CGFloat arcWidth = 1.0;
const CGFloat redLineGap = 15.0;
const CGFloat redLineFinalHeight = 24; //self.mj_h-redLineGap*2-circleRadius;

#define RGBACOLOR(r,g,b,a)              [UIColor colorWithRed:(r)/255.0f green:(g)/255.0f blue:(b)/255.0f alpha:(a)]
#define COLOR_BUTTONLINE_BG             RGBA(93,116,218,1)
#define SCREEN_HEIGHT               ([[UIScreen mainScreen] bounds].size.height)
#define SCREEN_WIDTH                ([[UIScreen mainScreen] bounds].size.width)

@interface HIGORefreshHeader ()

@property (strong, nonatomic) UIView* redLineView;
@property (strong, nonatomic) UIView* arcView;
@property (strong, nonatomic) UIView* outView;

@property (nonatomic) BOOL isAnimating;
@property (nonatomic) NSUInteger spinTimes;

@end

@implementation HIGORefreshHeader

#pragma mark - 懒加载
- (UIView *)redLineView
{
    if (!_redLineView) {
        UIView* redLineView = [[UIView alloc] initWithFrame:CGRectZero];
        redLineView.backgroundColor = COLOR_BUTTONLINE_BG;
        [self addSubview:_redLineView = redLineView];
    }
    return _redLineView;
}

- (UIView *)arcView
{
    if (!_arcView) {
        _arcView = [[UIView alloc] initWithFrame:CGRectZero];
        [self addSubview:_arcView];
    }
    return _arcView;
}

- (UIView *)outView
{
    if (!_outView) {
        _outView = [[UIView alloc] init];
        _outView.backgroundColor = COLOR_BUTTONLINE_BG;
        [self addSubview:_outView];
    }
    return _outView;
}

#pragma mark - 初始化方法
- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.stateHidden = YES;
        self.updatedTimeHidden = YES;
    }
    return self;
}

#pragma mark - 设置状态
- (void)setState:(MJRefreshHeaderState)state
{
    if (self.state == state) return;
    
    // 旧状态
    MJRefreshHeaderState oldState = self.state;
    
//    NSArray* stateArr = @[@"", @"idle", @"pulling", @"refreshing"];
//    NSLog(@"state: %@ -> %@", stateArr[oldState], stateArr[state]);
    switch (state) {
        case MJRefreshHeaderStateIdle: {
            if (oldState == MJRefreshHeaderStateRefreshing) {
                [self stopSpin];
                
                if (![self canDismissSpin]) {
                    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(MJRefreshFastAnimationDuration * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                        self.state = MJRefreshHeaderStateIdle;
                    });
                    return; // 动画还没有播放完
                }
            } else {
                
            }
            break;
        }
            
        case MJRefreshHeaderStatePulling: {
            
            break;
        }
        case MJRefreshHeaderStateRefreshing: {
            if (oldState == MJRefreshHeaderStatePulling) {
                _spinTimes = 0; // 将计数器归零，这样最少转一圈再消失
            }
            break;
        }
            
        default:
            break;
    }
    
    // super里面有回调，应该在最后面调用
    [super setState:state];
}

- (void)setPullingHeight:(CGFloat)pullingHeight
{
    [super setPullingHeight:pullingHeight];
//    NSLog(@"%.2f",pullingHeight);
    CGFloat dampLength = pullingHeight*0.06;
    if (pullingHeight > redLineGap*2+dampLength) {
        CGFloat curY = redLineGap + self.mj_h - pullingHeight + dampLength;
        self.redLineView.frame = CGRectMake(SCREEN_WIDTH/2-circleRadius-arcWidth/2, curY, 1, pullingHeight-redLineGap*2-dampLength);
    } else {
        self.redLineView.frame = CGRectZero;
    }
    
    switch (self.state) {
        case MJRefreshHeaderStateIdle: {
            break;
        }
        case MJRefreshHeaderStatePulling: {
            break;
        }
        case MJRefreshHeaderStateRefreshing: {
            self.arcView.frame = CGRectMake(SCREEN_WIDTH/2-circleRadius, redLineGap+redLineFinalHeight - circleRadius, circleRadius*2, circleRadius*2);
            [UIView animateWithDuration:MJRefreshFastAnimationDuration animations:^{
                self.redLineView.frame = CGRectMake(SCREEN_WIDTH/2-circleRadius-arcWidth/2, redLineGap, 1, redLineFinalHeight);
            } completion:^(BOOL finished) {
                [UIView animateWithDuration:MJRefreshFastAnimationDuration animations:^{
                    self.redLineView.frame = CGRectMake(SCREEN_WIDTH/2-circleRadius-arcWidth/2, redLineGap + redLineFinalHeight, 1, 0);
                    
                    CAShapeLayer* shapeLayer = [CAShapeLayer layer];
                    shapeLayer.frame = _arcView.bounds;
                    [_arcView.layer addSublayer:shapeLayer];
                    
                    CGPathRef arcPath = [UIBezierPath bezierPathWithArcCenter:CGPointMake(_arcView.bounds.size.width / 2.0, _arcView.bounds.size.height / 2.0) radius:circleRadius startAngle:M_PI endAngle:0 clockwise:NO].CGPath;
                    shapeLayer.path = arcPath;
                    
                    shapeLayer.lineWidth = 1;
                    shapeLayer.strokeColor = COLOR_BUTTONLINE_BG.CGColor;
                    shapeLayer.fillColor = [UIColor clearColor].CGColor;
                    
                    CABasicAnimation* animateStrokeEnd = [CABasicAnimation animation];
                    animateStrokeEnd.keyPath = @"strokeEnd";
                    animateStrokeEnd.duration = MJRefreshFastAnimationDuration;
                    animateStrokeEnd.fromValue = @0.0;
                    animateStrokeEnd.toValue = @1.0;
                    animateStrokeEnd.fillMode = kCAFillModeForwards;
                    animateStrokeEnd.removedOnCompletion = NO;
                    [shapeLayer addAnimation:animateStrokeEnd forKey:@"animateStrokeEnd"];
                } completion:^(BOOL finished) {
                    [self startSpin];
                }];
            }];
            break;
        }
        default:
            break;
    }
}

- (void)spin {
//    NSLog(@"%zd", _spinTimes);
    [UIView animateWithDuration:MJRefreshFastAnimationDuration/2
                          delay:0
                        options:UIViewAnimationOptionCurveLinear
                     animations: ^{
                         _arcView.transform = CGAffineTransformRotate(_arcView.transform, -M_PI / 2);
                     }
                     completion: ^(BOOL finished) {
                         ++_spinTimes;
                         if (_isAnimating || ![self canDismissSpin]) {
                             // if flag still set, keep spinning with constant speed
                             [self spin];
                         } else if (_isAnimating || [self canDismissSpin]) {
                             self.outView.frame = CGRectMake(SCREEN_WIDTH/2+circleRadius, redLineGap+redLineFinalHeight, 1, 0);
                             [UIView animateWithDuration:MJRefreshFastAnimationDuration animations:^{
                                 self.outView.frame = CGRectMake(SCREEN_WIDTH/2+circleRadius, 0, 1, redLineGap+redLineFinalHeight);
                                 
                                 CABasicAnimation* animateStrokeStart = [CABasicAnimation animation];
                                 animateStrokeStart.keyPath = @"strokeStart";
                                 animateStrokeStart.duration = MJRefreshFastAnimationDuration;
                                 animateStrokeStart.fromValue = @0.0;
                                 animateStrokeStart.toValue = @1.0;
                                 animateStrokeStart.fillMode = kCAFillModeForwards;
                                 animateStrokeStart.removedOnCompletion = NO;
                                 for (CALayer* layer in _arcView.layer.sublayers) {
                                     if ([layer isKindOfClass:[CAShapeLayer class]]) {
                                         [layer addAnimation:animateStrokeStart forKey:@"animateStrokeStart"];
                                     }
                                 }
                             } completion:^(BOOL finished) {
                                 // 清除_arcView
                                 [_arcView removeFromSuperview];
                                 _arcView = nil;
                                 [UIView animateWithDuration:0.15 animations:^{
                                     self.outView.frame = CGRectMake(SCREEN_WIDTH/2+circleRadius, 0, 1, 0);
                                 } completion:nil];
                             }];
                         }
                     }];
}

- (void)startSpin {
    if (!_isAnimating) {
        _isAnimating = YES;
        [self spin];
    }
}

- (void)stopSpin {
    _isAnimating = NO;
}

- (BOOL)canDismissSpin
{
    return (_spinTimes && _spinTimes%4 == 0);
}

@end
