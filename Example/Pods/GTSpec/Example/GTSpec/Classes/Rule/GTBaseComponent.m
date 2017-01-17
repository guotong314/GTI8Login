//
//  GTBaseComponent.m
//  GTEmptyView
//
//  Created by 郭通 on 17/1/6.
//  Copyright © 2017年 郭通. All rights reserved.
//

#import "GTBaseComponent.h"
#import <objc/runtime.h>

@implementation GTBaseComponent

+ (instancetype)sharedInstance
{
    @synchronized (self)
    {
        id instance = objc_getAssociatedObject(self, _cmd);
        if (!instance)
        {
            instance = [[self alloc] init];
            objc_setAssociatedObject(self, _cmd, instance, OBJC_ASSOCIATION_RETAIN);
        }
        return instance;
    }
}

@end
