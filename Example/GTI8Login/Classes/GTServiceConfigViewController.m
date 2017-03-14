//
//  GTServiceConfigViewController.m
//  GTI8Login
//
//  Created by 郭通 on 17/1/17.
//  Copyright © 2017年 郭通. All rights reserved.
//

#import "GTServiceConfigViewController.h"
#import "GTTranstionAnimation.h"
#import "GTCompanyInfo.h"
#import <GTSpec/GTPhotoCache.h>
#import <GTNetWork/GTConfigManage.h>
#import "GTHttpClient+Login.h"
#import <GTSpec/GTImageManager.h>
#import <GTSpec/GTRemindView.h>
#import <GTNetWork/GTNetConstants.h>
#import "GTLoginButton.h"
#import "GTLoginTextField.h"

#import <IQKeyboardManager.h>
#import <IQKeyboardReturnKeyHandler.h>
#import "GTLoadingButton.h"

#import "GTBaseRule.h"

#define domainStr  @".atuyun.cn"

@interface GTServiceConfigViewController ()<UIViewControllerTransitioningDelegate>
@property (nonatomic, strong) UIImageView *iconImageView;
@property (nonatomic, strong) GTLoginTextField *serviceField;
@property (nonatomic, strong) GTLoadingButton *configBtn;
@property (nonatomic, strong) UIButton *backBtn;
@property (nonatomic, strong) UIButton *registerBtn;
@property (nonatomic, strong) UIButton *forgetDomainBtn;

@end

@implementation GTServiceConfigViewController

-(instancetype)init{
    if(self = [super init]){
        self.transitioningDelegate = self;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    [self.navigationController setNavigationBarHidden:YES];
    [self setHidesBottomBarWhenPushed:YES];
    
    if (self.isShowBack) {
        _backBtn = [[UIButton  alloc] initWithFrame:CGRectMake(4, 20, 44, 44)];
        [_backBtn setTitle:@"返回" forState:UIControlStateNormal];
        [_backBtn setTitleColor:RGBA(151, 151, 151, 1) forState:UIControlStateNormal];
        _backBtn.titleLabel.font = FONT_(14);
        [_backBtn addTarget:self action:@selector(goBack) forControlEvents:UIControlEventTouchUpInside];
        _backBtn.backgroundColor = [UIColor clearColor];
        [self.view addSubview:_backBtn];
    }
    [self.view addSubview:self.iconImageView];
    [self.view addSubview:self.configBtn];
    [self.view addSubview:self.serviceField];
    [self.view addSubview:self.registerBtn];
    
    BOOL isAtuyunHidden = [[ConfigManage getSystemConfig:@"registerHidden"] boolValue];
    
    float serviceRight = isAtuyunHidden?-30:-150;
    float serviceTop = -20;
    
    @weakify(self);
    
    [self.configBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        @strongify(self);
        make.bottom.mas_equalTo(self.view.mas_bottom).mas_offset( - UI_SCREEN_HEIGHT * 1/2);
        make.left.mas_equalTo(self.view).mas_offset(30);
        make.right.mas_equalTo(self.view).mas_offset(-30);
        make.height.mas_equalTo(44);
    }];
    
    [self.serviceField mas_makeConstraints:^(MASConstraintMaker *make) {
        @strongify(self);
        make.bottom.mas_equalTo(self.configBtn.mas_top).mas_offset(serviceTop);
        make.left.mas_equalTo(self.view).mas_offset(30);
        make.right.mas_equalTo(self.view).mas_offset(serviceRight);
        make.height.mas_equalTo(44);
    }];
    self.serviceField.changeTextBlock = ^(NSString *value){
        @strongify(self);
        [UIView animateWithDuration:0.3 animations:^{
            if (value.length) {
                self.configBtn.backgroundColor = RGB(244, 42, 25);
            }else{
                self.configBtn.backgroundColor = [UIColor lightGrayColor];
            }
        }];
    };

    [self.iconImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        @strongify(self);
        make.bottom.mas_equalTo(self.serviceField.mas_top).mas_offset(-20);
        make.centerX.mas_equalTo(self.view);
        make.height.mas_equalTo(88);
        make.width.mas_equalTo(88);
    }];
    
    UIView *bottomLineView = [[UIView alloc] init];
    bottomLineView.backgroundColor = RGB(189, 189, 189);
    [self.view addSubview:bottomLineView];
    
    [bottomLineView mas_makeConstraints:^(MASConstraintMaker *make) {
        @strongify(self);
//        make.top.mas_equalTo.(self.serviceField.mas_bottom
        make.top.mas_equalTo(self.serviceField.mas_bottom).mas_offset(2);
        make.height.mas_offset(0.5);
        make.left.mas_equalTo(30);
        make.right.mas_equalTo(-30);
    }];
    
    if (!isAtuyunHidden) {
        UIView *lineView = [[UIView alloc] init];
        lineView.backgroundColor = RGB(189, 189, 189);
        [self.view addSubview:lineView];
        
        [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
            @strongify(self);
            make.top.mas_equalTo(self.serviceField.mas_top).mas_offset(6);
            make.width.mas_equalTo(0.5);
            make.height.mas_equalTo(30);
            make.left.mas_equalTo(self.serviceField.mas_right).mas_offset(8);
        }];
        
        UILabel *domainLabel = [[UILabel alloc] init];
        domainLabel.text = domainStr;
        domainLabel.textColor = [UIColor blackColor];
        domainLabel.font = FONT_(15);
        [self.view addSubview:domainLabel];
        
        [domainLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            @strongify(self);
            make.left.mas_equalTo(lineView.mas_right).mas_offset(15);
            make.right.mas_equalTo(self.view).mas_offset(-30);
            make.top.height.mas_equalTo(self.serviceField);
        }];
        
        [self.view addSubview:self.forgetDomainBtn];
        [self.forgetDomainBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            @strongify(self);
            make.top.mas_equalTo(self.configBtn.mas_bottom).mas_offset(4);
            make.left.mas_equalTo(self.configBtn);
            make.height.mas_equalTo(40);
            make.width.mas_equalTo(64);
        }];

    }else{
        _serviceField.textField.clearButtonMode = UITextFieldViewModeWhileEditing;
    }
    
    
    [self.registerBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        @strongify(self);
        make.top.mas_equalTo(self.configBtn.mas_bottom).mas_offset(4);
        make.width.mas_equalTo(40);
        make.right.mas_equalTo(self.configBtn);
        make.height.mas_equalTo(40);
    }];

