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

@interface GTServiceConfigViewController ()<UIViewControllerTransitioningDelegate>
@property (nonatomic, strong) UIImageView *iconImageView;
@property (nonatomic, strong) GTLoginTextField *serviceField;
@property (nonatomic, strong) GTLoginButton *configBtn;
@property (nonatomic, strong) UIButton *backBtn;

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
        make.bottom.mas_equalTo(self.configBtn.mas_top).mas_offset(-20);
        make.left.mas_equalTo(self.view).mas_offset(30);
        make.right.mas_equalTo(self.view).mas_offset(-30);
        make.height.mas_equalTo(44);
    }];
    [self.iconImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        @strongify(self);
        make.bottom.mas_equalTo(self.serviceField.mas_top).mas_offset(-20);
        make.centerX.mas_equalTo(self.view);
        make.height.mas_equalTo(88);
        make.width.mas_equalTo(88);
    }];
    
    self.configBtn.clickBlock = ^{
        @strongify(self);
        if (self.serviceField.textValue.length) {
            [self.configBtn clickAnimation];
            self.view.userInteractionEnabled = NO;
            [self.serviceField regsinField];
            
        }
    };
    self.configBtn.translateBlock = ^{
        @strongify(self);
        [self configAction];
    };

}
- (void) viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    GTCompanyInfo *companyInfo = [GTCompanyInfo getCompanyInfo];
    UIImage *logoImg = [[GTPhotoCache sharedPhotoCache] imageForKey:[self combineImageURL:companyInfo.companyLogo]];
    self.iconImageView.image = logoImg?:[UIImage imageNamed:[ConfigManage getSystemLogo]];
    
    self.serviceField.alpha = 0;
    self.configBtn.alpha = 0;
    [UIView animateWithDuration:1.0f animations:^{
        self.serviceField.alpha = 1;
    } completion:^(BOOL finished) {
        [self.serviceField becomeFirstResponder];
        [UIView animateWithDuration:1.0 animations:^{
            self.configBtn.alpha = 1;
        }];
    }];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void) goBack
{
    //    [self.navigationController  popViewControllerAnimated:YES];
    [self dismissViewControllerAnimated:YES completion:nil];
}
- (void) configAction
{
    
//    MBProgressHUD *hud = [MBProgressHUD showMessag:@"" toView:nil];
    
    NSString *serverStr = self.serviceField.textValue;
    serverStr = [ConfigManage configServerURL:serverStr];
    serverStr = [serverStr lowercaseString];
    
    [HTTPCLIENT configServiceUrl:serverStr withParams:@{} completionHandler:^(id object, NSError *error) {
        if (!error) {
            NSDictionary *dataDic = [object objForKey:@"Data"];
            NSDictionary *dic = @{@"companyName":[dataDic objForKey:@"Title"]?:@"",@"companyLogo":[dataDic objForKey:@"Logo"]?:@"",@"loginBackImage":[dataDic objForKey:@"LogonBg"]?:@""};
            [GTCompanyInfo storeCompanyInfo:dic];
            
            [[GTConfigManage sharedInstance] setFileServerURL:serverStr];
            [ConfigManage savePreviousServerUrl:serverStr];
            //            [PersistenceHelper setData:serverStr forKey:kUserKey_previousServerURL];
            
            GTCompanyInfo *companyInfo = [GTCompanyInfo getCompanyInfo];
            [GTImageManager downImage:companyInfo.companyLogo withCallBack:^(NSError *error) {
                [GTImageManager downImage:companyInfo.loginBackImageUrl withCallBack:^(NSError *error) {
                    [self goBack];
                }];
            }];
        }else{

            if (error.userInfo[kDMErrorUserInfoMsgCode] && [serverStr hasPrefix:@"https"]) {
                NSLog(@"errHttps:%@",error.domain);
                [GTConfigManage sharedInstance].isHttps = NO;
                [self configAction];
            }else{
                [self.configBtn restoreButton];
                [GTConfigManage sharedInstance].isHttps = YES;
                NSLog(@"errHttp:%@",error.domain);
                [GTRemindView showWithMesssage:error.userInfo[kDMErrorUserInfoMsgKey]];
            }
            
        }
    }];
}
/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */
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
//        _serviceField = [[UITextField alloc] init];
//        _serviceField.textAlignment = NSTextAlignmentCenter;
//        _serviceField.placeholder = @"请输入服务器地址";
//        _serviceField.font = FONT_Bold_(15);
//        _serviceField.textColor = RGBA(151, 151, 151, 1);
//        _serviceField.keyboardType = UIKeyboardTypeURL;
//        _serviceField.layer.borderWidth = 1.0;
//        _serviceField.layer.borderColor = RGBA(151, 151, 151, 1).CGColor;
//        _serviceField.layer.masksToBounds = YES;
//        _serviceField.layer.cornerRadius = 4.0;
//        [_serviceField setAutocorrectionType:UITextAutocorrectionTypeNo];
//        _serviceField.clearButtonMode = UITextFieldViewModeWhileEditing;
//        
//        [_serviceField setAutocapitalizationType:UITextAutocapitalizationTypeNone];
        _serviceField = [[GTLoginTextField alloc] init];
        _serviceField.ly_placeholder = @"服务器地址";
//        _serviceField.textAlignment = NSTextAlignmentCenter;
        _serviceField.keyboardType = UIKeyboardTypeURL;
        [_serviceField setAutocorrection:UITextAutocorrectionTypeNo];
        _serviceField.textMode = UITextFieldViewModeWhileEditing;
        _serviceField.autocapitalization = UITextAutocapitalizationTypeNone;
        
    }
    return _serviceField;
}
- (GTLoginButton *) configBtn
{
    if (!_configBtn) {
//        _configBtn = [[UIButton alloc] init];
//        _configBtn.backgroundColor = RGBA(81, 81, 81, 1);//[UIColor blackColor];//RGBA(41, 108, 254, 1);
//        [_configBtn setTitle:@"继续" forState:UIControlStateNormal];
//        [_configBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
//        _configBtn.titleLabel.font = FONT_Bold_(16);
//        _configBtn.layer.masksToBounds = YES;
//        [_configBtn addTarget:self action:@selector(configAction) forControlEvents:UIControlEventTouchUpInside];
//        _configBtn.layer.cornerRadius = 4.0;
        _configBtn = [[GTLoginButton alloc] init];
        _configBtn.btnTitle = @"继续";
        
    }
    return _configBtn;
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
