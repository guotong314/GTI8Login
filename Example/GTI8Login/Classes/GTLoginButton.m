//
//  GTLoginButton.m
//  GTI8Login
//
//  Created by 郭通 on 17/1/16.
//  Copyright © 2017年 郭通. All rights reserved.
//

#import "GTLoginButton.h"

#define RECT  CGRectMake(0, 0, UI_SCREEN_WIDTH - 60, 40)
#define COLOR_Login RGBA(55, 117, 189, 1)

@interface GTLoginButton()

//渲染层
@property (nonatomic,strong) CAShapeLayer *maskLayer;

@property (nonatomic,strong) CAShapeLayer *shapeLayer;

@property (nonatomic,strong) CAShapeLayer *loadingLayer;

@property (nonatomic,strong) CAShapeLayer *clickCicrleLayer;

@property (nonatomic,strong) UIButton *button;

@end


@implementation GTLoginButton

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
-(instancetype)initWithFrame:(CGRect)frame{
    if(self = [super initWithFrame:frame]){
//        self.backgroundColor = [UIColor yellowColor];
        //        _shapeLayer = [self drawMask:frame.size.height/2];
        //        _shapeLayer.fillColor = [UIColor clearColor].CGColor;
        //        _shapeLayer.strokeColor = [UIColor whiteColor].CGColor;
        //        _shapeLayer.lineWidth = 2;
        //        [self.layer addSublayer:_shapeLayer];
        //
        //        [self.layer addSublayer:self.maskLayer];
        //
        //        _button = [UIButton buttonWithType:UIButtonTypeCustom];
        //        _button.frame = self.bounds;
        //        [_button setTitle:@"SIGN IN" forState:UIControlStateNormal];
        //        [_button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        //        _button.titleLabel.font = [UIFont systemFontOfSize:13.f];
        //        [self addSubview:_button];
        //        [_button addTarget:self action:@selector(clickBtn) forControlEvents:UIControlEventTouchUpInside];
        [self restoreButton];
        
    }
    return self;
}

-(CAShapeLayer *)maskLayer{
    if(!_maskLayer){
        _maskLayer = [CAShapeLayer layer];
        _maskLayer.opacity = 0;
        _maskLayer.fillColor = [UIColor whiteColor].CGColor;
        _maskLayer.path = [self drawBezierPath:RECT.size.width/2].CGPath;
    }
    return _maskLayer;
}

-(void)layoutSubviews{
    [super layoutSubviews];
    
}



-(void)clickBtn{
    if (self.clickBlock) {
        self.clickBlock();
    }
}

-(void)clickAnimation{
    CAShapeLayer *clickCicrleLayer = [CAShapeLayer layer];
    clickCicrleLayer.position = CGPointMake(RECT.size.width/2, RECT.size.height/2);
    clickCicrleLayer.fillColor = [UIColor whiteColor].CGColor;
    clickCicrleLayer.path = [self drawclickCircleBezierPath:0].CGPath;
    [self.layer addSublayer:clickCicrleLayer];
    
    CABasicAnimation *basicAnimation = [CABasicAnimation animationWithKeyPath:@"path"];
    basicAnimation.duration = 0.15;
    basicAnimation.toValue = (__bridge id _Nullable)([self drawclickCircleBezierPath:(self.bounds.size.height - 10*2)/2].CGPath);
    basicAnimation.removedOnCompletion = NO;
    basicAnimation.fillMode = kCAFillModeForwards;
    
    [clickCicrleLayer addAnimation:basicAnimation forKey:@"clickCicrleAnimation"];
    
    _clickCicrleLayer = clickCicrleLayer;
    
    [self performSelector:@selector(clickNextAnimation) withObject:self afterDelay:basicAnimation.duration];
}

