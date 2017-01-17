//
//  GTRemindView.m
//  GTSpec
//
//  Created by 郭通 on 17/1/4.
//  Copyright © 2017年 郭通. All rights reserved.
//

#import "GTRemindView.h"
@interface GTRemindView()
{
    UIView *containerView;
    UILabel *remindShowLabel;
}
@end

@implementation GTRemindView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
- (instancetype)initWithMessage:(NSString *)message {
    
    if (self = [super init]) {
        [self setMessage:message];
    }
    
    return self;
}

+ (void)showWithMesssage:(NSString *)aMessage {
    GTRemindView *view = [[GTRemindView alloc] initWithMessage:aMessage];
    [APPWINDOW addSubview:view];
    [APPWINDOW bringSubviewToFront:view];
    [view showAnimation];
}

- (void)setMessage:(NSString *)message {
    self.frame = CGRectMake(0, 0, UI_SCREEN_WIDTH, UI_SCREEN_HEIGHT);
    self.backgroundColor = [UIColor clearColor];
    
    containerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, UI_SCREEN_WIDTH, UI_SCREEN_HEIGHT)];
    containerView.backgroundColor = [UIColor colorWithWhite:0 alpha:0.7];
    containerView.layer.masksToBounds = YES;
    
    remindShowLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width - 140, self.frame.size.height - 20)];
    remindShowLabel.text = message;
    remindShowLabel.backgroundColor = [UIColor clearColor];
    remindShowLabel.font = FONT_(15);
    remindShowLabel.numberOfLines = 0;
    remindShowLabel.textColor = [UIColor whiteColor];
    remindShowLabel.textAlignment = NSTextAlignmentCenter;
    
    [remindShowLabel sizeToFit];
    containerView.width =  remindShowLabel.width + 50;
    containerView.height = remindShowLabel.height + 30;
    
    remindShowLabel.center = CGPointMake(containerView.center.x, containerView.frame.size.height/2.0);
    containerView.center = self.center;
    containerView.layer.cornerRadius = containerView.frame.size.height/180 * 20;
    
    [containerView addSubview:remindShowLabel];
    [self addSubview:containerView];
    
    self.alpha = 0;
}

#pragma mark - self method

- (void)showAnimation {
    
    [UIView animateWithDuration:0.2 animations:^{
        
        self.alpha = 1.0;
        
    } completion:^(BOOL finished) {
        
        [self performSelector:@selector(dismissAnimation)
                   withObject:nil
                   afterDelay:1.5];
        
    }];
    
}

- (void)dismissAnimation {
    
    [UIView animateWithDuration:0.2 animations:^{
        
        self.alpha = 0.0;
        
    } completion:^(BOOL finished) {
        
        [self removeFromSuperview];
        
    }];
}

@end
