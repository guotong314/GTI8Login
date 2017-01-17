//
//  GTEmptyView.h
//  GTEmptyView
//
//  Created by 郭通 on 16/5/15.
//  Copyright © 2016年 郭通. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GTEmptyView : UIView

+(void)showInView:(UIView *)aView
         withText:(NSString *)text
        withImage:(UIImage *)image;

+(void)showInView:(UIView *)aView
         withText:(NSString *)text
        withImage:(UIImage *)image
  withButtonTitle:(NSString *)buttonTitle
withButtonHandler:(void (^)(void))buttonHandler;

+ (void)showInView:(UIView *)aView
          withText:(NSString *)text
         withImage:(UIImage *)image
   withButtonTitle:(NSString *)buttonTitle
 withButtonHandler:(void(^)(void))buttonHandler
        withOffset:(CGPoint)offset;

+ (void)removeFromView:(UIView *)aView;
@end
