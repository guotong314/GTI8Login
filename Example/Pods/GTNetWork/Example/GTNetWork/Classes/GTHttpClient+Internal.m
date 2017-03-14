//
//  GTHttpClient+Internal.m
//  GTNetWork
//
//  Created by 郭通 on 17/1/10.
//  Copyright © 2017年 郭通. All rights reserved.
//

#import "GTHttpClient+Internal.h"
#import <GTBaseRule.h>

@implementation GTHttpClient(Internal)

-(AFHTTPRequestOperation*)operationWithHTTPMethod:(NSString*)method
                                     apiURLString:(NSString*)apiURLString
                                       parameters:(NSDictionary*)parameters
                                          success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
                                          failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure
{
    NSMutableURLRequest* request = [self.manager.requestSerializer requestWithMethod:method
                                                                           URLString:apiURLString
                                                                          parameters:parameters
                                                                               error:nil];
    return [self.manager HTTPRequestOperationWithRequest:request
                                                 success:success
                                                 failure:failure];
}

-(void)startOperation:(NSOperation*)op
{
    AFHTTPRequestOperation *oper = (AFHTTPRequestOperation *)op;
    NSLog(@"%@",oper.request.URL);
    [self.manager.operationQueue addOperation:op];
}

-(NSError*)preHandleResponse:(id)response operation:(NSOperation *)operation
{
    NSError *error = nil;
    //    NSInteger errorCode = [response errorCode];
    //
    //    if (errorCode != kMLSErrorCode_NoError) {
    //        NSString *errorMsg = [response errorMessage];
    //        error = [NSError errorWithDomain:kMLSDomain_ResponseError
    //                                    code:errorCode userInfo:@{kMLSUserKey_ErrorMessage:errorMsg}];
    //
    //        [self logServerResponseError:error withOperation:operation];
    //    } else {
    //        [self logSuccessWithResponse:response withOperation:operation];
    //    }
    
    return error;
}

-(void)logSuccessWithResponse:(id)response withOperation:(NSOperation*)operation
{
#if MLS_NETWORK_DEBUG
    AFHTTPRequestOperation* request = (AFHTTPRequestOperation*)operation;
    NSLog(@"Received Data:%@ for request:%@",response,request.request.URL);
#endif
}

-(void)logServerResponseError:(NSError*)error withOperation:(NSOperation*)operation
{
#if MLS_NETWORK_DEBUG
    AFHTTPRequestOperation* request = (AFHTTPRequestOperation*)operation;
    NSLog(@"Server Response error:%@ code:%ld message:%@ on request:%@",error,(long)error.code,
          [error userInfo][kMLSMCErrorUserInfoMsgKey],request.request.URL);
#endif
}

-(void)logHTTPError:(NSError*)error withOperation:(NSOperation*)operation
{
#if MLS_NETWORK_DEBUG
    AFHTTPRequestOperation* request = (AFHTTPRequestOperation*)operation;
    NSLog(@"HTTP Failed with error:%@ on request:%@ with response:%@",error,
          request.request.URL,request.responseObject);
#endif
}

//-(NSError*)wrapHTTPError:(NSError*)error
//{
//    NSMutableDictionary* userinfo = [NSMutableDictionary dictionaryWithDictionary:error.userInfo];
//    [userinfo setObject:@"网络连接异常，请检查后重试" forKey:kDMUserKey_ErrorMessage];
//    return [NSError errorWithDomain:error.domain code:error.code userInfo:userinfo];
//}
#pragma private methods
-(void)handleResponse:(id)response
withCompletionHandler:(DMCompletionHandler)handler
{
    NSString *errorDomain = [NSString stringWithFormat:@"%@.error",[ConfigManage fileServerURL]];
    if ([response isKindOfClass:[NSDictionary class]]) {
        if ([response[@"Succeed"] integerValue]) {
            handler(response,nil);
        }else{
            NSError *error = [NSError errorWithDomain:errorDomain code:kDMErrorNormalCode userInfo:@{kDMErrorUserInfoMsgKey:[self errorReasion:response[@"Message"]]}];
            handler(response,error);
        }
    }else{
        NSError *error = [NSError errorWithDomain:errorDomain code:kDMErrorNormalCode userInfo:@{kDMErrorUserInfoMsgKey:@"服务器异常"}];
        handler(nil,error);
    }
}
-(void)handleErrorHandler:(DMCompletionHandler)handler{
    NSString *errorDomain = [NSString stringWithFormat:@"%@.error",[ConfigManage fileServerURL]];
    NSError *error = [NSError errorWithDomain:errorDomain code:kDMErrorNormalCode userInfo:@{kDMErrorUserInfoMsgKey:@"网络异常,请重试",kDMErrorUserInfoMsgCode:@"1"}];
    handler(nil,error);
}
- (NSString *)errorReasion:(NSString *)aErrorMsg
{
    if (![aErrorMsg isKindOfClass:[NSString class]]) {
        return @"";
    }
    NSString *reason = aErrorMsg;//@"网络异常,请重试";
    if ([aErrorMsg isEqualToString:@"PWD_INVALID"]) {
        reason = @"密码错误，请重试";
    }else if([aErrorMsg isEqualToString:@"NO_USER"]){
        reason = @"用户名错误,请重试";
    }else if([aErrorMsg isEqualToString:@"SESSION_INVALID"]){
        reason = @"token失效，请重新登录";
        [GTBaseRule openURL:@"dm://tokenInValid"];
//        [APPDELEGATE postShowLogin];
        //        [[NSNotificationCenter defaultCenter] postNotificationName:kNotificationShowLogin object:nil];
    }
    if (!reason) {
        reason =@"网络异常,请重试";
    }
    return reason;
}


@end
