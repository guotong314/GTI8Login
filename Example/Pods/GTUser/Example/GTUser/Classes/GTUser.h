//
//  GTUser.h
//  GTUser
//
//  Created by 郭通 on 17/1/10.
//  Copyright © 2017年 郭通. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GTUser : NSObject

@property (nonatomic, retain) NSMutableDictionary *dict;

@property (nonatomic,copy) NSString *userAccount;
@property (nonatomic,copy) NSString *userPassword;
@property (nonatomic,copy) NSString *userID;
@property (nonatomic,copy) NSString *userNickName;
@property (nonatomic,copy) NSString *userAvatarUrl;
@property (nonatomic,copy) NSString *userToken;
@property (nonatomic,copy) NSString *deptAndPos;

@property (nonatomic,assign) BOOL isInviteMember;
@property (nonatomic,copy) NSString *regWechat;
@property (nonatomic,copy) NSString *regPhone;

+ (GTUser *)currentUser;

+ (id)userWithDictionary:(NSMutableDictionary *)dict;

+ (void)setCurrentUser:(GTUser *)user;

+ (void) removeUser;


@end
