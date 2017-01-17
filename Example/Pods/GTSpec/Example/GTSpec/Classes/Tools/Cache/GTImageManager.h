//
//  DMImageManager.h
//  i8WorkClient
//
//  Created by 郭通 on 16/7/8.
//  Copyright © 2016年 郭通. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void (^callBack) (NSError *error);
@interface GTImageManager : NSObject

+ (void)downImage:(NSString *)aUrl;
+ (void)downImage:(NSString *)aUrl withCallBack:(callBack)callBack;
@end
