//
//  Z3HUDLoginViewController.m
//  Z3Login_Example
//
//  Created by ZZHT on 2019/7/1.
//  Copyright © 2019年 Tony Tony. All rights reserved.
//

#import "Z3HUDLoginViewController.h"
#import "Z3HUDLoginSettingViewController.h"
#import "Z3LoginRequest.h"
#import "Z3MapConfigRequest.h"
#import "Z3PostCoorTransConfigRequest.h"
#import <AFNetworking/UIKit+AFNetworking.h>
#import <PromiseKit/PromiseKit.h>
#import "AFNetworkReachabilityManager.h"
#import "MBProgressHUD+Z3.h"
#import "Z3User.h"
#import "Z3Network.h"
#import "Z3MobileConfig.h"
#import "Z3MapConfig.h"
#import "CoorTranUtil.h"
#define TIMEINTERVAL_LIMIT 10      //时间限制 60秒
#define CLICKTIMES_LIMIT 5         //点击次数限制 至少5次
@interface Z3HUDLoginViewController (){
    int _clickedTimes;
    NSDate * _startClickTime;
}
@property (weak, nonatomic) IBOutlet UITextField *accountField;
@property (weak, nonatomic) IBOutlet UITextField *pwdField;
@property (weak, nonatomic) IBOutlet UILabel *versionLabel;
@property (weak, nonatomic) IBOutlet UIButton *rememberPwdBtn;
@property (weak, nonatomic) IBOutlet UIButton *remenberPwdLabel;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UIButton *cachepwdBtn;
@property (weak, nonatomic) IBOutlet UIButton *forgetpwdBtn;
@property (weak, nonatomic) IBOutlet UIButton *loginBtn;
@property (weak, nonatomic) IBOutlet UIView *accountContainer;
@property (weak, nonatomic) IBOutlet UIView *pwdContainer;
@property (weak, nonatomic) IBOutlet UIView *loginContainer;

@property (nonatomic,strong) Z3BaseRequest *request;
@property (nonatomic,strong) UIActivityIndicatorView *indicatorView;
@property (nonatomic,copy) LoginSuccessBlock success;
@end

@implementation Z3HUDLoginViewController

#pragma mark - life circle
#pragma mark - life circle
- (instancetype)initWithLoginSuccessBlock:(LoginSuccessBlock)success {
    NSBundle *bundle = [NSBundle bundleForClass:[self class]];
    NSString *path = [bundle pathForResource:@"Z3Login" ofType:@"bundle"];
    bundle = [NSBundle bundleWithPath:path];
    self = [super initWithNibName:NSStringFromClass([Z3HUDLoginViewController class]) bundle:bundle];
    if (self == nil) {
        self = [super init];
    }
    if (self) {
        _success = success;
    }
    
    return self;
}

- (void)dealloc {
    if ([self.request isExecuting]) {
        [self.request stop];
    }
}

- (BOOL)prefersStatusBarHidden {
    return YES;
}

#pragma mark - view life circle
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self internal_initSubView];
    //开发阶段默认填充
    NSString *account = [[NSUserDefaults standardUserDefaults] valueForKey:Z3KEY_USER_NAME];
    self.accountField.text = account;
    self.accountField.placeholder = NSLocalizedString(@"str_username_placeholder",@"请输入账号");
    self.pwdField.placeholder = NSLocalizedString(@"str_password_placeholder",@"请输入密码");
    self.titleLabel.text = NSLocalizedString(@"login_title",@"澳门自来水地理信息系统");
    [self.cachepwdBtn setTitle:NSLocalizedString(@"str_remember_password",@"记住密码") forState:UIControlStateNormal];
    [self.forgetpwdBtn setTitle:NSLocalizedString(@"str_login_forget_pwd",@"忘记密码？") forState:UIControlStateNormal];
     [self.loginBtn setTitle:NSLocalizedString(@"str_signin",@"登  录") forState:UIControlStateNormal];
    //是否自动填充密码
    [self internal_autoFillPwd];
    //是否自动登录
    //    [self autoLogin];
    
}
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = YES;
}

- (UIInterfaceOrientationMask)supportedInterfaceOrientations {
    return UIInterfaceOrientationMaskLandscape;
}

#pragma mark - public method

