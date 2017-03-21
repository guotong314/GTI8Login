//
//  GTServiceRequest.h
//  GTI8Login
//
//  Created by 郭通 on 17/3/21.
//  Copyright © 2017年 郭通. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GTServiceRequest : NSObject

+(instancetype) sharedInstance;

+ (void) checkDomainName:(NSString *)domain completionHandler:(DMCompletionHandler)handler;

+ (void) configService:(NSString *) url completionHandler:(DMCompletionHandler)handler;

+ (void) changeService:(NSString *) url completionHandler:(DMCompletionHandler)handler;
@end
