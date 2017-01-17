//
//  DMPhoneBase.m
//  i8WorkClient
//
//  Created by 郭通 on 16/12/30.
//  Copyright © 2016年 郭通. All rights reserved.
//

#import "DMPhoneBase.h"
#import <MessageUI/MessageUI.h>

@interface DMPhoneBase()<MFMailComposeViewControllerDelegate>

@end

@implementation DMPhoneBase
+ (instancetype) sharePhoneBase
{
    static DMPhoneBase *agent;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        agent = [[DMPhoneBase alloc] init];
    });
    return agent;
}
// 打电话
+ (void) palyPhone:(NSString *)phoneNum
{
    if (!phoneNum && ![phoneNum isKindOfClass:[NSString class]] && phoneNum.length == 0) {
        return;
    }
    NSMutableString *telStr=[[NSMutableString alloc]initWithFormat:@"tel://%@",phoneNum];
    BOOL isPhone=  [[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"tel://"]];//[[UIApplication sharedApplication]canOpenURL:[NSURL URLWithString:phoneNum]];
    if (isPhone) {
        [[UIApplication sharedApplication]openURL:[NSURL URLWithString:telStr]];
    }
    else if (!isPhone)
    {
        UIAlertView * aView=[[UIAlertView alloc]initWithTitle:nil message:@"当前设备不支持电话功能或检查SIM卡是否存在" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [aView show];
    }
}

- (void) palyEmail:(NSString *)subject withTo:(NSArray *)to withContent:(NSString *)content withDelegate:(UIViewController *)vc
{
    MFMailComposeViewController *picker = [[MFMailComposeViewController alloc] init];
    picker.mailComposeDelegate = self;
    //设置主题
    [picker setSubject:subject];
    //设置收件人
    [picker setToRecipients:to];
    NSString *emailBody = content;
    [picker setMessageBody:emailBody isHTML:NO];
    
    //邮件发送的模态窗口
    [vc presentViewController:picker animated:YES completion:nil];

}
@end
