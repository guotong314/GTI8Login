//
//  GTUser.m
//  GTUser
//
//  Created by 郭通 on 17/1/10.
//  Copyright © 2017年 郭通. All rights reserved.
//

#import "GTUser.h"
#import <GTSpec/PersistenceHelper.h>
#import <GTSpec/ValueForKey.h>

static GTUser *current_user;
NSString * const kUserKey_baseInfo = @"i8Workuserkey";


@implementation GTUser

+ (GTUser *)currentUser
{
    return current_user == nil?[self getLocalUserInfo]:current_user;
}
+ (GTUser *)sharedUser
{
    static GTUser *shared;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        shared = [[self alloc] init];
    });
    return shared;
    
}
+ (GTUser *)getLocalUserInfo
{
    id obj = [PersistenceHelper dataForKey:kUserKey_baseInfo];
    if(obj)
    {
        [self setUserInfo:obj];
        [GTUser setCurrentUser:[GTUser sharedUser]];
        return [GTUser sharedUser];
    }
    return nil;
}
+ (id)userWithDictionary:(NSMutableDictionary *)dict
{
    [GTUser setUserInfo:dict];
    [GTUser setCurrentUser:[GTUser sharedUser]];
    return [GTUser sharedUser];
}
+ (void)setCurrentUser:(GTUser *)user
{
    current_user = user;
    [PersistenceHelper setData:user.dict forKey:kUserKey_baseInfo];
}
+ (void) setUserInfo:(id)obj
{
    [GTUser sharedUser].userAccount = [obj objectForKey:@"userAccount"];
    [GTUser sharedUser].userPassword = [obj objectForKey:@"userPassword"];
    [GTUser sharedUser].userID = [obj objectForKey:@"ID"];
    [GTUser sharedUser].userNickName = [obj objectForKey:@"Name"];
    [GTUser sharedUser].userAvatarUrl = [obj objectForKey:@"Image"];
    [GTUser sharedUser].userToken = [obj objectForKey:@"Message"];
    [GTUser sharedUser].deptAndPos = [obj objectForKey:@"DeptAndPos"];
    [GTUser sharedUser].dict = [[NSMutableDictionary alloc] initWithDictionary:obj];
    
    if (![[[GTUser sharedUser].dict objForKey:@"Navbar"] isKindOfClass:[NSArray class]]) {
        [[GTUser sharedUser].dict setObject:@[] forKey:@"Navbar"];
    }
}

+ (void) removeUser
{
    [PersistenceHelper removeForKey:kUserKey_baseInfo];
    current_user = nil;
}
@end
