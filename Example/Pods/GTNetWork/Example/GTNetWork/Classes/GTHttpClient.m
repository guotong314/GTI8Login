//
//  GTHttpClient.m
//  GTNetWork
//
//  Created by 郭通 on 17/1/10.
//  Copyright © 2017年 郭通. All rights reserved.
//

#import "GTHttpClient.h"
#import <GTUser/GTUser.h>


@interface GTHttpClient()

@property(nonatomic,strong)NSOperationQueue* processQueue;
@property(nonatomic,strong)AFHTTPRequestOperationManager* manager;

@end

@implementation GTHttpClient

+ (instancetype)sharedInstance
{
    static GTHttpClient *sharedInstance;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[self alloc] init];
    });
    
    return sharedInstance;
}

-(id)init {
    if (self = [super init]) {
        self.manager = [AFHTTPRequestOperationManager manager];
        self.manager.requestSerializer = [AFHTTPRequestSerializer serializer];
        //
        //        [self.manager.requestSerializer setValue:[SYSCONFIG userAgent] forHTTPHeaderField:@"User-Agent"];
        //        [self.manager.requestSerializer setValue:[SYSCONFIG cookie] forHTTPHeaderField:@"Cookie"];
        //
        AFJSONResponseSerializer* jsonResponseSerializer = [AFJSONResponseSerializer serializer];
        self.manager.responseSerializer = jsonResponseSerializer;
        
        NSMutableSet *jsonAcceptableContentTypes = [NSMutableSet setWithSet:jsonResponseSerializer.acceptableContentTypes];
        [jsonAcceptableContentTypes addObject:@"text/plain"];
        [jsonAcceptableContentTypes addObject:@"text/html"];
        self.manager.responseSerializer.acceptableContentTypes = jsonAcceptableContentTypes;
        
        self.processQueue = [[NSOperationQueue alloc] init];
        [self.processQueue setMaxConcurrentOperationCount:1];
        //
        self.queue = [[ASINetworkQueue alloc] init];
        [self.queue setShowAccurateProgress:YES];//高精度进度
        [self.queue go];
        
        _downArray = [[NSMutableArray alloc] init];
        
    }
    
    return self;
}
- (void)changeRequestTimeOut:(float)time
{
    [self.manager.requestSerializer willChangeValueForKey:@"timeoutInterval"];
    self.manager.requestSerializer.timeoutInterval = time;
    [self.manager.requestSerializer didChangeValueForKey:@"timeoutInterval"];
}
#pragma mark - Reachibility

- (MLSNetworkReachabilityStatus)networkReachabilityStatus
{
    MLSNetworkReachabilityStatus status = MLSNetworkReachabilityStatusUnknown;
    AFNetworkReachabilityManager *afReachabilityManager = [self.manager reachabilityManager];
    
    if (afReachabilityManager.isReachableViaWiFi) {
        status = MLSNetworkReachabilityStatusReachableViaWiFi;
    } else if (afReachabilityManager.isReachableViaWWAN) {
        status = MLSNetworkReachabilityStatusReachableViaWWAN;
    } else if (!afReachabilityManager.isReachable) {
        status = MLSNetworkReachabilityStatusNotReachable;
    } else {
        status = MLSNetworkReachabilityStatusUnknown;
    }
    
    return status;
}

- (void)startMonitoringNetworkReachabilityWithBlock:(void (^)(MLSNetworkReachabilityStatus status))block
{
    [[self.manager reachabilityManager] setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {
        block((MLSNetworkReachabilityStatus)status);
    }];
    
    [[self.manager reachabilityManager] startMonitoring];
}

