//
//  GTLoginButton.h
//  GTI8Login
//
//  Created by 郭通 on 17/1/16.
//  Copyright © 2017年 郭通. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^finishBlock)();

@interface GTLoginButton : UIView

@property (nonatomic,copy) finishBlock translateBlock;
@property (nonatomic,copy) void (^clickBlock)() ;
@property (nonatomic, copy) NSString *btnTitle;

- (void) restoreButton;

-(void) clickAnimation;

@end