-(void)clickNextAnimation{
    _clickCicrleLayer.fillColor = [UIColor clearColor].CGColor;
    _clickCicrleLayer.strokeColor = [UIColor whiteColor].CGColor;
    _clickCicrleLayer.lineWidth = 10;
    
    CAAnimationGroup *animationGroup = [CAAnimationGroup animation];
    
    CABasicAnimation *basicAnimation = [CABasicAnimation animationWithKeyPath:@"path"];
    basicAnimation.duration = 0.15;
    basicAnimation.toValue = (__bridge id _Nullable)([self drawclickCircleBezierPath:(self.bounds.size.height - 10*2)].CGPath);
    basicAnimation.removedOnCompletion = NO;
    basicAnimation.fillMode = kCAFillModeForwards;
    
    CABasicAnimation *basicAnimation1 = [CABasicAnimation animationWithKeyPath:@"opacity"];
    basicAnimation1.beginTime = 0.10;
    basicAnimation1.duration = 0.15;
    basicAnimation1.toValue = @0;
    basicAnimation1.removedOnCompletion = NO;
    basicAnimation1.fillMode = kCAFillModeForwards;
    
    animationGroup.duration = basicAnimation1.beginTime + basicAnimation1.duration;
    animationGroup.removedOnCompletion = NO;
    animationGroup.fillMode = kCAFillModeForwards;
    animationGroup.animations = @[basicAnimation,basicAnimation1];
    
    [_clickCicrleLayer addAnimation:animationGroup forKey:@"clickCicrleAnimation1"];
    
    [self performSelector:@selector(startMaskAnimation) withObject:self afterDelay:animationGroup.duration];
    
}

-(void)startMaskAnimation{
    _maskLayer.opacity = 0.15;
    CABasicAnimation *basicAnimation = [CABasicAnimation animationWithKeyPath:@"path"];
    basicAnimation.duration = 0.25;
    basicAnimation.toValue = (__bridge id _Nullable)([self drawBezierPath:RECT.size.height/2].CGPath);
    basicAnimation.removedOnCompletion = NO;
    basicAnimation.fillMode = kCAFillModeForwards;
    [_maskLayer addAnimation:basicAnimation forKey:@"maskAnimation"];
    
    [self performSelector:@selector(dismissAnimation) withObject:self afterDelay:basicAnimation.duration+0.2];
}

-(void)dismissAnimation{
    [self removeSubViews];
    
    CAAnimationGroup *animationGroup = [CAAnimationGroup animation];
    
    CABasicAnimation *basicAnimation = [CABasicAnimation animationWithKeyPath:@"path"];
    basicAnimation.duration = 0.15;
    basicAnimation.toValue = (__bridge id _Nullable)([self drawBezierPath:RECT.size.width/2].CGPath);
    basicAnimation.removedOnCompletion = NO;
    basicAnimation.fillMode = kCAFillModeForwards;
    
    CABasicAnimation *basicAnimation1 = [CABasicAnimation animationWithKeyPath:@"opacity"];
    basicAnimation1.beginTime = 0.10;
    basicAnimation1.duration = 0.15;
    basicAnimation1.toValue = @0;
    basicAnimation1.removedOnCompletion = NO;
    basicAnimation1.fillMode = kCAFillModeForwards;
    
    animationGroup.animations = @[basicAnimation,basicAnimation1];
    animationGroup.duration = basicAnimation1.beginTime+basicAnimation1.duration;
    animationGroup.removedOnCompletion = NO;
    animationGroup.fillMode = kCAFillModeForwards;
    [_shapeLayer addAnimation:animationGroup forKey:@"dismissAnimation"];
    
    [self performSelector:@selector(loadingAnimation) withObject:self afterDelay:animationGroup.duration];
}



