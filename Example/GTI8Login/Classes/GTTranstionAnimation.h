//
//  GTTranstionAnimation.h
//  GTI8Login
//
//  Created by 郭通 on 17/1/17.
//  Copyright © 2017年 郭通. All rights reserved.
//

#import <Foundation/Foundation.h>
typedef NS_ENUM(NSUInteger, XWPresentOneTransitionType) {
    XWPresentOneTransitionTypePresent = 0,//管理present动画
    XWPresentOneTransitionTypeDismiss//管理dismiss动画
};

@interface GTTranstionAnimation : NSObject<UIViewControllerAnimatedTransitioning,CAAnimationDelegate>

@property (nonatomic,assign) XWPresentOneTransitionType type;

+ (instancetype)transitionWithTransitionType:(XWPresentOneTransitionType)type;
- (instancetype)initWithTransitionType:(XWPresentOneTransitionType)type;

@end