#pragma mark - private metod
- (void)internal_initSubView {
    self.loginContainer.layer.cornerRadius = 6.0f;
    CALayer *shadowLayer =  self.loginContainer.layer;
    shadowLayer.shadowColor = [UIColor colorWithRed:182.0f/255.0f green:183.0f/255.0f blue:195.0f/255.0f alpha:0.35f].CGColor;
    shadowLayer.shadowOpacity = 1;
    shadowLayer.shadowOffset = CGSizeMake(0, 3);
    shadowLayer.shadowRadius = 5;
    self.loginContainer.clipsToBounds = false;
    
    self.accountContainer.layer.cornerRadius =22.5f;
    self.accountContainer.layer.masksToBounds = YES;
    self.accountContainer.layer.borderColor = [[UIColor colorWithRed:0.0f/255.0f green:91.0f/255.0f blue:174.0f/255.0f alpha:1.0f] CGColor];
    self.accountContainer.layer.borderWidth = 1;
    self.accountContainer.alpha = 1;
    
    self.pwdContainer.layer.cornerRadius =22.5f;
    self.pwdContainer.layer.masksToBounds = YES;
    self.pwdContainer.layer.borderColor = [[UIColor colorWithRed:0.0f/255.0f green:91.0f/255.0f blue:174.0f/255.0f alpha:1.0f] CGColor];
    self.pwdContainer.layer.borderWidth = 1;
    self.pwdContainer.alpha = 1;
    
    self.loginBtn.layer.cornerRadius =22;
    self.loginBtn.layer.masksToBounds = YES;
    
    self.versionLabel.userInteractionEnabled = YES;
    UITapGestureRecognizer *labelTapGestureRecognizer = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(appVersionLabelTouchUpInside:)];
    [self.versionLabel addGestureRecognizer:labelTapGestureRecognizer];
    
}

- (void)internal_autoLogin {
//        BOOL isAutoLogin = [[NSUserDefaults standardUserDefaults] boolForKey:KEY_AUTO_LOGIN];
//        if (isAutoLogin && [self check]) {
//            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//                [self login];
//            });
//        }
//    self.autoLoginBtn.selected = isAutoLogin;
    __weak typeof(self) weakSelf = self;
    [self login].then(^(NSDictionary *data){
        return [self concurentGetMobileMapAndTransParams];
    }).catch(^(NSError *error){
        [MBProgressHUD showError:[error localizedDescription]];
    }).finally(^{
        if (weakSelf.success) {
            weakSelf.success(@"登录成功");
            //保存登录信息
            [[NSUserDefaults standardUserDefaults] setValue:self.accountField.text forKey:Z3KEY_USER_NAME];
            [[NSUserDefaults standardUserDefaults] setValue:self.pwdField.text forKey:Z3KEY_USER_PASSWORD];
            [[NSUserDefaults standardUserDefaults] setBool:YES forKey:Z3KEY_USER_LOGIN_FLAG];
            [[NSUserDefaults standardUserDefaults] synchronize];
        }
    });
}

- (void)internal_autoFillPwd {
    BOOL isAutoFillPWD = [[NSUserDefaults standardUserDefaults] boolForKey:Z3KEY_AUTO_FILL_PWD];
    if (isAutoFillPWD ) {
        NSString *pwd = [[NSUserDefaults standardUserDefaults] valueForKey:Z3KEY_USER_PASSWORD];
        self.pwdField.text = pwd;
    }
    self.rememberPwdBtn.selected = isAutoFillPWD;
    
}

- (BOOL)internal_check {
    if (![self.accountField.text length]) {
        [MBProgressHUD showError:NSLocalizedString(@"login_username_empty",@"用户名不能为空")];
        return false;
    }
    if (![self.pwdField.text length]) {
        [MBProgressHUD showError:NSLocalizedString(@"login_password_empty",@"密码不能为空")];
        return false;
    }
    return true;
    
}

//离线登录时,检测登录用户名和密码
- (BOOL)internal_offlineCheck {
    
    
    return YES;
}

- (void)internal_offlineLogin {
    MBProgressHUD *hud  = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.mode = MBProgressHUDModeText;
    hud.label.text = NSLocalizedString(@"login_getting_init_paramters",@"正在初始化参数");
    [self internal_loadOfflineUserInfo];
    [self internal_loadOfflineMapConfig];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        self.success(@{});
    });
}

- (void)internal_loadOfflineUserInfo {
    NSString *path = [[NSBundle mainBundle] pathForResource:@"admin.json" ofType:nil];
    NSError *error = nil;
    NSData *jsonData = [[NSData alloc] initWithContentsOfFile:path];
    id result = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingMutableLeaves error:&error];
    if (error != nil) {
        return;
    }
    [self internal_adapt2UserModel:result];
}