- (void)stopMonitoringNetworkReachability
{
    [[self.manager reachabilityManager] stopMonitoring];
}
- (NSString *)phoneModel
{
    struct utsname systemInfo;
    uname(&systemInfo);
    NSString *deviceString = [NSString stringWithCString:systemInfo.machine encoding:NSUTF8StringEncoding];
    NSLog(@"%@",deviceString);
    NSArray *modelArray = @[
                            
                            @"i386", @"x86_64",
                            
                            @"iPhone1,1",
                            @"iPhone1,2",
                            @"iPhone2,1",
                            @"iPhone3,1",
                            @"iPhone3,2",
                            @"iPhone3,3",
                            @"iPhone4,1",
                            @"iPhone5,1",
                            @"iPhone5,2",
                            @"iPhone5,3",
                            @"iPhone5,4",
                            @"iPhone6,1",
                            @"iPhone6,2",
                            @"iPhone7,1",
                            @"iPhone7,2",
                            
                            @"iPod1,1",
                            @"iPod2,1",
                            @"iPod3,1",
                            @"iPod4,1",
                            @"iPod5,1",
                            
                            @"iPad1,1",
                            @"iPad2,1",
                            @"iPad2,2",
                            @"iPad2,3",
                            @"iPad2,4",
                            @"iPad3,1",
                            @"iPad3,2",
                            @"iPad3,3",
                            @"iPad3,4",
                            @"iPad3,5",
                            @"iPad3,6",
                            
                            @"iPad2,5",
                            @"iPad2,6",
                            @"iPad2,7",
                            @"iPad4,4",
                            ];
    NSArray *modelNameArray = @[
                                
                                @"iPhone Simulator", @"iPhone Simulator",
                                
                                @"iPhone 2G",
                                @"iPhone 3G",
                                @"iPhone 3GS",
                                @"iPhone 4",
                                @"iPhone 4",
                                @"iPhone 4",
                                @"iPhone 4S",
                                @"iPhone 5",
                                @"iPhone 5",
                                @"iPhone 5c",
                                @"iPhone 5c",
                                @"iphone 5s",
                                @"iphone 5s",
                                @"iphone 6plus",
                                @"iphone 6",
                                
                                @"iPod Touch",
                                @"iPod Touch",
                                @"iPod Touch",
                                @"iPod Touch",
                                @"iPod Touch",
                                
                                @"iPad",
                                @"iPad 2",
                                @"iPad 2",
                                @"iPad 2",
                                @"iPad 2",
                                @"iPad 3",
                                @"iPad 3",
                                @"iPad 3",
                                @"iPad 4",
                                @"iPad 4",
                                @"iPad 4",
                                
                                @"iPad mini",
                                @"iPad mini",
                                @"ipad mini",
                                @"ipad mini"
                                ];
    NSInteger modelIndex = - 1;
    NSString *modelNameString = nil;
    modelIndex = [modelArray indexOfObject:deviceString];
    if (modelIndex >= 0 && modelIndex < [modelNameArray count]) {
        modelNameString = [modelNameArray objectAtIndex:modelIndex];
    }
    else
    {
        modelNameString = deviceString;
    }
    
    return modelNameString;
}
- (NSString *) version
{
    NSDictionary *infoDictionary = [[NSBundle mainBundle] infoDictionary];
    return [infoDictionary objectForKey:@"CFBundleVersion"];
}
- (NSString *) iphoneUDID
{
    return [[[UIDevice currentDevice] identifierForVendor] UUIDString];
}
- (NSMutableDictionary*)staticParam
{
    NSMutableDictionary *staticParam = [NSMutableDictionary dictionary];
    NSDictionary *infoDic = [[NSDictionary alloc] initWithObjectsAndKeys:@"iOS",@"Type",[self iphoneUDID],@"Hardware",[self phoneModel],@"Info", nil];
    [staticParam setObject:[infoDic JSONString] forKey:@"device"];
    return staticParam;
}
- (NSMutableDictionary*)staticTokenParam
{
    NSMutableDictionary *staticParam = [NSMutableDictionary dictionary];
    //    [staticParam setObject:[self iphoneUDID] forKey:@"deviceid"];
    //    [staticParam setObject:[self phoneModel] forKey:@"deviceDescription"];
    NSDictionary *infoDic = [[NSDictionary alloc] initWithObjectsAndKeys:@"iOS",@"Type",[self iphoneUDID],@"Hardware",[self phoneModel],@"Info", nil];
    [staticParam setObject:[infoDic JSONString] forKey:@"device"];
    if ([GTUser currentUser].userToken) {
        [staticParam setObject:[GTUser currentUser].userToken forKey:@"__session__"];
    }
    return staticParam;
}
- (void) GetRequestAddress:(NSString *)urlAddress withParams:(NSDictionary *)aParams completionHandler:(DMCompletionHandler)handler
{
    NSURL *serviceURL = [ConfigManage getFileServer];
    NSString *url = [[NSURL URLWithString:urlAddress
                            relativeToURL:serviceURL] absoluteString];
    NSMutableDictionary *params = [self staticTokenParam];
    [params addEntriesFromDictionary:aParams];
    NSOperation *operation = [self operationWithHTTPMethod:@"GET" apiURLString:url parameters:params
                                                   success:^(AFHTTPRequestOperation *operation, id responseObject) {
                                                       //parse response
                                                       if (handler != nil && [responseObject isKindOfClass:[NSDictionary class]]) {
                                                           [self handleResponse:responseObject withCompletionHandler:handler];
                                                       }
                                                   }
                                                   failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                                                       if (handler != nil) {
                                                           [self handleErrorHandler:handler];
                                                       }
                                                   }];
    [self startOperation:operation];
}
- (void) PostRequestAddress:(NSString *)urlAddress withParams:(NSDictionary *)aParams completionHandler:(DMCompletionHandler)handler
{
    NSURL *serviceURL = [ConfigManage getFileServer];
    NSString *url = [[NSURL URLWithString:urlAddress
                            relativeToURL:serviceURL] absoluteString];
    NSMutableDictionary *params = [self staticTokenParam];
    [params addEntriesFromDictionary:aParams];
    NSOperation *operation = [self operationWithHTTPMethod:@"POST" apiURLString:url parameters:params
                                                   success:^(AFHTTPRequestOperation *operation, id responseObject) {
                                                       //parse response
                                                       if (handler != nil && [responseObject isKindOfClass:[NSDictionary class]]) {
                                                           [self handleResponse:responseObject withCompletionHandler:handler];
                                                       }
                                                   }
                                                   failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                                                       if (handler != nil) {
                                                           [self handleErrorHandler:handler];
                                                       }
                                                   }];
    [self startOperation:operation];
}

- (void) appUpdateRequestAddress:(NSString *)urlAddress withParams:(NSDictionary *)aParams completionHandler:(DMCompletionHandler)handler
{
    NSURL *serviceURL = [NSURL URLWithString:ConfigManage.appUpdateUrl];
    NSString *url = [[NSURL URLWithString:urlAddress
                            relativeToURL:serviceURL] absoluteString];
    NSMutableDictionary *params = [self staticTokenParam];
    [params addEntriesFromDictionary:aParams];
    NSOperation *operation = [self operationWithHTTPMethod:@"GET" apiURLString:url parameters:params
                                                   success:^(AFHTTPRequestOperation *operation, id responseObject) {
                                                       //parse response
                                                       handler(responseObject,nil);
                                                   }
                                                   failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                                                       if (handler != nil) {
                                                           [self handleErrorHandler:handler];
                                                       }
                                                   }];
    [self startOperation:operation];
}


@end
