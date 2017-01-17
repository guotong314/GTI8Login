//
//  NSMutableArray+MGJ.m
//  MGJiPhoneSDK
//
//  Created by kunka on 14-6-20.
//  Copyright (c) 2014年 juangua. All rights reserved.
//

#import "NSArray+Safe.h"

@implementation NSMutableArray (Safe)
- (void)addSafeObject:(id)anObject
{
    if (anObject) {
        [self addObject:anObject];
    }
}
@end


@implementation NSArray (Safe)

- (id)safeObjectAtIndex:(NSInteger)index
{
    id obj = nil;
    if (index < self.count) {
        obj = [self objectAtIndex:index];
    }
    return obj;
}

- (id)safeObjectAtLastIndex {
    id obj = nil;
    obj = [self objectAtIndex:self.count-1];
    return obj;
}

@end