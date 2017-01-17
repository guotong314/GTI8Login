//
//  GTBaseViewController.h
//  GTRootKit
//
//  Created by 郭通 on 17/1/11.
//  Copyright © 2017年 郭通. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MJRefresh.h"

@interface GTBaseViewController : UIViewController

@property(nonatomic,copy)NSString* navTitle;

-(void)addLeftBarButtonWithTitle:(NSString*)title
                           image:(UIImage*)image
                 backgroundImage:(UIImage*)background
                          action:(SEL)action;

-(void)addRightBarButtonWithTitle:(NSString*)title
                            image:(UIImage*)image
                  backgroundImage:(UIImage*)background
                           action:(SEL)action;

- (void)activityViewStartAnimating;
- (void)activityViewEndAnimating;

- (void) goBack;
- (void)fixSwipeBack;

- (void) loadSubviews;

- (void)prepareTabbarItem;

@end
