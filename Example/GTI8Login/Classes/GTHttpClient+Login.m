//
//  GTHttpClient+Login.m
//  GTI8Login
//
//  Created by 郭通 on 17/1/16.
//  Copyright © 2017年 郭通. All rights reserved.
//

#import "GTHttpClient+Login.h"
#import <GTNetWork/GTConfigManage.h>

NSString* const kAPI_Main_ServiceUrl = @"/Services/Http/GetSysInfo.ashx";
NSString* const kAPI_User_Login =  @"/Services/Http/Logon.ashx";

@implementation GTHttpClient(Login)

- (void) configServiceUrl:(NSString *)serviceUrl withParams:(NSDictionary *)aParams completionHandler:(DMCompletionHandler)handler;
{
    NSString *url = [[NSURL URLWithString:kAPI_Main_ServiceUrl
                            relativeToURL:[NSURL URLWithString:serviceUrl]] absoluteString];
    NSMutableDictionary *params = [self staticParam];
    [params addEntriesFromDictionary:aParams];
    [self changeRequestTimeOut:10.f];
    NSOperation *operation = [self operationWithHTTPMethod:@"POST" apiURLString:url parameters:params
                                                   success:^(AFHTTPRequestOperation *operation, id responseObject) {
                                                       //parse response
                                                       if (handler != nil && [responseObject isKindOfClass:[NSDictionary class]]) {
                                                           [self changeRequestTimeOut:20.f];
                                                           [self handleResponse:responseObject withCompletionHandler:handler];
                                                       }
                                                   }
                                                   failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                                                       NSLog(@"%@", error.userInfo[@"NSErrorFailingURLKey"]);
                                                       
                                                       if (handler != nil) {
                                                           [self handleErrorHandler:handler];
                                                       }
                                                   }];
    [self startOperation:operation];
    
}
- (void) loginWithParams:(NSDictionary *)aParams completionHandler:(DMCompletionHandler)handler
{
    NSString *url = [[NSURL URLWithString:kAPI_User_Login
                            relativeToURL:[ConfigManage getFileServer]] absoluteString];
    NSMutableDictionary *params = [self staticParam];
    [params addEntriesFromDictionary:aParams];
    [self changeRequestTimeOut:10.f];
    NSOperation *operation = [self operationWithHTTPMethod:@"POST" apiURLString:url parameters:params
                                                   success:^(AFHTTPRequestOperation *operation, id responseObject) {
                                                       //parse response
                                                       if (handler != nil && [responseObject isKindOfClass:[NSDictionary class]]) {
                                                           [self changeRequestTimeOut:20.f];
                                                           [self handleResponse:responseObject withCompletionHandler:handler];
                                                       }
                                                   }
                                                   failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                                                       NSLog(@"%@", error);
                                                       
                                                       if (handler != nil) {
                                                           [self handleErrorHandler:handler];
                                                       }
                                                   }];
    [self startOperation:operation];
    
}
- (void) checkDomainRegWithParams:(NSDictionary *)params completionHandler:(DMCompletionHandler)handler;
{
    NSString *url = @"https://www.atuyun.cn/Api/Public/CheckDomainReg";
    NSOperation *operation = [self operationWithHTTPMethod:@"GET" apiURLString:url parameters:params
                                                   success:^(AFHTTPRequestOperation *operation, id responseObject) {
                                                       //parse response
                                                       if (handler != nil && [responseObject isKindOfClass:[NSDictionary class]]) {
                                                           [self changeRequestTimeOut:20.f];
                                                           [self handleResponse:responseObject withCompletionHandler:handler];
                                                       }
                                                   }
                                                   failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                                                       NSLog(@"%@", error);
                                                       
                                                       if (handler != nil) {
                                                           [self handleErrorHandler:handler];
                                                       }
                                                   }];
    [self startOperation:operation];

}

@end