- (void)internal_adapt2UserModel:(NSDictionary *)data {
    NSDictionary *userDict = [data valueForKey:@"user"];
    [self toUser:userDict];
    //保存登录信息
    [[NSUserDefaults standardUserDefaults] setValue:self.accountField.text forKey:Z3KEY_USER_NAME];
    [[NSUserDefaults standardUserDefaults] setValue:self.pwdField.text forKey:Z3KEY_USER_PASSWORD];
    [[NSUserDefaults standardUserDefaults] setBool:YES forKey:Z3KEY_USER_LOGIN_FLAG];
    [[NSUserDefaults standardUserDefaults] synchronize];
    [[Z3MobileConfig shareConfig] setOfflineLogin:YES];
}

- (void)toUser:(NSDictionary *)json {
    NSString *username = [json valueForKey:@"username"];
    NSInteger identifier = [[json valueForKey:@"gid"] integerValue];
    NSString * email = [json valueForKey:@"email"];
    NSString *phone = [json valueForKey:@"phone"];
    NSString *company = [json valueForKey:@"company"];
    NSString *ecode = [json valueForKey:@"ecode"];
    NSInteger groupId = [[json valueForKey:@"groupId"] integerValue];
    NSInteger groupLev = [[json valueForKey:@"groupLev"] integerValue];
    NSString  *groupCode = [json valueForKey:@"groupCode"];
    NSString *groupName = [json valueForKey:@"groupName"];
    NSString *role = [json valueForKey:@"role"];
    NSString *roleCode = [json valueForKey:@"roleCode"];
    NSString *trueName = [json valueForKey:@"trueName"];
    
    [[Z3User shareInstance] setUsername:username ?:@""];
    [[Z3User shareInstance] setUid:identifier];
    [[Z3User shareInstance] setEmail:email ?:@""];
    [[Z3User shareInstance] setPhone:phone ?:@""];
    [[Z3User shareInstance] setCompany:company ?:@""];
    [[Z3User shareInstance] setEcode:ecode ?:@""];
    [[Z3User shareInstance] setGroupId:groupId];
    [[Z3User shareInstance] setGroupLev:groupLev];
    [[Z3User shareInstance] setGroupName:groupName ?:@""];
    [[Z3User shareInstance] setGroupCode:groupCode ?:@""];
    [[Z3User shareInstance] setRole:role ?:@""];
    [[Z3User shareInstance] setRoleCode:roleCode ?:@""];
    [[Z3User shareInstance] setTrueName:trueName ?:@""];
    
}

- (void)internal_loadOfflineMapConfig {
    NSString *path = [[NSBundle mainBundle] pathForResource:@"TransParams.xml" ofType:nil];
    CoorTranUtil *coorTranUtil = [[CoorTranUtil alloc] initWithTransParamFilePath:path];
    [Z3MobileConfig shareConfig].coorTrans = coorTranUtil;
}

#pragma mark -request
- (void)requestLogin {
    [self.accountField resignFirstResponder];
    [self.pwdField resignFirstResponder];
    NSDictionary *parameters = @{@"username":self.accountField.text,@"password":self.pwdField.text};
    __weak typeof(self) weakSelf = self;
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    self.request = [[Z3LoginRequest alloc] initWithRelativeToURL:@"rest/userService/login" method:GET parameter:parameters success:^(__kindof Z3BaseResponse * _Nonnull response) {
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        if (response.error) {
            NSDictionary *userInfo = [response.error userInfo];
            NSString *msg = userInfo[@"msg"];
            if (!msg) {
                msg = NSLocalizedString(@"user_login_failure", @"登录失败");
            }
            [MBProgressHUD showError:msg];
        }else {
            [weakSelf requestMapXMLConfiguration];
            [kUserDefaults setObject:weakSelf.accountField.text forKey:Z3KEY_USER_NAME];
            [kUserDefaults setObject:weakSelf.pwdField.text forKey:Z3KEY_USER_PASSWORD];
        }
    } failure:^(__kindof Z3BaseResponse * _Nonnull response) {
        [MBProgressHUD showError:NSLocalizedString(@"user_login_failure", @"登录失败")];
        [MBProgressHUD hideHUDForView:self.view animated:YES];
    }];
    [self.request start];
}

- (void)requestApplicationUseToken {
    
}

