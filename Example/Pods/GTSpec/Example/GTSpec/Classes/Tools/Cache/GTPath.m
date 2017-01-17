//
//  DMPath.m
//  i8WorkClient
//
//  Created by 郭通 on 16/7/8.
//  Copyright © 2016年 郭通. All rights reserved.
//

#import "GTPath.h"

@implementation GTPath

+ (NSString *)documentPath {
    static NSString *path = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        path = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)[0] copy];
    });
    return path;
}


@end