//    GTCompanyInfo *companyInfo = [GTCompanyInfo getCompanyInfo];
    self.registerBtn.hidden = isAtuyunHidden;//companyInfo.registerHidden;
    
    self.serviceField.alpha = 0;
    self.configBtn.alpha = 0;
    [UIView animateWithDuration:1.0f animations:^{
        self.serviceField.alpha = 1;
    } completion:^(BOOL finished) {
        [self.serviceField becomeFirstResponder];
        [UIView animateWithDuration:1.0 animations:^{
            self.configBtn.alpha = 1;
            self.registerBtn.alpha = 1;
            self.forgetDomainBtn.alpha = 1;
        } completion:^(BOOL finished) {
            [self.serviceField becomeAction];
        }];
    }];

}
- (void) viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self.navigationController setNavigationBarHidden:YES animated:YES];
    
    if (ConfigManage.fileServerURL) {
        _serviceField.textField.text = [self getServiceName];
        self.configBtn.backgroundColor = [UIColor redColor];
    }

    // 根据本地存储 加载页面
    GTCompanyInfo *companyInfo = [GTCompanyInfo getCompanyInfo];
    UIImage *logoImg = [[GTPhotoCache sharedPhotoCache] imageForKey:[self combineImageURL:companyInfo.companyLogo]];
    self.iconImageView.image = logoImg?:[UIImage imageNamed:[ConfigManage getSystemLogo]];
    //打开并配置IQKeyboard
    [IQKeyboardManager sharedManager].enable = YES;
    [self configKeyboard];
}
- (void) viewDidDisappear:(BOOL)animated
{
    [IQKeyboardManager sharedManager].enable = NO;
}
- (void) configKeyboard
{
    [IQKeyboardManager sharedManager].enableAutoToolbar = NO; //工具条
    [IQKeyboardManager sharedManager].shouldResignOnTouchOutside = YES; //点击背景收回
    [IQKeyboardManager sharedManager].shouldToolbarUsesTextFieldTintColor = YES;
    [IQKeyboardManager sharedManager].toolbarTintColor = [UIColor lightGrayColor];
    //    [IQKeyboardManager sharedManager].keyboardDistanceFromTextField = 100; //设置键盘textField的距离。不能小于零。默认是10.0
    [IQKeyboardManager sharedManager].shouldShowTextFieldPlaceholder = NO;
    [IQKeyboardManager sharedManager].placeholderFont = [UIFont systemFontOfSize:9.0];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void) goBack
{
    //    [self.navigationController  popViewControllerAnimated:YES];
//    [self dismissViewControllerAnimated:YES completion:nil];
    [UIView transitionWithView:self.navigationController.view
                      duration:0.7
                       options:UIViewAnimationOptionTransitionFlipFromLeft
                    animations:^{
                        [self.navigationController  popViewControllerAnimated:NO];
                    }
                    completion:nil];

}
- (void) registerAction
{
//    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"https://www.atuyun.cn/index.html#/register"]];
    [self.navigationController setNavigationBarHidden:NO animated:NO];
    [GTBaseRule openURL:@"dm://showWebView?url=https://www.atuyun.cn/index.html#/register&webType=1"];
}
- (void) configAction
{
    if (!self.serviceField.textValue.length) {
        return;
    }
    self.view.userInteractionEnabled = NO;
    [HTTPCLIENT checkDomainRegWithParams:@{@"domainName":self.serviceField.textValue} completionHandler:^(id object, NSError *error) {
        NSLog(@"%@",object);
        if ([object isKindOfClass:[NSDictionary class]]) {
            if (![[object objForKey:@"Succeed"] boolValue]) {
                [self.configBtn startAnimation];
                
                [self.serviceField regsinField];

                NSString *serverStr = self.serviceField.textValue;
                serverStr = [self combineService:serverStr];

                [HTTPCLIENT configServiceUrl:serverStr withParams:@{} completionHandler:^(id object, NSError *error) {
                    self.view.userInteractionEnabled = YES;
                    if (!error) {
                        NSDictionary *dataDic = [object objForKey:@"Data"];
                        NSDictionary *dic = @{@"companyName":[dataDic objForKey:@"Title"]?:@"",@"companyLogo":[dataDic objForKey:@"Logo"]?:@"",@"loginBackImage":[dataDic objForKey:@"LogonBg"]?:@""};
                        [GTCompanyInfo storeCompanyInfo:dic];

                        [[GTConfigManage sharedInstance] setFileServerURL:serverStr];
                        [ConfigManage savePreviousServerUrl:serverStr];
                        //            [PersistenceHelper setData:serverStr forKey:kUserKey_previousServerURL];
                        [self goBack];
            //            GTCompanyInfo *companyInfo = [GTCompanyInfo getCompanyInfo];
            //            [GTImageManager downImage:[ConfigManage combineServerURL:companyInfo.companyLogo] withCallBack:^(NSError *error) {
            //                [GTImageManager downImage:[ConfigManage combineServerURL:companyInfo.loginBackImageUrl] withCallBack:^(NSError *error) {
            //                    [self goBack];
            //                }];
            //            }];
                    }else{
                        // 如果用https  请求失败 然后用http再请求
                        if (error.userInfo[kDMErrorUserInfoMsgCode] && [serverStr hasPrefix:@"https"]) {
                            NSLog(@"errHttps:%@",error.domain);
                            [GTConfigManage sharedInstance].isHttps = NO;
                            [self configAction];
                        }else{
            //                [self.configBtn restoreButton];
                            [self.configBtn stopAnimation];
                            [GTConfigManage sharedInstance].isHttps = YES;
                            NSLog(@"errHttp:%@",error.domain);
                            [GTRemindView showWithMesssage:error.userInfo[kDMErrorUserInfoMsgKey]];
                        }
                        
                    }
                }];
            }else{
                self.view.userInteractionEnabled = YES;
                [GTRemindView showWithMesssage:@"域名不存在"];
                [self.configBtn stopAnimation];
            }
        }else{
            self.view.userInteractionEnabled = YES;
            [GTRemindView showWithMesssage:error.userInfo[kDMErrorUserInfoMsgKey]];
            [self.configBtn stopAnimation];
        }
    }];
}
- (void) forgetDomainAction
{
//    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"https://www.atuyun.cn/index.html#/findDomain"]];
    [self.navigationController setNavigationBarHidden:NO animated:NO];
    [GTBaseRule openURL:@"dm://showWebView?url=https://www.atuyun.cn/index.html#/findDomain&webType=1"];

}
/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */
#pragma mark - private
- (NSString *) combineService:(NSString *)url
{
    BOOL isAtuyunHidden = [[ConfigManage getSystemConfig:@"registerHidden"] boolValue];
    NSString *serverStr = url;
    if (!isAtuyunHidden) {
        serverStr = [NSString stringWithFormat:@"%@%@",url,domainStr];
    }
    serverStr = [ConfigManage configServerURL:serverStr];
    serverStr = [serverStr lowercaseString];
    return serverStr;
}
- (NSString *) getServiceName
{
    NSString *service = ConfigManage.fileServerURL;
    BOOL isAtuyunHidden = [[ConfigManage getSystemConfig:@"registerHidden"] boolValue];
    if (!isAtuyunHidden) {
        service = [service stringByReplacingOccurrencesOfString:@"https://" withString:@""];
        service = [service stringByReplacingOccurrencesOfString:@"http://" withString:@""];
        service = [service stringByReplacingOccurrencesOfString:domainStr withString:@""];
    }
    return service;
}
#pragma mark -  touchEvent
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self.serviceField.textField resignFirstResponder];
}
#pragma mark - property
- (UIImageView *) iconImageView
{
    if (!_iconImageView) {
        _iconImageView = [[UIImageView alloc] init];
        _iconImageView.layer.masksToBounds = YES;
        _iconImageView.layer.cornerRadius = 6.0;
    }
    return _iconImageView;
}
- (GTLoginTextField *) serviceField
{
    if (!_serviceField) {
        _serviceField = [[GTLoginTextField alloc] init];
        _serviceField.ly_placeholder = @"输入企业域名";
        _serviceField.lineView.hidden = YES;
//        _serviceField.textAlignment = NSTextAlignmentCenter;
        _serviceField.textField.keyboardType = UIKeyboardTypeURL;
        _serviceField.textField.autocorrectionType = UITextAutocorrectionTypeNo;
//        _serviceField.textField.clearButtonMode = UITextFieldViewModeWhileEditing;
        _serviceField.textField.autocapitalizationType = UITextAutocapitalizationTypeNone;
    }
    return _serviceField;
}
- (GTLoadingButton *) configBtn
{
    if (!_configBtn) {
        _configBtn = [[GTLoadingButton alloc] init];
        _configBtn.backgroundColor = [UIColor lightGrayColor];//RGBA(55, 117, 189, 1);
        [_configBtn setTitle:@"继续" forState:UIControlStateNormal];
        [_configBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        _configBtn.titleLabel.font = FONT_(17);
        _configBtn.layer.masksToBounds = YES;
        _configBtn.layer.cornerRadius = 4.0;
        [_configBtn addTarget:self action:@selector(configAction) forControlEvents:UIControlEventTouchUpInside];

    }
    return _configBtn;
}
- (UIButton *) registerBtn
{
    if (!_registerBtn) {
        _registerBtn = [[UIButton alloc] init];
//        NSMutableAttributedString *str = [[NSMutableAttributedString alloc] initWithString:@"还没有账户？立即在线注册阿图云办公平台"];
        NSMutableAttributedString *str = [[NSMutableAttributedString alloc] initWithString:@"注册"];
//        NSRange strRange = {0,[str length]};
//        [str addAttribute:NSUnderlineStyleAttributeName value:[NSNumber numberWithInteger:NSUnderlineStyleSingle] range:strRange];
        _registerBtn.titleLabel.textAlignment = NSTextAlignmentCenter;
        _registerBtn.titleLabel.textColor = RGB(6, 96, 191);//RGBA(55, 117, 189, 1);
        _registerBtn.titleLabel.font = FONT_(14);
        self.registerBtn.alpha = 0;
        [_registerBtn addTarget:self action:@selector(registerAction) forControlEvents:UIControlEventTouchUpInside];
        [_registerBtn setAttributedTitle:str forState:UIControlStateNormal];//这个状态要加上
    }
    return _registerBtn;
}
- (UIButton *) forgetDomainBtn
{
    if (!_forgetDomainBtn) {
        _forgetDomainBtn = [[UIButton alloc] init];
        NSMutableAttributedString *str = [[NSMutableAttributedString alloc] initWithString:@"忘记域名"];
        //        NSRange strRange = {0,[str length]};
        //        [str addAttribute:NSUnderlineStyleAttributeName value:[NSNumber numberWithInteger:NSUnderlineStyleSingle] range:strRange];
        _forgetDomainBtn.titleLabel.textAlignment = NSTextAlignmentCenter;
        _forgetDomainBtn.titleLabel.textColor = RGB(6, 96, 191);//RGBA(55, 117, 189, 1);
        _forgetDomainBtn.titleLabel.font = FONT_(14);
        _forgetDomainBtn.alpha = 0;
        [_forgetDomainBtn addTarget:self action:@selector(forgetDomainAction) forControlEvents:UIControlEventTouchUpInside];
        [_forgetDomainBtn setAttributedTitle:str forState:UIControlStateNormal];//这个状态要加上
    }
    return _forgetDomainBtn;
}


#pragma mark - provite
- (NSString *)combineImageURL:(NSString *)url
{
    if (![url hasPrefix:@"http://"] &&  ![url hasPrefix:@"https://"]) {
        return [ConfigManage combineServerURL:url];
    }
    return url;
}
#pragma mark - animate delegate
-(id<UIViewControllerAnimatedTransitioning>)animationControllerForPresentedController:(UIViewController *)presented presentingController:(UIViewController *)presenting sourceController:(UIViewController *)source{
    return [GTTranstionAnimation transitionWithTransitionType:XWPresentOneTransitionTypePresent];
}

-(id<UIViewControllerAnimatedTransitioning>)animationControllerForDismissedController:(UIViewController *)dismissed{
    return [GTTranstionAnimation transitionWithTransitionType:XWPresentOneTransitionTypeDismiss];
}

@end