-(void)loadingAnimation{
    _loadingLayer = [CAShapeLayer layer];
    _loadingLayer.position = CGPointMake(RECT.size.width/2, RECT.size.height/2);
    _loadingLayer.fillColor = [UIColor clearColor].CGColor;
    _loadingLayer.strokeColor = COLOR_Login.CGColor;
    _loadingLayer.lineWidth = 2;
    _loadingLayer.path = [self drawLoadingBezierPath].CGPath;
    [self.layer addSublayer:_loadingLayer];
    
    CABasicAnimation *basicAnimation = [CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
    basicAnimation.fromValue = @(0);
    basicAnimation.toValue = @(M_PI*2);
    basicAnimation.duration = 0.5;
    basicAnimation.repeatCount = LONG_MAX;
    [_loadingLayer addAnimation:basicAnimation forKey:@"loadingAnimation"];
    
    [self performSelector:@selector(removeAllAnimation) withObject:self afterDelay:1];
    //     [self performSelector:@selector(restoreButton) withObject:self afterDelay:3];
}
- (void) restoreButton
{
    [_loadingLayer removeFromSuperlayer];
    [_clickCicrleLayer removeFromSuperlayer];
    
    _shapeLayer = [self drawMask:RECT.size.height/2];
    _shapeLayer.fillColor = COLOR_Login.CGColor;
    _shapeLayer.strokeColor = COLOR_Login.CGColor;
    _shapeLayer.lineWidth = 2;
    [self.layer addSublayer:_shapeLayer];
    
    [self.layer addSublayer:self.maskLayer];
    
    _button = [UIButton buttonWithType:UIButtonTypeCustom];
    [_button setTitle:self.btnTitle forState:UIControlStateNormal];
    [_button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    _button.titleLabel.font = [UIFont systemFontOfSize:13.f];
    [self addSubview:_button];
    [_button addTarget:self action:@selector(clickBtn) forControlEvents:UIControlEventTouchUpInside];
    @weakify(self);
    [self.button mas_makeConstraints:^(MASConstraintMaker *make) {
        @strongify(self);
        make.left.top.bottom.right.mas_equalTo(self);
    }];
    
}
- (void) setBtnTitle:(NSString *)btnTitle
{
    _btnTitle = btnTitle;
    [_button setTitle:self.btnTitle forState:UIControlStateNormal];
}
-(void)removeSubViews{
    [_button removeFromSuperview];
    [_maskLayer removeFromSuperlayer];
    [_loadingLayer removeFromSuperlayer];
    [_clickCicrleLayer removeFromSuperlayer];
}

-(void)removeAllAnimation{
    //    [self removeSubViews];
    if(self.translateBlock){
        
        self.translateBlock();
    }
}


-(CAShapeLayer *)drawMask:(CGFloat)x{
    CAShapeLayer *shapeLayer = [CAShapeLayer layer];
    shapeLayer.frame = RECT;
    shapeLayer.path = [self drawBezierPath:x].CGPath;
    return shapeLayer;
}

-(UIBezierPath *)drawBezierPath:(CGFloat)x{
    CGFloat radius = RECT.size.height/2 - 3;
    CGFloat right = RECT.size.width-x;
    CGFloat left = x;
    
    UIBezierPath *bezierPath = [UIBezierPath bezierPath];
    bezierPath.lineJoinStyle = kCGLineJoinRound;
    bezierPath.lineCapStyle = kCGLineCapRound;
    
    [bezierPath addArcWithCenter:CGPointMake(right, RECT.size.height/2) radius:radius startAngle:-M_PI/2 endAngle:M_PI/2 clockwise:YES];
    [bezierPath addArcWithCenter:CGPointMake(left, RECT.size.height/2) radius:radius startAngle:M_PI/2 endAngle:-M_PI/2 clockwise:YES];
    [bezierPath closePath];
    
    return bezierPath;
}


-(UIBezierPath *)drawLoadingBezierPath{
    CGFloat radius = RECT.size.height/2 - 3;
    UIBezierPath *bezierPath = [UIBezierPath bezierPath];
    [bezierPath addArcWithCenter:CGPointMake(0,0) radius:radius startAngle:M_PI/2 endAngle:M_PI/2+M_PI/2 clockwise:YES];
    return bezierPath;
}

-(UIBezierPath *)drawclickCircleBezierPath:(CGFloat)radius{
    UIBezierPath *bezierPath = [UIBezierPath bezierPath];
    [bezierPath addArcWithCenter:CGPointMake(0,0) radius:radius startAngle:0 endAngle:M_PI*2 clockwise:YES];
    return bezierPath;
}
@end