- (PMKPromise *)login {
    [self.accountField resignFirstResponder];
    [self.pwdField resignFirstResponder];
    return [PMKPromise new:^(PMKFulfiller fulfill, PMKRejecter reject) {
         NSDictionary *parameters = @{@"username":self.accountField.text,@"password":self.pwdField.text};
        self.request = [[Z3LoginRequest alloc] initWithRelativeToURL:@"rest/userService/login" method:GET parameter:parameters success:^(__kindof Z3BaseResponse * _Nonnull response) {
//            [MBProgressHUD hideHUDForView:self.view animated:YES];
//            if (response.error) {
//                NSDictionary *userInfo = [response.error userInfo];
//                NSString *msg = userInfo[@"msg"];
//                if (!msg) {
//                    msg = NSLocalizedString(@"user_login_failure", @"登录失败");
//                }
//                [MBProgressHUD showError:msg];
//            }
        } failure:^(__kindof Z3BaseResponse * _Nonnull response) {
//            [MBProgressHUD showError:NSLocalizedString(@"user_login_failure", @"登录失败")];
//            [MBProgressHUD hideHUDForView:self.view animated:YES];
        }];
        [self.request start];
    }];
}

- (PMKPromise *)concurentGetMobileMapAndTransParams {
    return [PMKPromise when:@[[self getMobileMap],[self getTransParams]]];
}

- (PMKPromise *)getMobileMap {
    return [PMKPromise new:^(PMKFulfiller fulfill, PMKRejecter reject) {
        
    }];
}

- (PMKPromise *)getTransParams {
    return [PMKPromise new:^(PMKFulfiller fulfill, PMKRejecter reject) {
        
    }];
}
/**
 获取地图配置文件
 */
- (void)requestMapXMLConfiguration {
    NSDictionary *parameters = @{};
    __weak typeof(self) weakSelf = self;
    NSString *rootURL = [Z3NetworkConfig shareConfig].urlConfig.rootURLPath;
    NSString *mobileMapURL = [Z3MobileConfig shareConfig].mobileMapURL;
    NSString *absoluteURL = [NSString stringWithFormat:@"%@/%@",rootURL,mobileMapURL];
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    self.request = [[Z3MapConfigRequest alloc] initWithAbsoluteURL:absoluteURL method:GET parameter:parameters success:^(__kindof Z3BaseResponse * _Nonnull response) {
         [MBProgressHUD hideHUDForView:self.view animated:YES];
        if (response.error) {
            [MBProgressHUD showError:NSLocalizedString(@"get_configuration_failure", @"配置文件获取失败")];
        }else {
//            [weakSelf requestCoordinate2dTransformXMLConfiguration];
//在线坐标转换
            [weakSelf requstCoorTransToken];
        }
    } failure:^(__kindof Z3BaseResponse * _Nonnull response) {
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        [MBProgressHUD showError:NSLocalizedString(@"get_configuration_failure", @"配置文件获取失败")];
    }];
    [self.request start];
    
}

/**
 获取坐标转换参数
 */
- (void)requestCoordinate2dTransformXMLConfiguration {
    NSDictionary *parameters = @{};
    __weak typeof(self) weakSelf = self;
    NSString *transParamsURL = [Z3MobileConfig shareConfig].transParamsURL;
    NSString *rootURL = [Z3NetworkConfig shareConfig].urlConfig.rootURLPath;
    NSString *absoluteURL = [NSString stringWithFormat:@"%@/%@",rootURL,transParamsURL];
    self.request = [[Z3XmllRequest alloc] initWithAbsoluteURL:absoluteURL method:GET parameter:parameters success:^(__kindof Z3BaseResponse * _Nonnull response) {
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        if (response.error) {
            [MBProgressHUD showError:NSLocalizedString(@"get_configuration_failure", @"配置文件获取失败")];
        }else {
            if (weakSelf.success) {
                weakSelf.success(response.responseJSONObject);
                //保存登录信息
                [[NSUserDefaults standardUserDefaults] setValue:self.accountField.text forKey:Z3KEY_USER_NAME];
                [[NSUserDefaults standardUserDefaults] setValue:self.pwdField.text forKey:Z3KEY_USER_PASSWORD];
                [[NSUserDefaults standardUserDefaults] setBool:YES forKey:Z3KEY_USER_LOGIN_FLAG];
                [[NSUserDefaults standardUserDefaults] synchronize];
            }
        }
    } failure:^(__kindof Z3BaseResponse * _Nonnull response) {
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        [MBProgressHUD showError:NSLocalizedString(@"get_configuration_failure", @"配置文件获取失败")];
    }];
    [self.request start];
}

