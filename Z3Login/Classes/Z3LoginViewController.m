    //
    //  LoginViewController.m
    //  OutWork
    //
    //  Created by ZZHT on 2018/5/23.
    //  Copyright © 2018年 ZZHT. All rights reserved.
    //

#import "Z3LoginViewController.h"
#import "Z3LoginSettingViewController.h"
#import "Z3LoginRequest.h"
#import "Z3MapConfigRequest.h"
#import "UIKit+AFNetworking.h"
#import "AFNetworkReachabilityManager.h"
#import "MBProgressHUD+Z3.h"
#import "Z3User.h"
#import "Z3Network.h"
#import "Z3MobileConfig.h"
#define TIMEINTERVAL_LIMIT 60      //时间限制 60秒
#define CLICKTIMES_LIMIT 5         //点击次数限制 至少5次
@interface Z3LoginViewController () {
    int _clickedTimes;
    NSDate * _startClickTime;
}
@property (weak, nonatomic) IBOutlet UITextField *accountField;
@property (weak, nonatomic) IBOutlet UITextField *pwdField;
@property (weak, nonatomic) IBOutlet UILabel *versionLabel;
@property (weak, nonatomic) IBOutlet UIButton *rememberPwdBtn;
@property (weak, nonatomic) IBOutlet UIButton *autoLoginBtn;
@property (weak, nonatomic) IBOutlet UIButton *loginSettingButton;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *topConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *bottomConstraint;
@property (nonatomic,strong) Z3BaseRequest *request;
@property (nonatomic,strong) UIActivityIndicatorView *indicatorView;
@property (nonatomic,copy) LoginSuccessBlock success;
@end

@implementation Z3LoginViewController

#pragma mark - life circle
- (instancetype)initWithLoginSuccessBlock:(LoginSuccessBlock)success {
     NSBundle *bundle = [NSBundle bundleForClass:[self class]];
     NSString *path = [bundle pathForResource:@"Z3Login" ofType:@"bundle"];
     bundle = [NSBundle bundleWithPath:path];
    self = [super initWithNibName:NSStringFromClass([Z3LoginViewController class]) bundle:bundle];
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

#pragma mark - view life circle
- (void)viewDidLoad {
    [super viewDidLoad];
        // Do any additional setup after loading the view from its nib.
    [self initSubView];
    //是否自动填充密码
    [self autoFillPwd];
        //是否自动登录
    [self autoLogin];
    
}
#pragma mark - public method

#pragma mark - private metod
- (void)initSubView {
        //添加间隔线
    CALayer *seperatorLine = [CALayer new];
    seperatorLine.backgroundColor = [UIColor lightGrayColor].CGColor;
    CGFloat y = CGRectGetMaxY(self.accountField.frame);
    CGFloat width = [UIScreen mainScreen].bounds.size.width;
    CGFloat onePixel = 1.0f/[UIScreen mainScreen].scale;
    seperatorLine.frame = CGRectMake(0, y, width, onePixel);
    [[self.accountField superview].layer addSublayer:seperatorLine];
    self.versionLabel.text = [NSString stringWithFormat:@"v%@",@"1.0.0"];
    self.versionLabel.userInteractionEnabled = YES;
    UITapGestureRecognizer *labelTapGestureRecognizer = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(appVersionLabelTouchUpInside:)];
    [self.versionLabel addGestureRecognizer:labelTapGestureRecognizer];
    if (@available(iOS 11.0, *)) {
        
    } else {
        self.topConstraint.constant += 44;
    }
    
}
/**
 *  初始化版本信息控件及事件
 */
