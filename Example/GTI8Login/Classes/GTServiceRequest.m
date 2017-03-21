//
//  GTServiceRequest.m
//  GTI8Login
//
//  Created by 郭通 on 17/3/21.
//  Copyright © 2017年 郭通. All rights reserved.
//

#import "GTServiceRequest.h"
#import "GTHttpClient+Login.h"
#import "GTRemindView.h"
#import "GTNetConstants.h"
#import "GTCompanyInfo.h"
#import "GTConfigManage.h"

@implementation GTServiceRequest

+ (instancetype)sharedInstance {
    static GTServiceRequest *sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[self alloc] init];
    });
    
    return sharedInstance;
}
+ (void) checkDomainName:(NSString *)domain completionHandler:(DMCompletionHandler)handler
{
    [HTTPCLIENT checkDomainRegWithParams:@{@"domainName":domain} completionHandler:^(id object, NSError *error) {
        if ([object isKindOfClass:[NSDictionary class]]) {
            if (![[object objForKey:@"Succeed"] boolValue]) {
                
            }else{
                [GTRemindView showWithMesssage:@"域名不存在"];
            }
        }else{
            [GTRemindView showWithMesssage:error.userInfo[kDMErrorUserInfoMsgKey]];
        }

        handler (object,error);
    }];

}
+ (void) configService:(NSString *) url completionHandler:(DMCompletionHandler)handler
{
    NSString *serverStr = [GTServiceRequest combineService:url];
    
    [HTTPCLIENT configServiceUrl:serverStr withParams:@{} completionHandler:^(id object, NSError *error) {
        if (!error) {
            NSDictionary *dataDic = [object objForKey:@"Data"];
            NSDictionary *dic = @{@"companyName":[dataDic objForKey:@"Title"]?:@"",@"companyLogo":[dataDic objForKey:@"Logo"]?:@"",@"loginBackImage":[dataDic objForKey:@"LogonBg"]?:@""};
            [GTCompanyInfo storeCompanyInfo:dic];
            
            [[GTConfigManage sharedInstance] setFileServerURL:serverStr];
            [ConfigManage savePreviousServerUrl:serverStr];
        }else{
            if (error.userInfo[kDMErrorUserInfoMsgCode] && [serverStr hasPrefix:@"https"]) {
                NSLog(@"errHttps:%@",error.domain);
                [GTConfigManage sharedInstance].isHttps = NO;
            }else{
                [GTConfigManage sharedInstance].isHttps = YES;
                NSLog(@"errHttp:%@",error.domain);
                [GTRemindView showWithMesssage:error.userInfo[kDMErrorUserInfoMsgKey]];
            }
        }
        handler (object,error);
    }];

}
+ (NSString *) combineService:(NSString *)url
{
    BOOL isAtuyunHidden = [[ConfigManage getSystemConfig:@"registerHidden"] boolValue];
    NSString *serverStr = url;
    if (!isAtuyunHidden) {
        serverStr = [NSString stringWithFormat:@"%@%@",url,domainStr];
    }
    serverStr = [ConfigManage configServerURL:serverStr];
    serverStr = [serverStr lowercaseString];
    return serverStr;
}
+ (void) changeService:(NSString *) url completionHandler:(DMCompletionHandler)handler
{
    [GTServiceRequest checkDomainName:url completionHandler:^(id object, NSError *error) {
        if (![[object objForKey:@"Succeed"] boolValue]) {
            [GTServiceRequest configService:url completionHandler:^(id object, NSError *error) {
                if (!error) {
                    handler(object,error);
                }else{
                    if (error.userInfo[kDMErrorUserInfoMsgCode] && [GTConfigManage sharedInstance].isHttps == NO) {
                        [GTServiceRequest configService:url completionHandler:^(id object, NSError *error) {
                            handler(object,error);
                        }];
                    }else{
                        handler(object,error);
                    }
                }
            }];
        }else{
            handler(object,error);
        }
    }];
}
@end