/**
 请求坐标转换的token
 */
- (void)requstCoorTransToken {
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    dict[@"converter"] = @"TEN";
    dict[@"ellipseType"] = @"HAYFORD";
    dict[@"srcEllipseType"] = @"WGS84";
    dict[@"middleLine"] = @(113.53646944);
    dict[@"rev"] = @(1);
    dict[@"xConstant"] = @(-2437351.373996556);
    dict[@"yConstant"] = @(20000);
    NSMutableDictionary *convertParameterTwo = [NSMutableDictionary dictionary];
    convertParameterTwo[@"valid"] = @(true);
    convertParameterTwo[@"yoff"] = @(0);
    convertParameterTwo[@"xoff"] = @(0);
    dict[@"convertParameterTwo"] = convertParameterTwo;
    NSMutableDictionary *convertParameterTen = [NSMutableDictionary dictionary];
    convertParameterTen[@"x0"] = @(-2361757.652);
    convertParameterTen[@"y0"] = @(5417232.187);
    convertParameterTen[@"z0"] = @(2391453.053);
    convertParameterTen[@"m"] = @(-0.000006096);
    convertParameterTen[@"valid"] = @(true);
    convertParameterTen[@"yoff"] = @(303.99);
    convertParameterTen[@"xoff"] = @(202.865);
    convertParameterTen[@"xangle"] = @(34.067);
    convertParameterTen[@"yangle"] = @(-76.126);
    convertParameterTen[@"zangle"] = @(-32.647);
    convertParameterTen[@"zoff"] = @(155.873);
    dict[@"convertParameterTen"] = convertParameterTen;
    NSString *url = @"http://z3pipe.com:2436/api/v1/coordinate/createConfig";
    __weak typeof(self) weakSelf = self;
    self.request = [[Z3PostCoorTransConfigRequest alloc] initWithAbsoluteURL:url method:POST parameter:[dict copy] success:^(__kindof Z3BaseResponse * _Nonnull response) {
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        NSInteger code = [response.responseJSONObject[@"code"] intValue];
        if (code == 200) {
            [Z3MobileConfig shareConfig].coorTransToken = response.responseJSONObject[@"data"];
            weakSelf.success(nil);
        }else {
            [MBProgressHUD showError:NSLocalizedString(@"get_configuration_failure", @"配置文件获取失败")];
        }
    } failure:^(__kindof Z3BaseResponse * _Nonnull response) {
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        [MBProgressHUD showError:NSLocalizedString(@"get_configuration_failure", @"配置文件获取失败")];
    }];
    
    [self.request start];
    
}

#pragma mark - action
- (IBAction)loginBtnClicked:(id)sender {
    if (![self internal_check]) return;
    if ([AFNetworkReachabilityManager sharedManager].isReachable) {
        [self requestLogin];
    }else {
         [self internal_offlineLogin];
    }
   
}
- (IBAction)savePwdBtnClicked:(id)sender {
    [self updateUserDefault:self.rememberPwdBtn withKey:Z3KEY_AUTO_FILL_PWD];
    
}
- (IBAction)autoLoginBtnClicked:(id)sender {
//     [self updateUserDefault:self.autoLoginBtn withKey:KEY_AUTO_LOGIN];
    
}
- (IBAction)loginSettingBtnClicked:(id)sender {
}

/**
 *  版本标签被点击
 *
 *  @param recognizer a UITapGestureRecognizer
 */
-(void)appVersionLabelTouchUpInside:(UITapGestureRecognizer *)recognizer{
    NSDate * now = [NSDate date];
    NSTimeInterval timeBetween = [now timeIntervalSinceDate:_startClickTime];
    if(timeBetween>=TIMEINTERVAL_LIMIT){
        _clickedTimes = 1;
        _startClickTime = [NSDate date];
    }else{
        _clickedTimes+=1;
        if(_clickedTimes>=CLICKTIMES_LIMIT){
            Z3HUDLoginSettingViewController *settingVC = [[Z3HUDLoginSettingViewController alloc] init];
            [self presentViewController:settingVC animated:YES completion:nil];
            _clickedTimes = 0;
        }
    }
}
- (void)updateUserDefault:(UIButton *)sender withKey:(NSString *)key {
    sender.selected = !sender.isSelected;
    if (sender.selected) {
        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:key];
    }else {
        [[NSUserDefaults standardUserDefaults] setBool:NO forKey:key];
    }
    [[NSUserDefaults standardUserDefaults] synchronize];
    
}


@end
