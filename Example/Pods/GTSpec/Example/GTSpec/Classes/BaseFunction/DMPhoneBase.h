//
//  DMPhoneBase.h
//  i8WorkClient
//
//  Created by 郭通 on 16/12/30.
//  Copyright © 2016年 郭通. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DMPhoneBase : NSObject

+ (instancetype) sharePhoneBase;

+ (void) palyPhone:(NSString *)phoneNum;

- (void) palyEmail:(NSString *)subject withTo:(NSArray *)to withContent:(NSString *)content withDelegate:(UIViewController *)vc;

@end
