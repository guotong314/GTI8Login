//
//  DMCompanyInfo.m
//  i8WorkClient
//
//  Created by 郭通 on 16/7/27.
//  Copyright © 2016年 郭通. All rights reserved.
//

#import "GTCompanyInfo.h"

NSString * const kDMCompany_InfoKey = @"companyInfokey";

@implementation GTCompanyInfo

- (instancetype) initWithDic:(NSDictionary *)dic
{
    self = [super init];
    if (self) {
        self.companyLogo = [dic objForKey:@"companyLogo"];
        self.companyName = [dic objForKey:@"companyName"];
        self.loginBackImageUrl = [dic objForKey:@"loginBackImage"];
        self.registerHidden = [[dic objForKey:@"registerHidden"] boolValue];
    }
    return self;
}

+ (void) storeCompanyInfo:(NSDictionary *)dic
{
    [PersistenceHelper setData:dic forKey:kDMCompany_InfoKey];
}
+ (GTCompanyInfo *) getCompanyInfo
{
    NSDictionary *dic = [PersistenceHelper dataForKey:kDMCompany_InfoKey];
    return [[GTCompanyInfo alloc] initWithDic:dic];
}
@end
