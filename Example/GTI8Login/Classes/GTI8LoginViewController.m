//
//  GTI8LoginViewController.m
//  GTI8Login
//
//  Created by 郭通 on 17/1/16.
//  Copyright © 2017年 郭通. All rights reserved.
//

#import "GTI8LoginViewController.h"
#import <IQKeyboardManager.h>
#import <IQKeyboardReturnKeyHandler.h>
#import "GTLoginTextField.h"
#import "GTLoginButton.h"
#import "GTCompanyInfo.h"
#import <GTSpec/GTPhotoCache.h>
#import <GTNetWork/GTConfigManage.h>
#import "GTHttpClient+Login.h"
#import <GTSpec/GTRemindView.h>
#import <GTNetWork/GTNetConstants.h>
#import <GTUser.h>
#import <GTSpec/GTBaseRule.h>
#import <GTSpec/GTImageManager.h>

#import "GTServiceConfigViewController.h"

NSString * const kUserKey_previousUserAccount = @"previousUserAccountkey";


@interface GTI8LoginViewController ()

@property (strong, nonatomic) UIImageView *backImageView;

@property (strong, nonatomic) UIImageView *logoImageView;

@property (strong, nonatomic) GTLoginTextField *userAccountField;
@property (strong, nonatomic) GTLoginTextField *userPasswordField;

@property (strong, nonatomic) GTLoginButton *loginBtn;
@property (strong, nonatomic) UIButton *configBtn;
@property (strong, nonatomic) UILabel *commpanyName;

@end

@implementation GTI8LoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    [self.navigationController setNavigationBarHidden:YES];
    // Do any additional setup after loading the view
    
    [self setupView];
    
    self.userAccountField.ly_placeholder = @"用户名";
    self.userPasswordField.ly_placeholder = @"密码";
    
    [self reloadLoginInfo];
    // 登录按钮的点击方法 判断是否可以点击
    @weakify(self);
    self.loginBtn.clickBlock = ^{
        @strongify(self);
        if (self.userAccountField.textValue.length) {
             [self.loginBtn clickAnimation];
            self.view.userInteractionEnabled = NO;
            [self.userAccountField regsinField];
            [self.userPasswordField regsinField];

        }
    };
    // 登录按钮动画结束开始loading时  请求数据
    self.loginBtn.translateBlock = ^{
        @strongify(self);
        NSDictionary *param = [[NSDictionary alloc] initWithObjectsAndKeys:[self.userAccountField textValue],
                               @"name",self.userPasswordField.textValue,@"pwd",@"true",@"persistent", nil];
        [HTTPCLIENT loginWithParams:param completionHandler:^(id object, NSError *error) {
            self.view.userInteractionEnabled = YES;
            if (!error) {
                // 缓存当前登录的用户名
                [PersistenceHelper setData:self.userAccountField.textValue forKey:kUserKey_previousUserAccount];
                
                // 存储当前用户的信息
                NSMutableDictionary *muDic = [[NSMutableDictionary alloc] initWithDictionary:object[@"Data"]];
                [muDic setValue:self.userAccountField.textValue forKey:@"userAccount"];
                [muDic setValue:self.userPasswordField.textValue forKey:@"userPassword"];
                [muDic setValue:object[@"Message"] forKey:@"Message"];
                [GTUser userWithDictionary:muDic];
                
                // 存储首页 主应用 的信息（名称，图片，类型）
                [PersistenceHelper setData:[[object objForKey:@"Data"] objForKey:@"Navbar"] forKey:@"mainMenuMakeKey"];
                // 跳转主页面
                [GTBaseRule openURL:@"dm://showRootVC"];
            }else{
                // 登录失败 还原登录按钮
                [self.loginBtn restoreButton];
                // 弹出错误信息
                [GTRemindView showWithMesssage:error.userInfo[kDMErrorUserInfoMsgKey]];
            }
        }];
    };

}
- (void) viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    // 启用 IQKeyboard 并配置
    [IQKeyboardManager sharedManager].enable = YES;
    [self configKeyboard];
    // 根据本地 服务器信息 加载登录页面
    [self reloadLoginInfo];
    
    NSString *serverUrl = [ConfigManage getPreviousServerUrl];
    // 服务器地址不存在 就去配置
    if (!serverUrl) {
        [self configServiceAnimate:NO];
    }else{
        //每次进入登录页 通过接口获取 最新的服务器信息
        [self getLoginViewInfo];
    }

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
// 绘制登录页面
- (void) setupView
{
    [self.view addSubview:self.backImageView];
    [self.view addSubview:self.logoImageView];
    [self.view addSubview:self.commpanyName];
    [self.view addSubview:self.userAccountField];
    [self.view addSubview:self.userPasswordField];
    [self.view addSubview:self.loginBtn];
    [self.view addSubview:self.configBtn];
    
    @weakify(self);
    [self.backImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        @strongify(self);
        make.top.bottom.left.right.mas_equalTo(self.view);
    }];
    [self.logoImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        @strongify(self);
        make.top.mas_equalTo(self.view).mas_offset(64);
        make.centerX.mas_equalTo(self.view);
        make.width.height.mas_equalTo(88);
    }];
    [self.commpanyName mas_makeConstraints:^(MASConstraintMaker *make) {
        @strongify(self);
        make.top.mas_equalTo(self.logoImageView.mas_bottom).mas_offset(8);
        make.left.mas_equalTo(self.view).mas_offset(8);
        make.right.mas_equalTo(self.view).mas_offset(-8);
        make.height.mas_equalTo(24);
    }];
    [self.userAccountField mas_makeConstraints:^(MASConstraintMaker *make) {
        @strongify(self);
        make.top.mas_equalTo(self.commpanyName.mas_bottom).mas_offset(8);
        make.left.mas_equalTo(self.view).mas_offset(30);
        make.right.mas_equalTo(self.view).mas_offset(-30);
        make.height.mas_equalTo(40);
    }];
    [self.userPasswordField mas_makeConstraints:^(MASConstraintMaker *make) {
        @strongify(self);
        make.top.mas_equalTo(self.userAccountField.mas_bottom).mas_offset(12);
        make.left.mas_equalTo(self.view).mas_offset(30);
        make.right.mas_equalTo(self.view).mas_offset(-30);
        make.height.mas_equalTo(40);
    }];
