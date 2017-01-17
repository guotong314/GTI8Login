//
//  GTConfigManage.m
//  GTNetWork
//
//  Created by 郭通 on 17/1/10.
//  Copyright © 2017年 郭通. All rights reserved.
//

#import "GTConfigManage.h"

NSString * const kUserKey_previousServerURL = @"kUserKey_previousServerURL";

@implementation GTConfigManage

@synthesize fileServerURL = _fileServerURL;

+ (instancetype)sharedInstance {
    static GTConfigManage *sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[self alloc] init];
        sharedInstance.isHttps = YES;
    });
    
    return sharedInstance;
}
- (NSString *) configServerURL:(NSString *)aServerStr
{
    aServerStr = [aServerStr lowercaseString];
    NSString *configStr = aServerStr;
    if ([aServerStr hasPrefix:@"http://"] || [aServerStr hasPrefix:@"https://"]){
        configStr = [[NSString alloc] initWithString:aServerStr];
    }
    else if(self.isHttps){
        configStr = [[NSString alloc] initWithFormat:@"https://%@",aServerStr];
    }else if(!self.isHttps){
        configStr = [[NSString alloc] initWithFormat:@"http://%@",aServerStr];
    }
    return configStr;
}
- (NSString *) combineServerURL:(NSString *)aServerStr
{
    NSString *bServerStr = [aServerStr lowercaseString];
    NSString *configStr = aServerStr;
    if ([bServerStr hasPrefix:@"http://"] || [bServerStr hasPrefix:@"https://"])
    {
        configStr = aServerStr;
    }
    else{
        configStr = [NSString stringWithFormat:@"%@%@",self.fileServerURL,aServerStr];
    }
    return configStr;
}
//- (NSString *) configImFileURL:(NSString *)attid withName:(NSString *)fileName withWidth:(float)width withLevel:(NSInteger)level
//{
//    NSString *fileURL = [NSString stringWithFormat:@"%@%@?attid=%@&fileName=%@&width=%f&imgLevel=%d",self.fileServerURL,kAPI_Chat_DownloadFile,attid,fileName,width,(int)level];
//    return fileURL;
//}
-(id) init {
    if (self = [super init]) {
        self.appUpdateUrl = @"http://appkiz-store.menhoo.com";
        NSString *urlStr = [PersistenceHelper dataForKey:kUserKey_previousServerURL];
        if (!urlStr) {
            NSString *serverStr = [self getSystemServer];
            if (serverStr.length) {
                [PersistenceHelper setData:serverStr forKey:kUserKey_previousServerURL];//正式版
            }
        }
        _fileServerURL = [self getPreviousServerUrl];
    }
    
    return self;
}

- (NSURL *) getFileServer
{
    return [NSURL URLWithString:self.fileServerURL];
}
#pragma mark - previousServerUrl
- (NSString *) getPreviousServerUrl
{
    return [PersistenceHelper dataForKey:kUserKey_previousServerURL];
}
- (void) savePreviousServerUrl:(NSString *)serverUrl
{
    [PersistenceHelper setData:serverUrl forKey:kUserKey_previousServerURL];
}
#pragma mark - config plist
- (NSDictionary *) getSystemInfo:(NSString *)plistName
{
    NSString *plistPath = [[NSBundle mainBundle] pathForResource:plistName ofType:@"plist"];
    NSDictionary *rootDic = [[NSDictionary alloc] initWithContentsOfFile:plistPath];
    return rootDic;
}
- (NSDictionary *) getSystemInfo
{
    return [self getSystemInfo:@"DMConfig"];
}

- (NSString *) getSystemName
{
    NSDictionary *rootDic = [self getSystemInfo];
    return [rootDic objForKey:@"systemName"];
}
- (NSString *) getSystemServer
{
    NSDictionary *rootDic = [self getSystemInfo];
    return [rootDic objForKey:@"serviceUrl"];
}
- (NSString *) getSystemLogo
{
    NSDictionary *rootDic = [self getSystemInfo];
    return [rootDic objForKey:@"systemLogo"];
}



@end
