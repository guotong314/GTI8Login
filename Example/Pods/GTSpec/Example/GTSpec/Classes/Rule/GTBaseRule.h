//
//  GTBaseRule.h
//  GTEmptyView
//
//  Created by 郭通 on 17/1/6.
//  Copyright © 2017年 郭通. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void (^GTRouterHandler)(NSDictionary *routerParameters);

@interface GTBaseRule : NSObject

+ (instancetype)sharedIsntance;


+ (void)registerURLPattern:(NSString *)URLPattern toHandler:(GTRouterHandler)handler;

/**
 *  打开此 URL
 *  会在已注册的 URL -> Handler 中寻找，如果找到，则执行 Handler
 *
 *  @param URL 带 Scheme，如 mgj://beauty/3
 */
+ (void)openURL:(NSString *)URL;

/**
 *  打开此 URL，同时当操作完成时，执行额外的代码
 *
 *  @param URL        带 Scheme 的 URL，如 mgj://beauty/4
 *  @param completion URL 处理完成后的 callback，完成的判定跟具体的业务相关
 */
+ (void)openURL:(NSString *)URL completion:(void (^)(id result))completion;

/**
 *  打开此 URL，带上附加信息，同时当操作完成时，执行额外的代码
 *
 *  @param URL        带 Scheme 的 URL，如 mgj://beauty/4
 *  @param parameters 附加参数
 *  @param completion URL 处理完成后的 callback，完成的判定跟具体的业务相关
 */
+ (void)openURL:(NSString *)URL withUserInfo:(NSDictionary *)userInfo completion:(void (^)(id result))completion;

@end
