//
//  NSMutableArray+MGJ.h
//  MGJiPhoneSDK
//
//  Created by kunka on 14-6-20.
//  Copyright (c) 2014年 juangua. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 *  NSMutableArray 扩展
 */
@interface NSMutableArray (Safe)
/**
 *  添加对象到数组，内部做空值保护
 *
 *  @param anObject object
 */
- (void)addSafeObject:(id)anObject;
@end

/**
 *  NSArray 扩展
 */
@interface NSArray (NullCheck)

/**
 *  获取数组中指定索引的对象，超出数组范围时返回空
 *
 *  @param index 索引
 *
 *  @return 数组中指定索引的对象，超出数组范围时返回空
 */
- (id)safeObjectAtIndex:(NSInteger)index;

/**
 *  获取数组最后一位索引的对象
 *
 *  @return 最后一位索引的对象
 */
- (id)safeObjectAtLastIndex;
@end