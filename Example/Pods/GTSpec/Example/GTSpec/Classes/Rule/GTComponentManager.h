//
//  GTComponentManager.h
//  GTEmptyView
//
//  Created by 郭通 on 17/1/6.
//  Copyright © 2017年 郭通. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GTBaseComponent.h"

@interface GTComponentManager : NSObject
/**
 *  当前已经注册的组件
 */
+ (NSArray<GTBaseComponent *> *)components;

/**
 *  使用默认的 plist 文件进行注册，默认名字为 `components.plist` (在 mainbundle 根目录下)
 */
+ (void)registerComponentsFromDefaultPlist;

/**
 *  使用自定义的 plist 文件进行注册
 *
 *  @param plistName 如果名字不带 .plist 后缀的话，会自动补上该后缀
 */
+ (void)registerComponentsFromCustomizedPlist:(NSString *)plistName;

/**
 *  推荐使用 plist 来进行注册，方便管理，如果出于某些原因，不想那么做，那么可以直接调用这个方法
 *
 *  @param components 传进来的都是 GTBaseComponent 的单例
 */
+ (void)registerComponents:(NSArray <GTBaseComponent *> *)components;

@end
