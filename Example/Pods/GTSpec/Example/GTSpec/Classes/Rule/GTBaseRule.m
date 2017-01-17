//
//  GTBaseRule.m
//  GTEmptyView
//
//  Created by 郭通 on 17/1/6.
//  Copyright © 2017年 郭通. All rights reserved.
//

#import "GTBaseRule.h"

static NSString * const GT_ROUTER_WILDCARD_CHARACTER = @"~";

@interface GTBaseRule()

@property (nonatomic) NSMutableDictionary *routes;

@end


@implementation GTBaseRule
+ (instancetype)sharedIsntance
{
    static GTBaseRule *instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[self alloc] init];
    });
    return instance;
}
+ (void)registerURLPattern:(NSString *)URLPattern toHandler:(GTRouterHandler)handler
{
    [[self sharedIsntance] addURLPattern:URLPattern andHandler:handler];
}

- (NSArray*)pathComponentsFromURL:(NSString*)URL
{
    NSMutableArray *pathComponents = [NSMutableArray array];
    if ([URL rangeOfString:@"://"].location != NSNotFound) {
        NSArray *pathSegments = [URL componentsSeparatedByString:@"://"];
        // 如果 URL 包含协议，那么把协议作为第一个元素放进去
        [pathComponents addObject:pathSegments[0]];
        
        // 如果只有协议，那么放一个占位符
//        if ((pathSegments.count == 2 && MGJ_IS_EMPTY(pathSegments[1])) || pathSegments.count < 2) {
//            [pathComponents addObject:MGJ_ROUTER_WILDCARD_CHARACTER];
//        }
        
        URL = [URL substringFromIndex:[URL rangeOfString:@"://"].location + 3];
        
        // 修复特定的 URL，比如 Pinterest 会返回 pinxxx://?success=0
        if (URL.length && [[URL substringToIndex:1] isEqualToString:@"?"]) {
            URL = [URL substringFromIndex:1];
        }
    }
    
    for (NSString *pathComponent in [[NSURL URLWithString:URL] pathComponents]) {
        if ([pathComponent isEqualToString:@"/"]) continue;
        if ([[pathComponent substringToIndex:1] isEqualToString:@"?"]) break;
        [pathComponents addObject:pathComponent];
    }
    return [pathComponents copy];
}

- (NSMutableDictionary *)addURLPattern:(NSString *)URLPattern
{
    NSArray *pathComponents = [self pathComponentsFromURL:URLPattern];
    
    NSInteger index = 0;
    NSMutableDictionary* subRoutes = self.routes;
    
    while (index < pathComponents.count) {
        NSString* pathComponent = pathComponents[index];
        if (![subRoutes objectForKey:pathComponent]) {
            subRoutes[pathComponent] = [[NSMutableDictionary alloc] init];
        }
        subRoutes = subRoutes[pathComponent];
        index++;
    }
    return subRoutes;
}

- (void)addURLPattern:(NSString *)URLPattern andHandler:(GTRouterHandler)handler
{
    NSMutableDictionary *subRoutes = [self addURLPattern:URLPattern];
    if (handler && subRoutes) {
        subRoutes[@"_"] = [handler copy];
    }
}


+ (void)openURL:(NSString *)URL
{
    [self openURL:URL completion:nil];
}

+ (void)openURL:(NSString *)URL completion:(void (^)(id result))completion
{
    [self openURL:URL withUserInfo:nil completion:completion];
}

