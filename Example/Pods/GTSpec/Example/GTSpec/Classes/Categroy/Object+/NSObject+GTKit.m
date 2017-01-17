//
//  NSObject+GTKit.m
//  GTSpec
//
//  Created by 郭通 on 17/1/12.
//  Copyright © 2017年 郭通. All rights reserved.
//

#import "NSObject+GTKit.h"

@implementation NSObject(GTKit)

- (void)ddObserveNotification:(NSString *)notificationName handler:(void(^)(NSNotification *notification))handler
{
    [[NSNotificationCenter defaultCenter] addObserverForName:notificationName object:nil queue:[NSOperationQueue mainQueue] usingBlock:^(NSNotification *note) {
        if (handler) {
            handler(note);
        }
    }];
}

- (void)ddObserve:(id)target keyPath:(NSString *)keyPath block:(void (^)(NSDictionary *change))block
{
    [self ddObserve:target keyPath:keyPath options:(NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld) block:^(NSDictionary *change) {
        if (block) {
            block(change);
        }
    }];
}

- (void)ddObserve:(id)target keyPath:(NSString *)keyPath options:(NSKeyValueObservingOptions)options block:(void (^)(NSDictionary *change))block
{
    [self.KVOController observe:target keyPath:keyPath options:options block:^(id observer, id object, NSDictionary *change) {
        if (block) {
            block(change);
        }
    }];
}

- (void)ddUnobserve:(id)target keyPath:(NSString *)keyPath
{
    keyPath.length ? [self.KVOController unobserve:target keyPath:keyPath] : [self.KVOController unobserve:target];
}

- (NSString *)ddDescription
{
    return [NSString stringWithFormat:@"[%@ {%@}]", NSStringFromClass([self class]), [self ddAutoDescriptionForClassType:[self class]]];
}

- (NSString *)ddAutoDescriptionForClassType:(Class)classType {
    
    NSMutableString * result = [NSMutableString string];
    
    unsigned int property_count;
    objc_property_t * property_list = class_copyPropertyList(classType, &property_count); // Must Free, later
    
    [result appendFormat:@"\n<%@>\n", classType];
    
    for (int i = property_count - 1; i >= 0; --i) {
        objc_property_t property = property_list[i];
        
        const char * property_name = property_getName(property);
        
        NSString * propertyName = [NSString stringWithCString:property_name encoding:NSASCIIStringEncoding];
        if (propertyName) {
            // 去掉私有属性，并再做一次判断，有时会出现该属性虽然存在但并不响应该属性的情况
            if (![[propertyName substringToIndex:1] isEqualToString: @"_"] && [self respondsToSelector:NSSelectorFromString(propertyName)]) {
                id<NSObject> value = [self valueForKey:propertyName];
                
                [result appendFormat:@"  [%@] = %@; \n", propertyName, value ? value.description : @"<nil>"];
            }
        }
    }
    
    [result appendFormat:@"<%@ />\n", classType];
    
    free(property_list);
    
    Class superClass  = class_getSuperclass(classType);
    if  ( superClass != nil && ![superClass isEqual:[NSObject class]])
    {
        [result appendString:[self ddAutoDescriptionForClassType:superClass]];
    }
    
    return result;
}

@end
