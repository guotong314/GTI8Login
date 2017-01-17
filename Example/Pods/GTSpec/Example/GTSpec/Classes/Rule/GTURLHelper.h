//
//  GTURLHelper.h
//  GTSpec
//
//  Created by 郭通 on 17/1/11.
//  Copyright © 2017年 郭通. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GTURLHelper : NSObject

/**
 *  scheme
 */
@property (strong, nonatomic, readonly) NSString *scheme;

/**
 *  host
 */
@property (strong, nonatomic, readonly) NSString *host;

/**
 *  path
 */
@property (strong, nonatomic, readonly) NSString *path;

/**
 *  URL 中的参数列表
 */
@property (strong, nonatomic, readonly) NSDictionary *params;

/**
 *  URL String
 */
@property (strong, nonatomic, readonly) NSString *absoluteString;

/**
 *  从 URL 字符串创建 URLEntity
 *
 *  @param urlString url
 *
 *  @return 对应的 URLEntity
 */
+ (instancetype)URLWithString:(NSString * _Nonnull)urlString;


@end
