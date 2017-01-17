//
//  GTComponentManager.m
//  GTEmptyView
//
//  Created by 郭通 on 17/1/6.
//  Copyright © 2017年 郭通. All rights reserved.
//

#import "GTComponentManager.h"
#import "GTBaseRule.h"
NSString *const MGJComponentDefaultPlistName = @"components";

@interface GTComponentManager()

@property (nonatomic, strong) NSArray<GTBaseComponent *> *components;
@property (nonatomic, assign) BOOL didFinishRegister;

- (void)registerComponents:(NSArray<GTBaseComponent *> *)components;

@end
@implementation GTComponentManager

+ (instancetype)sharedInstance
{
    static dispatch_once_t onceToken;
    static GTComponentManager *instance;
    dispatch_once(&onceToken, ^{
        instance = [[GTComponentManager alloc] init];
    });
    return instance;
}

+ (void)registerComponentsFromDefaultPlist
{
    [self registerComponentsFromCustomizedPlist:MGJComponentDefaultPlistName];
}

+ (void)registerComponents:(NSArray<GTBaseComponent *> *)components
{
    [[GTComponentManager sharedInstance] registerComponents:components];
}
+ (void)registerComponentsFromCustomizedPlist:(NSString *)plistName
{
    NSParameterAssert(plistName);
    
    NSString *plistPath = [[NSBundle mainBundle] pathForResource:plistName ofType:@"plist"];
    NSAssert(plistPath, @"components.plist not found");
    NSArray *componentNameArray = [NSArray arrayWithContentsOfFile:plistPath];
    NSMutableArray <GTBaseComponent *> *components = [NSMutableArray array];
    [componentNameArray enumerateObjectsUsingBlock:^(NSString  * className, NSUInteger idx, BOOL * _Nonnull stop) {
        Class componentClass = NSClassFromString(className);
        GTBaseComponent * component = [componentClass sharedInstance];
        if ([component isKindOfClass:[GTBaseComponent class]]) {
            [components addObject:component];
        }
    }];
    
    [self registerComponents:components];
}

+ (NSArray<GTBaseComponent *> *)components
{
    return [[GTComponentManager sharedInstance].components copy];
}
#pragma mark - instance methods
- (void)registerComponents:(NSArray<GTBaseComponent *> *)components
{
    NSAssert([NSThread currentThread].isMainThread, @"必须在主线程执行");
    if (self.didFinishRegister) {
        NSLog(@"请不要多次注册组件");
        return;
    }
    NSMutableArray *validComponents = [NSMutableArray array];
    
    [components enumerateObjectsUsingBlock:^(GTBaseComponent * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if ([obj isKindOfClass:[GTBaseComponent class]]) {
            if ([obj respondsToSelector:@selector(registeredURLs)]) {
                NSArray *urls = obj.registeredURLs;
                [urls enumerateObjectsUsingBlock:^(NSString * _Nonnull url, NSUInteger idx, BOOL * _Nonnull stop) {
                    [GTBaseRule registerURLPattern:url toHandler:^(NSDictionary *routerParameters) {
                        if ([obj respondsToSelector:@selector(handleURL:withUserInfo:completion:)]) {
                            //将 routerParameters 中的 completion、UserInfo 剥离，方便使用
                            id completionBlock = routerParameters[GTRouterParameterCompletion];
                            NSDictionary *userInfo = routerParameters[GTRouterParameterUserInfo];
                            NSString *fullURL = routerParameters[GTRouterParameterURL];
                            
                            [obj handleURL:fullURL withUserInfo:userInfo completion:completionBlock];
                        }
                    }];
                }];
            }
            [validComponents addObject:obj];
            
        }
    }];
    
    self.components = [validComponents copy];
    self.didFinishRegister = YES;
}

@end
