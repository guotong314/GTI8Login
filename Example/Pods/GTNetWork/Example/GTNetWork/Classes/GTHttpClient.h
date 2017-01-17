//
//  GTHttpClient.h
//  GTNetWork
//
//  Created by 郭通 on 17/1/10.
//  Copyright © 2017年 郭通. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AFNetworking.h"
#import "AFNetworkActivityIndicatorManager.h"

#import "sys/utsname.h"

#import "ASINetworkQueue.h"

typedef void(^DMCompletionHandler)(id object,NSError* error);

typedef NS_ENUM(NSInteger, MLSNetworkReachabilityStatus) {
    MLSNetworkReachabilityStatusUnknown          = -1,
    MLSNetworkReachabilityStatusNotReachable  = 0,
    MLSNetworkReachabilityStatusReachableViaWWAN = 1,
    MLSNetworkReachabilityStatusReachableViaWiFi = 2,
};

#define HTTPCLIENT [GTHttpClient sharedInstance]

@interface GTHttpClient : NSObject

@property (strong,readonly) AFHTTPRequestOperationManager* manager;
@property (nonatomic, strong) ASINetworkQueue *queue;
@property (nonatomic, strong) NSMutableArray *downArray;

+ (instancetype)sharedInstance;

#pragma mark - Network Status Reachability
- (MLSNetworkReachabilityStatus)networkReachabilityStatus;

- (void)startMonitoringNetworkReachabilityWithBlock:(void (^)(MLSNetworkReachabilityStatus status))block;
- (void)stopMonitoringNetworkReachability;
- (void)changeRequestTimeOut:(float)time;

- (NSString *) iphoneUDID;
- (NSString *) version;
- (NSString *)phoneModel;
- (NSMutableDictionary*)staticParam;
- (NSMutableDictionary*)staticTokenParam;

- (void) GetRequestAddress:(NSString *)urlAddress withParams:(NSDictionary *)aParams completionHandler:(DMCompletionHandler)handler;
- (void) appUpdateRequestAddress:(NSString *)urlAddress withParams:(NSDictionary *)aParams completionHandler:(DMCompletionHandler)handler;
- (void) PostRequestAddress:(NSString *)urlAddress withParams:(NSDictionary *)aParams completionHandler:(DMCompletionHandler)handler;

@end

#import "GTHttpClient+Internal.h"
