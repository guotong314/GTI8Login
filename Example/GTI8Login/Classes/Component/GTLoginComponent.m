//
//  GTLoginComponent.m
//  GTI8Login
//
//  Created by 郭通 on 17/1/17.
//  Copyright © 2017年 郭通. All rights reserved.
//

#import "GTLoginComponent.h"
#import "GTLoginCareUrls.h"
#import <GTSpec/GTURLHelper.h>
#import "GTI8LoginViewController.h"
#import <GTRootKit/GTNavigationViewController.h>
#import <GTRootKit/GTNavigateModule.h>

@implementation GTLoginComponent

/**
 *  注册关心的 URLs
 *
 *  @return NSArray
 */
- (NSArray *)registeredURLs {
    return @[[GTLoginCareUrls GT_Main_TokenInValid],[GTLoginCareUrls GT_Main_ClickQuit]];
};

/**
 *  处理关心的 URL。具体的逻辑在这个方法里可能会通过 switch / case 来针对不同的 URL 做不同的处理
 *  首先通过 MGJRouter 来把 URL 注册到它内部，然后 openURL 时，再找到这个 URL 对应的处理方法
 *
 *  @param URL      这是一个完整的 URL
 *  @param userInfo userInfo 里会包含调用方传过来的 userInfo
 */
- (void)handleURL:(NSString *)URL withUserInfo:(NSDictionary *)userInfo  completion:(void (^)(id result))completion {
    
    GTURLHelper *urlEntity = [GTURLHelper URLWithString:URL];
    if ([urlEntity.host isEqualToString:@"tokenInValid"]) {
        
        [self showLogin];
        
        [[NSNotificationCenter defaultCenter] postNotificationName:@"showLogin" object:@(YES)];
    }
    else if ([urlEntity.host isEqualToString:@"clickQuit"]) {
        
        [self showLogin];
    }
}
- (void) showLogin
{
    GTI8LoginViewController *loginVC = [[GTI8LoginViewController alloc] init];
    GTNavigationViewController *nav = [[GTNavigationViewController alloc] initWithRootViewController:loginVC];
    APPWINDOW.window.rootViewController = nav;
    [APPWINDOW makeKeyAndVisible];
}

@end
