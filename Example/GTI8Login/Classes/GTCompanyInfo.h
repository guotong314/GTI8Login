//
//  DMCompanyInfo.h
//  i8WorkClient
//
//  Created by 郭通 on 16/7/27.
//  Copyright © 2016年 郭通. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GTCompanyInfo : NSObject

@property (nonatomic, copy) NSString *companyLogo;
@property (nonatomic, copy) NSString *companyName;
@property (nonatomic, copy) NSString *loginBackImageUrl;

+ (void) storeCompanyInfo:(NSDictionary *)dic;
+ (GTCompanyInfo *) getCompanyInfo;
- (instancetype) initWithDic:(NSDictionary *)dic;


@end
