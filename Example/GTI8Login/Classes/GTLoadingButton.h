//
//  GTLoadingButton.h
//  GTI8Login
//
//  Created by 郭通 on 17/2/6.
//  Copyright © 2017年 郭通. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GTLoadingButton : UIButton

@property (nonatomic, strong) UIActivityIndicatorView *activityView;

- (void) startAnimation;
- (void) stopAnimation;

@end
