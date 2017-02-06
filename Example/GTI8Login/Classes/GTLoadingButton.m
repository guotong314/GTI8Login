//
//  GTLoadingButton.m
//  GTI8Login
//
//  Created by 郭通 on 17/2/6.
//  Copyright © 2017年 郭通. All rights reserved.
//

#import "GTLoadingButton.h"
#import <GTSpec/NSString+Size.h>

@implementation GTLoadingButton

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
- (instancetype) initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.activityView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
        [self addSubview:self.activityView];
    }
    return self;
}
- (void) startAnimation
{
    NSLog(@"%@,%f",NSStringFromCGRect(self.frame),self.centerX);
    CGFloat halfButtonHeight = self.bounds.size.height / 2;
//    CGFloat buttonWidth = self.bounds.size.width;
    CGSize titleSize = [self.titleLabel.text getSize:self.titleLabel.font withMaxSize:self.size];
    self.activityView.centerY = halfButtonHeight;
    self.activityView.right = (self.width - titleSize.width)/2 - 4;
    [self.activityView startAnimating];
    self.activityView.hidden = NO;
}
- (void) stopAnimation
{
    [self.activityView stopAnimating];
    self.activityView.hidden = YES;
}
@end
