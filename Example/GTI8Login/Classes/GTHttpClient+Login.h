//
//  GTHttpClient+Login.h
//  GTI8Login
//
//  Created by 郭通 on 17/1/16.
//  Copyright © 2017年 郭通. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GTHttpClient(Login)

- (void) configServiceUrl:(NSString *)serviceUrl withParams:(NSDictionary *)aParams completionHandler:(DMCompletionHandler)handler;

- (void) loginWithParams:(NSDictionary *)params completionHandler:(DMCompletionHandler)handler;

- (void) checkDomainRegWithParams:(NSDictionary *)params completionHandler:(DMCompletionHandler)handler;

@end
