//
//  NSString+Json.m
//  i8WorkClient
//
//  Created by 郭通 on 15/10/31.
//  Copyright © 2015年 郭通. All rights reserved.
//

#import "NSString+Json.h"

@implementation NSString(Json)

- (id) objectValue
{
    NSData *jsonData = [self dataUsingEncoding:NSUTF8StringEncoding];
    return [NSJSONSerialization JSONObjectWithData:jsonData options:0 error:nil];
}

-(NSString *)trim{
    return  [self stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
}

@end