//    self.loginBtn.frame = CGRectMake(30, 200, UI_SCREEN_WIDTH - 60, 40);
    [self.loginBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        @strongify(self);
        make.top.mas_equalTo(self.userPasswordField.mas_bottom).mas_offset(12);
        make.left.mas_equalTo(self.view).mas_offset(30);
        make.right.mas_equalTo(self.view).mas_offset(-30);
        make.height.mas_equalTo(44);
    }];
    [self.configBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        @strongify(self);
        make.top.mas_equalTo(self.loginBtn.mas_bottom);
        make.right.mas_equalTo(self.view).mas_offset(-40);
        make.width.height.mas_equalTo(44);
    }];
}
- (void) reloadLoginInfo
{
    GTCompanyInfo *companyInfo = [GTCompanyInfo getCompanyInfo];
    
    UIImage *backImg = [[GTPhotoCache sharedPhotoCache] imageForKey:[self combineImageURL:companyInfo.loginBackImageUrl]];
    UIImage *logoImg = [[GTPhotoCache sharedPhotoCache] imageForKey:[self combineImageURL:companyInfo.companyLogo]];
    self.backImageView.image = backImg;
    self.logoImageView.layer.masksToBounds = YES;
    self.logoImageView.image = logoImg?:[UIImage imageNamed:[ConfigManage getSystemLogo]];
    self.commpanyName.text = companyInfo.companyName?:[ConfigManage getSystemName];
}
- (void) getLoginViewInfo
{
    NSString *serverUrl = [ConfigManage getPreviousServerUrl];
    [HTTPCLIENT configServiceUrl:serverUrl withParams:@{} completionHandler:^(id object, NSError *error) {
        if (!error) {
            //存储服务器信息
            NSDictionary *dataDic = [object objForKey:@"Data"];
            NSDictionary *dic = @{@"companyName":[dataDic objForKey:@"Title"]?:@"",@"companyLogo":[dataDic objForKey:@"Logo"]?:@"",@"loginBackImage":[dataDic objForKey:@"LogonBg"]?:@""};
            [GTCompanyInfo storeCompanyInfo:dic];
            // 通过服务器信息获取图片logo，并加载登录页
            GTCompanyInfo *companyInfo = [GTCompanyInfo getCompanyInfo];
            [GTImageManager downImage:companyInfo.companyLogo withCallBack:^(NSError *error) {
                [GTImageManager downImage:companyInfo.loginBackImageUrl withCallBack:^(NSError *error) {
                    [self reloadLoginInfo];
                }];
            }];
        }else{
            [GTRemindView showWithMesssage:error.userInfo[kDMErrorUserInfoMsgKey]];
        }
    }];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/
- (void) configAction
{
    [self configServiceAnimate:YES];
}
- (void) configServiceAnimate:(BOOL) animate
{
    GTServiceConfigViewController *serviceVC = [[GTServiceConfigViewController alloc] init];
    serviceVC.isShowBack = animate;
    //    [self.navigationController pushViewController:serviceVC animated:animate];
    [self presentViewController:serviceVC animated:YES completion:nil];
}

#pragma mark - provite
- (NSString *)combineImageURL:(NSString *)url
{
    if (![url hasPrefix:@"http://"] &&  ![url hasPrefix:@"https://"]) {
        return [ConfigManage combineServerURL:url];
    }
    return url;
}
#pragma mark - progperty
- (UIImageView *) backImageView
{
    if (!_backImageView) {
        _backImageView = [[UIImageView alloc] init];
    }
    return _backImageView;
}
- (UIImageView *) logoImageView
{
    if (!_logoImageView) {
        _logoImageView = [[UIImageView alloc] init];
        _logoImageView.alpha = .75;
        _logoImageView.layer.masksToBounds = YES;
        _logoImageView.layer.cornerRadius = 4.0;
    }
    return _logoImageView;
}
- (UILabel *) commpanyName
{
    if (!_commpanyName) {
        _commpanyName = [[UILabel alloc] init];
        _commpanyName.font = FONT_(20);
        _commpanyName.textAlignment = NSTextAlignmentCenter;
        _commpanyName.shadowColor = [UIColor whiteColor];
        _commpanyName.shadowOffset = CGSizeMake(2, 2);

    }
    return _commpanyName;
}
- (GTLoginTextField *) userAccountField
{
    if (!_userAccountField) {
        _userAccountField = [[GTLoginTextField alloc] init];
        [_userAccountField setAutocorrection:UITextAutocorrectionTypeNo];
        _userAccountField.textMode = UITextFieldViewModeWhileEditing;
        _userAccountField.autocapitalization = UITextAutocapitalizationTypeNone;
    }
    return _userAccountField;
}
- (GTLoginTextField *) userPasswordField
{
    if (!_userPasswordField) {
        _userPasswordField = [[GTLoginTextField alloc] init];
        [_userPasswordField setAutocorrection:UITextAutocorrectionTypeNo];
        _userPasswordField.textMode = UITextFieldViewModeWhileEditing;
        _userPasswordField.enableReturnKey = YES;
        _userPasswordField.secureTextEntry = YES;
        _userPasswordField.autocapitalization = UITextAutocapitalizationTypeNone;
    }
    return _userPasswordField;
}
- (GTLoginButton *) loginBtn
{
    if (!_loginBtn) {
        _loginBtn = [[GTLoginButton alloc] init];
        _loginBtn.btnTitle = @"登录";
    }
    return _loginBtn;
}
- (UIButton *) configBtn
{
    if (!_configBtn) {
        _configBtn = [[UIButton  alloc] init];
        _configBtn.backgroundColor = [UIColor clearColor];
        [_configBtn setTitle:@"配置" forState:UIControlStateNormal];
        [_configBtn setTitleColor:RGBA(55, 117, 189, 1) forState:UIControlStateNormal];
        _configBtn.titleLabel.font = FONT_(13);
        [_configBtn addTarget:self action:@selector(configAction) forControlEvents:UIControlEventTouchUpInside];
    }
    return _configBtn;
}
@end
