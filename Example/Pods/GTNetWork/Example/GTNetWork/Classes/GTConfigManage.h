//
//  GTConfigManage.h
//  GTNetWork
//
//  Created by 郭通 on 17/1/10.
//  Copyright © 2017年 郭通. All rights reserved.
//

#import <Foundation/Foundation.h>

#define ConfigManage [GTConfigManage sharedInstance]
@interface GTConfigManage : NSObject

@property (nonatomic, copy) NSString *appUpdateUrl;
@property (nonatomic, copy) NSString *fileServerURL;
@property (nonatomic, assign) BOOL isHttps;


+(instancetype) sharedInstance;

- (NSString *) configServerURL:(NSString *)aServerStr;

- (NSString *) combineServerURL:(NSString *)aServerStr;

- (NSURL *) getFileServer;

- (NSString *) getSystemName;
- (NSString *) getSystemServer;
- (NSString *) getSystemLogo;

- (id) getSystemConfig:(NSString *)config;

//- (NSString *) configImFileURL:(NSString *)attid withName:(NSString *)fileName withWidth:(float)width withLevel:(NSInteger)level;

- (NSString *) getPreviousServerUrl;
- (void) savePreviousServerUrl:(NSString *)serverUrl;
@end
