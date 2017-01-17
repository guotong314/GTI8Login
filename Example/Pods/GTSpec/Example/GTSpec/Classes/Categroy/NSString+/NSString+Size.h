//
//  NSString+Size.h
//  i8WorkClient
//
//  Created by 郭通 on 16/12/1.
//  Copyright © 2016年 郭通. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString(Size)

- (CGSize) getSize:(UIFont *)font withMaxSize:(CGSize)size;

@end