-(void)initAppVersionLabel{
    self.versionLabel.userInteractionEnabled = YES;
}
- (void)autoLogin {
    BOOL isAutoLogin = false;
    [[NSUserDefaults standardUserDefaults] boolForKey:KEY_AUTO_LOGIN];
    if (isAutoLogin && [self check]) {
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self login];
        });
    }
    self.autoLoginBtn.selected = isAutoLogin;
    
}
- (void)autoFillPwd {
    BOOL isAutoFillPWD = [[NSUserDefaults standardUserDefaults] boolForKey:KEY_AUTO_FILL_PWD];
    if (isAutoFillPWD ) {
        NSString *pwd = [[NSUserDefaults standardUserDefaults] valueForKey:KEY_USER_PASSWORD];
        NSString *account = [[NSUserDefaults standardUserDefaults] valueForKey:KEY_USER_NAME];
        self.accountField.text = account;
        self.pwdField.text = pwd;
    }
    self.rememberPwdBtn.selected = isAutoFillPWD;
    
}
- (BOOL)check {
    if (self.accountField.text.length == 0) {
        [MBProgressHUD showError:NSLocalizedString(@"user_account_is_empty", @"用户名不能为空")];
        return false;
    }
    
    if (self.pwdField.text.length == 0) {
        [MBProgressHUD showError:NSLocalizedString(@"user_pwd_is_empty", @"用户密码不能为空")];
        return false;
    }
    
    return true;
    
}
- (void)login {
    [self.accountField resignFirstResponder];
    [self.pwdField resignFirstResponder];
    NSDictionary *parameters = @{@"username":self.accountField.text,@"password":self.pwdField.text};
    __weak typeof(self) weakSelf = self;
    self.request = [[Z3LoginRequest alloc] initWithRelativeToURL:@"rest/userService/login" method:GET parameter:parameters success:^(__kindof Z3BaseResponse * _Nonnull response) {
        if (response.error) {
              [MBProgressHUD showError:NSLocalizedString(@"user_login_failure", @"登录失败")];
        }else {
            [[NSUserDefaults standardUserDefaults] setValue:self.pwdField.text forKey:KEY_USER_PASSWORD];
            [[NSUserDefaults standardUserDefaults] setValue:self.accountField.text forKey:KEY_USER_NAME];
            [[NSUserDefaults standardUserDefaults] synchronize];
            [weakSelf requestMapXMLConfiguration];
        }
    } failure:^(__kindof Z3BaseResponse * _Nonnull response) {
        
         [MBProgressHUD showError:NSLocalizedString(@"user_login_failure", @"登录失败")];
    }];
    [self.request start];
    [self.indicatorView setAnimatingWithStateOfTask:self.request.requestTask];
    
}


/**
 获取地图配置文件
 */
- (void)                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                            requestMapXMLConfiguration {
    NSDictionary *parameters = @{};
    __weak typeof(self) weakSelf = self;
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    NSString *absoluteURL = [Z3MobileConfig shareConfig].mobileMapURL;
    self.request = [[Z3MapConfigRequest alloc] initWithAbsoluteURL:absoluteURL method:GET parameter:parameters success:^(__kindof Z3BaseResponse * _Nonnull response) {
        if (response.error) {
             [MBProgressHUD hideHUDForView:self.view animated:YES];
            [MBProgressHUD showError:NSLocalizedString(@"get_configuration_failure", @"配置文件获取失败")];
        }else {
            [weakSelf requestCoordinate2dTransformXMLConfiguration];
        }
    } failure:^(__kindof Z3BaseResponse * _Nonnull response) {
         [MBProgressHUD hideHUDForView:self.view animated:YES];
        [MBProgressHUD showError:NSLocalizedString(@"get_configuration_failure", @"配置文件获取失败")];
    }];
    [self.request start];
    [self.indicatorView setAnimatingWithStateOfTask:self.request.requestTask];
}

/**
 获取坐标转换参数
 */
- (void)requestCoordinate2dTransformXMLConfiguration {
    NSDictionary *parameters = @{};
    __weak typeof(self) weakSelf = self;
    NSString *absoluteURL = [Z3MobileConfig shareConfig].transParamsURL;
    self.request = [[Z3XmllRequest alloc] initWithAbsoluteURL:absoluteURL method:GET parameter:parameters success:^(__kindof Z3BaseResponse * _Nonnull response) {
         [MBProgressHUD hideHUDForView:self.view animated:YES];
        if (response.error) {
           [MBProgressHUD showError:NSLocalizedString(@"get_configuration_failure", @"配置文件获取失败")];
        }else {
            if (weakSelf.success) {
                weakSelf.success(response.responseJSONObject);
            }
        }
    } failure:^(__kindof Z3BaseResponse * _Nonnull response) {
         [MBProgressHUD hideHUDForView:self.view animated:YES];
        [MBProgressHUD showError:NSLocalizedString(@"get_configuration_failure", @"配置文件获取失败")];
    }];
    [self.request start];
    [self.indicatorView setAnimatingWithStateOfTask:self.request.requestTask];
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

#pragma mark -request

#pragma mark - action
- (IBAction)loginBtnClicked:(id)sender {
    if (![self check]) return;
    [self login];
    
}
- (IBAction)savePwdBtnClicked:(id)sender {
    [self updateUserDefault:self.rememberPwdBtn withKey:KEY_AUTO_FILL_PWD];
    
}
- (IBAction)autoLoginBtnClicked:(id)sender {
    [self updateUserDefault:self.autoLoginBtn withKey:KEY_AUTO_LOGIN];
    
}
- (IBAction)loginSettingBtnClicked:(id)sender {
    UIViewController *vc = [[Z3LoginSettingViewController alloc]init];
    [self presentViewController:vc animated:YES completion:nil];
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
            self.loginSettingButton.hidden = NO;
        }
    }
}


#pragma mark - getter and setter
- (UIActivityIndicatorView *)indicatorView {
    if (!_indicatorView) {
        _indicatorView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
        [self.view addSubview:_indicatorView];
        _indicatorView.center = self.view.center;
    }
    return _indicatorView;
}

@end
