//
//  NSString+Time.m
//  i8WorkClient
//
//  Created by 郭通 on 16/11/21.
//  Copyright © 2016年 郭通. All rights reserved.
//

#import "NSString+Time.h"

@implementation NSString(Time)

#pragma mark - 格式化时间戳
// 根据传入的时间戳和时间格式，格式化时间
- (NSString *)transformTimestampWithFormat:(NSString *)formatstr andTimeZome:(NSString *)timeZone
{
    NSTimeInterval intervale = [self integerValue];
    
    NSDate *time = intervale>0 ? [NSDate dateWithTimeIntervalSince1970:intervale] : [NSDate date];
    
    NSString *dateString;
    if(formatstr == nil){
        dateString = [NSString stringWithFormat:@"%zd",[time timeIntervalSince1970]];
    } else {
        
        NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
        [dateFormat setDateFormat:formatstr];
        
        if(timeZone != nil) {
            [dateFormat setTimeZone:[NSTimeZone timeZoneWithName:timeZone]];
        }
        dateString = [dateFormat stringFromDate:time];
    }
    
    return dateString;
}

// 使用常用格式(yyyy年MM月dd日 HH:mm:ss)格式化时间
- (NSString *)transformTimestampInNormalFormat
{
    return [self transformTimestampWithFormat:@"yyyy-MM-dd" andTimeZome:nil];
}

- (NSString *)transformTimestampSpecialFormat
{
    NSString *retStr = nil;
    NSTimeInterval intervale = [self integerValue];
    NSDate *refDate = intervale>0 ? [NSDate dateWithTimeIntervalSince1970:intervale] : [NSDate date];
    
    NSString * todayString = [[[NSDate date] description] substringToIndex:10];
    NSString * refDateString = [[refDate description] substringToIndex:10];
    
    // 如果是今天
    if ([refDateString isEqualToString:todayString]) {
        retStr = [self transformTimestampWithFormat:@"HH:mm" andTimeZome:nil];
    } else {
        retStr = [self transformTimestampWithFormat:@"MM-dd" andTimeZome:nil];
    }
    return retStr;
}
- (NSDate *)transFormDateFromTimestamp
{
//    NSDateFormatter* formatter = [[NSDateFormatter alloc] init];
//    [formatter setDateStyle:NSDateFormatterMediumStyle];
//    [formatter setTimeStyle:NSDateFormatterShortStyle];
//    [formatter setDateFormat:@"yyyyMMddHHMMss"];
//    NSDate*inputDate = [formatter dateFromString:self];
    
    NSDate *confromTimesp = [NSDate dateWithTimeIntervalSince1970:[self intValue]];
    // 解决相差8小时bug
//    NSTimeZone *zone = [NSTimeZone systemTimeZone];
//    NSInteger interval = [zone secondsFromGMTForDate:confromTimesp];
//    NSDate *localeDate = [confromTimesp  dateByAddingTimeInterval: interval];
//    NSLog(@"%@",localeDate);
    return confromTimesp;

}
- (NSString*)imTimeStringShortVersion:(BOOL)shortVersion
{
    NSDate *date = [self transFormDateFromTimestamp];
    if (! date) {
        return @"";
    }
    
    NSCalendar* calendar = [NSCalendar currentCalendar];
    NSCalendarUnit unit = NSCalendarUnitYear|NSCalendarUnitMonth|NSCalendarUnitDay|NSCalendarUnitHour|NSCalendarUnitMinute;
    
    NSDateComponents* now = [calendar components:unit fromDate:[NSDate date]];
    
    NSDateComponents* target = [calendar components:unit fromDate:date];
    
    NSInteger year = [now year] - [target year];
    
    if (year > 0) {
        if (year == 1) {
            if (shortVersion) {
                return @"去年";
            }
            else {
                return [NSString stringWithFormat:@"去年 %ld月%ld日",(long)[target month],(long)[target day]];
            }
        }
        
        if (year == 2) {
            if (shortVersion) {
                return @"前年";
            }
            else {
                return [NSString stringWithFormat:@"前年 %ld月%ld日",(long)[target month],(long)[target day]];
            }
        }
        
        if (shortVersion) {
            [NSString stringWithFormat:@"%ld年",(long)[target year]];
        }
        else {
            return [NSString stringWithFormat:@"%ld年 %ld月%ld日",(long)[target year],(long)[target month],(long)[target day]];
        }
        
        //        return [NSString stringWithFormat:@"%ld年前",(long)year];
    }
    NSInteger month = [now month] - [target month];
    if (month > 0) {
        if (shortVersion) {
            return [NSString stringWithFormat:@"%ld月%ld日",(long)[target month],(long)[target day]];
        }else{
            return [NSString stringWithFormat:@"%ld月%ld日 %02ld:%02ld",(long)[target month],(long)[target day],(long)[target hour],(long)[target minute]];
        }
    }
    NSInteger day = [now day] - [target day];
    if (day == 0) {
//        NSInteger hour = [now hour] - [target hour];
//        if (hour == 0) {
//            NSInteger minute = [now minute] - [target minute];
//            if (minute <= 1) {
//                return @"刚刚";
//            }else if (minute <= 10){
//                return [NSString stringWithFormat:@"%ld分钟前",(long)minute];
//            }
//        }
        return [NSString stringWithFormat:@"%02ld:%02ld",(long)[target hour],(long)[target minute]];
    }
    if (day == 1) {
        if (shortVersion) {
            return [NSString stringWithFormat:@"昨天"];
        }else{
            return [NSString stringWithFormat:@"昨天 %02ld:%02ld",(long)[target hour],(long)[target minute]];
        }
    }
    if (day == 2) {
        if (shortVersion) {
            return [NSString stringWithFormat:@"前天"];
        }else{
            return [NSString stringWithFormat:@"前天 %02ld:%02ld",(long)[target hour],(long)[target minute]];
        }
        
    }
    if (day > 2) {
        if (shortVersion) {
            return [NSString stringWithFormat:@"%ld月%ld日",(long)[target month],(long)[target day]];
        }else{
            return [NSString stringWithFormat:@"%ld月%ld日 %02ld:%02ld",(long)[target month],(long)[target day],(long)[target hour],(long)[target minute]];
        }
    }
    
    
    return nil;
}
@end
