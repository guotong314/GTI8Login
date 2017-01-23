//
//  GTNavigateModule.m
//  GTRootKit
//
//  Created by 郭通 on 17/1/17.
//  Copyright © 2017年 郭通. All rights reserved.
//

#import "GTNavigateModule.h"

@implementation GTNavigateModule

+ (instancetype)sharedInstance {
    static GTNavigateModule *sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[self alloc] init];
    });
    
    return sharedInstance;
}

@end
