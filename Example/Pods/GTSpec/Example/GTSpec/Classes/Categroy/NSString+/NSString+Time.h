//
//  NSString+Time.h
//  i8WorkClient
//
//  Created by 郭通 on 16/11/21.
//  Copyright © 2016年 郭通. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString(Time)

// 根据传入的时间戳和时间格式，格式化时间
- (NSString *)transformTimestampWithFormat:(NSString *)formatstr andTimeZome:(NSString *)timeZone;
// 使用常用格式(yyyy年MM月dd日 HH:mm:ss)格式化时间
- (NSString *)transformTimestampInNormalFormat;
- (NSString *)transformTimestampSpecialFormat;
- (NSDate *)transFormDateFromTimestamp;
- (NSString*)imTimeStringShortVersion:(BOOL)shortVersion;

@end
