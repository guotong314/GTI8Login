//
//  NSObject+GTKit.h
//  GTSpec
//
//  Created by 郭通 on 17/1/12.
//  Copyright © 2017年 郭通. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <KVOController/FBKVOController.h>
#import <objc/runtime.h>
#import "NSObject+FBKVOController.h"

@interface NSObject(GTKit)

/**
 *  处理通知消息
 *
 *  @param notificationName
 *  @param handler
 */
- (void)ddObserveNotification:(NSString *)notificationName handler:(void(^)(NSNotification *notification))handler;

/**
 *  添加KVO监听，options默认是 NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld 的
 *
 *  @param target
 *  @param keyPath
 *  @param block
 */
- (void)ddObserve:(id)target keyPath:(NSString *)keyPath block:(void (^)(NSDictionary *change))block;

/**
 *  添加KVO监听
 *
 *  @param target
 *  @param keyPath
 *  @param options
 *  @param block
 */
- (void)ddObserve:(id)target keyPath:(NSString *)keyPath options:(NSKeyValueObservingOptions)options block:(void (^)(NSDictionary *change))block;

/**
 *  移除监听
 *
 *  @param target
 *  @param keyPath
 */
- (void)ddUnobserve:(id)target keyPath:(NSString *)keyPath;

/**
 *  输出NSObject的description
 *
 *  @return
 */
- (NSString *)ddDescription;


@end