+ (void)openURL:(NSString *)URL withUserInfo:(NSDictionary *)userInfo completion:(void (^)(id result))completion
{
    URL = [URL trim];
    GTBaseRule *router = [GTBaseRule sharedIsntance];
    
//    if (URL.length > 0) {
//        NSMutableString *result = [NSMutableString stringWithString:URL];
//        for (NSDictionary *rule in router.replaceRuleList) {
//            NSError *error = nil;
//            NSRegularExpression *reg = [[NSRegularExpression alloc] initWithPattern:rule[@"pattern"] options:0 error:&error];
//            if (!error) {
//                NSInteger matches = [reg replaceMatchesInString:result options:0 range:NSMakeRange(0, result.length) withTemplate:rule[@"replace"]];
//                if (matches > 0) {
//                    break;
//                }
//            }
//        }
//        URL = result;
//    }
//    
    if (!URL) {
//        if ([router.delegate respondsToSelector:@selector(router:didFailOpenWithURL:withUserInfo:)]) {
//            [router.delegate router:router didFailOpenWithURL:@"nil" withUserInfo:userInfo];
//        }
        return;
    }
    
//    if ([router.delegate respondsToSelector:@selector(router:shouldOpenURL:withUserInfo:completion:)]&& ![router.delegate router:router shouldOpenURL:URL withUserInfo:userInfo completion:completion]) {
//        return;
//    }
    
    URL = [URL stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSMutableDictionary *parameters = [router extractParametersFromURL:URL];
    
    [parameters enumerateKeysAndObjectsUsingBlock:^(id key, NSString *obj, BOOL *stop) {
        if ([obj isKindOfClass:[NSString class]]) {
            parameters[key] = [obj stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        }
    }];
    
    GTRouterHandler handler = parameters[@"block"];
    if (handler) {
        
//        if ([router.delegate respondsToSelector:@selector(router:willOpenURL:withUserInfo:)]) {
//            [router.delegate router:router willOpenURL:URL withUserInfo:userInfo];
//        }
        
        if (completion) {
            parameters[GTRouterParameterCompletion] = completion;
        }
        if (userInfo) {
            parameters[GTRouterParameterUserInfo] = userInfo;
        }
        
        [parameters removeObjectForKey:@"block"];
        
        // 让 handler 都在主线程中执行，避免出现各种诡异的问题
        if ([NSThread isMainThread]) {
            handler(parameters);
        } else {
            dispatch_sync(dispatch_get_main_queue(), ^{
                handler(parameters);
            });
        }
    }
    else {
//        if ([router.delegate respondsToSelector:@selector(router:didFailOpenWithURL:withUserInfo:)]) {
//            [router.delegate router:router didFailOpenWithURL:URL withUserInfo:userInfo];
//        }
    }
}
- (NSMutableDictionary *)extractParametersFromURL:(NSString *)url
{
    return [self extractParametersFromURL:url isForObject:NO];
}
#pragma mark - Utils

- (NSMutableDictionary *)extractParametersFromURL:(NSString *)url isForObject:(BOOL)is
{
    NSMutableDictionary* parameters = [NSMutableDictionary dictionary];
    
    parameters[GTRouterParameterURL] = url;
    
    NSMutableDictionary* subRoutes = self.routes;//  已经注册好的所有 关心的 url集合
    NSArray* pathComponents = [self pathComponentsFromURL:url];
    
    // 判断是否符合规格 并判断是否是关心的url  否则直接返回
    for (NSString* pathComponent in pathComponents) {
        BOOL found = NO;
        
        // 对 key 进行排序，这样可以把 ~ 放到最后
        NSArray *subRoutesKeys =[subRoutes.allKeys sortedArrayUsingComparator:^NSComparisonResult(NSString *obj1, NSString *obj2) {
            return [obj1 compare:obj2];
        }];
        
        for (NSString* key in subRoutesKeys) {
            if ([key isEqualToString:pathComponent] || [key isEqualToString:GT_ROUTER_WILDCARD_CHARACTER]) {
                found = YES;
                subRoutes = subRoutes[key];
                break;
            } else if ([key hasPrefix:@":"]) {
                found = YES;
                subRoutes = subRoutes[key];
                parameters[[key substringFromIndex:1]] = pathComponent;
                break;
            }
        }
        // 如果没有找到该 pathComponent 对应的 handler，则以上一层的 handler 作为 fallback
        if (!found && !subRoutes[@"_"]) {
            return nil;
        }
    }
    
    // Extract Params From Query.  处理？后面的参数
    NSArray* pathInfo = [url componentsSeparatedByString:@"?"];
    if (pathInfo.count > 1) {
        NSString* parametersString = [pathInfo objectAtIndex:1];
        NSArray* paramStringArr = [parametersString componentsSeparatedByString:@"&"];
        for (NSString* paramString in paramStringArr) {
            NSArray* paramArr = [paramString componentsSeparatedByString:@"="];
            if (paramArr.count > 1) {
//                NSString* key = [[paramArr objectAtIndex:0] ];
//                NSString* value = [[paramArr objectAtIndex:1] mgj_urldecode];
                NSString* key = [paramArr objectAtIndex:0];
                NSString* value = [paramArr objectAtIndex:1];
                parameters[key] = value;
            }
        }
    }
    // 赋值
    if (is) {
        if (subRoutes[@"_object_"]) {
            parameters[@"block"] = [subRoutes[@"_object_"] copy];
        }
    } else {
        if (subRoutes[@"_"]) {
            parameters[@"block"] = [subRoutes[@"_"] copy];
        }
    }
    
    return parameters;
}

#pragma mark - property
- (NSMutableDictionary *)routes
{
    if (!_routes) {
        _routes = [[NSMutableDictionary alloc] init];
    }
    return _routes;
}

@end
