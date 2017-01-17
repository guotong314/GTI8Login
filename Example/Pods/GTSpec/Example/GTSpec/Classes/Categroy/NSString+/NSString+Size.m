//
//  NSString+Size.m
//  i8WorkClient
//
//  Created by 郭通 on 16/12/1.
//  Copyright © 2016年 郭通. All rights reserved.
//

#import "NSString+Size.h"

@implementation NSString(Size)

- (CGSize) getSize:(UIFont *)font withMaxSize:(CGSize)size
{
    NSDictionary  *attributes = @{NSFontAttributeName:font};
    return [self boundingRectWithSize:size options:NSStringDrawingUsesLineFragmentOrigin attributes:attributes context:nil].size;
}

@end
