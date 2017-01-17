//
//  UIImage+scale.h
//  i8WorkClient
//
//  Created by 郭通 on 15/12/3.
//  Copyright © 2015年 郭通. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UIImage(scale)

- (CGSize )bubbleImageSize;
- (UIImage *)fixOrientation;
- (UIImage *)scaleImage;
- (UIImage *)scaleImage:(CGSize)size;
- (UIImage*)imageByScalingAndCroppingForSize:(CGSize)targetSize;
- (NSData *) scaleImageFileSize:(float) fileSize;

+ (UIImage *) imageWithColor:(UIColor *)color withSize:(CGSize )size;
+ (float)coefficientOfCompressibilityForImage:(UIImage*)image;

@end
