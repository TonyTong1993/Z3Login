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
#import "UIKit+AFNetworking.h"
#import "AFNetworkReachabilityManager.h"
#import "MBProgressHUD+Z3.h"
#import "Z3User.h"
#import "Z3Network.h"
#import "Z3MobileConfig.h"
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
@property (weak, nonatomic) IBOutlet UILabel *copyrightTipLabel;
@property (weak, nonatomic) IBOutlet UILabel *copyrightLabel;
@property (weak, nonatomic) IBOutlet UIButton *remenberPwdLabel;
@property (weak, nonatomic) IBOutlet UIButton *loginSettingButton;
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
    [self internal_initSubView];
    //开发阶段默认填充
#if DEBUG
    self.accountField.text = @"admin";
    self.pwdField.text = @"123456";
#endif
    //是否自动填充密码
    [self internal_autoFillPwd];
    //是否自动登录
    //    [self autoLogin];
    
}
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = YES;
}

#pragma mark - public method

#pragma mark - private metod
- (void)internal_initSubView {
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
    
}
- (void)internal_autoFillPwd {
    BOOL isAutoFillPWD = [[NSUserDefaults standardUserDefaults] boolForKey:KEY_AUTO_FILL_PWD];
    if (isAutoFillPWD ) {
        NSString *pwd = [[NSUserDefaults standardUserDefaults] valueForKey:KEY_USER_PASSWORD];
        NSString *account = [[NSUserDefaults standardUserDefaults] valueForKey:KEY_USER_NAME];
        self.accountField.text = account;
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
- (void)internal_offlineLogin {
    MBProgressHUD *hud  = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.mode = MBProgressHUDModeText;
    hud.label.text = NSLocalizedString(@"login_getting_init_paramters",@"正在初始化参数");
//    [self internal_loadOfflineUserInfo];
//    [self internal_loadOfflineMapConfig];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        [self internal_enterMainScreen:nil];
    });
}
/**
 处理动态appMenus
 */
- (NSArray *)internal_appMenusParser {
//    NSString *path = [[NSBundle mainBundle] pathForResource:@"production.xml" ofType:nil];
//    //    NSDictionary *dictionary = [[XMLDictionaryParser sharedInstance] dictionaryWithFile:path];
//    NSData *data = [[NSData alloc] initWithContentsOfFile:path];
//    NSDictionary *dictionary = [NSDictionary dictionaryWithXML:data];
//    id category = [dictionary valueForKey:@"Category"];
//    NSMutableArray *menus = [NSMutableArray array];
//    AppMenu *menu = [[AppMenu alloc] initWithIcon:@"defaultphoto" highlightIcon:@"defaultphoto" name:[User sharedUser].trueName];
//    [menu setCommandXtd:NSStringFromClass([ProfileCommandXtd class])];
//    [menus addObject:menu];
//    [category enumerateObjectsUsingBlock:^(NSDictionary *obj, NSUInteger idx, BOOL * _Nonnull stop) {
//        id children = [obj valueForKey:@"Menu"];
//        NSMutableArray *mchildren = [NSMutableArray array];
//        if ([children isKindOfClass:[NSDictionary class]]) {
//            AppMenu *menu = [AppMenu modelWithDictionary:children];
//            [mchildren addObject:menu];
//        }else if ([children isKindOfClass:[NSArray class]]) {
//            [children enumerateObjectsUsingBlock:^(NSDictionary *child, NSUInteger idx, BOOL * _Nonnull stop) {
//                AppMenu *menu = [AppMenu modelWithDictionary:child];
//                [mchildren addObject:menu];
//            }];
//        }
//        NSString *name = [obj valueForKey:@"name"];
//        NSString *icon = [obj valueForKey:@"iconName"];
//        NSString *highlightIcon = [obj valueForKey:@"hlIconName"];
//        BOOL configurable = [obj valueForKey:@"configurable"];
//        AppMenu *menu = [[AppMenu alloc] initWithIcon:icon highlightIcon:highlightIcon name:name configurable:configurable children:mchildren];
//        [menu setCommandXtd:NSStringFromClass([MapQueryCommandXtd class])];
//        [menus addObject:menu];
//    }];
//    //   menu = [[AppMenu alloc] initWithIcon:@"nav_setting_nor" highlightIcon:@"nav_setting_hl" name:LocalizedString(@"str_set_menu")];
//    //    [menu setCommandXtd:NSStringFromClass([SettingCommandXtd class])];
//    //    [menus addObject:menu];
//    return [menus copy];
    return nil;
}

- (void)internal_loadOfflineUserInfo {
    NSString *path = [[NSBundle mainBundle] pathForResource:@"admin.json" ofType:nil];
    NSError *error = nil;
    NSData *jsonData = [[NSData alloc] initWithContentsOfFile:path];
    id result = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingMutableLeaves error:&error];
    if (error != nil) {
        
        return;
    }
//    [self internal_adapt2UserModel:result];
//    [self internal_appMenusParser];
}




- (void)internal_enterMainScreen:(NSArray *)appMenus {
//    UIWindow *window = [[UIApplication sharedApplication].delegate window];
//    UISplitViewController *splitViewController = [[UISplitViewController alloc] init];
//
//    MasterViewController *masterViewController = [[MasterViewController alloc] init];
//    masterViewController.dataSource = [self internal_appMenusParser];
//    //创建左侧导航控制器
//    UINavigationController *MasterNavigationController = [[UINavigationController alloc]initWithRootViewController:masterViewController];
//    MasterNavigationController.navigationBarHidden = YES;
//    ZZOperationMapViewController *detailViewController = [[ZZOperationMapViewController alloc] initWithFunctionOptions:MapFunctionOptionDefault];
//    //    UINavigationController *detailNavigationController = [[UINavigationController alloc]initWithRootViewController:detailViewController];
//    //    detailNavigationController.navigationBarHidden = YES;
//    splitViewController.viewControllers = @[MasterNavigationController,detailViewController];
//    splitViewController.preferredDisplayMode = UISplitViewControllerDisplayModePrimaryHidden;
//    splitViewController.preferredPrimaryColumnWidthFraction = 0.1;
//    splitViewController.maximumPrimaryColumnWidth = 120;
//    splitViewController.minimumPrimaryColumnWidth = 100;
//    splitViewController.presentsWithGesture = YES;
//
//    AppDelegate *appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
//    appDelegate.splitViewController = splitViewController;
//    splitViewController.delegate = appDelegate;
//
//    NSArray *sources = [MobileConfig sharedMobileConfig].mapConfig.sources;
//    NSMutableArray *layers = [NSMutableArray array];
    //    for (MapLayerDatasource *source in sources) {
    //        NSURL *url = [NSURL URLWithString:source.url];
    //        AGSLayer* tiledLayer = nil;
    //        if (source.layerType == EcityTiledMapServiceLayer) {
    //           tiledLayer = [[AGSArcGISTiledLayer alloc] initWithURL:url];
    //        }else if (source.layerType == ArcGISDynamicMapServiceLayer) {
    //           tiledLayer = [[AGSArcGISMapImageLayer alloc] initWithURL:url];
    //
    //        }
    //        if (tiledLayer != nil) {
    //            tiledLayer.visible = source.visible;
    //            [layers addObject:tiledLayer];
    //        }
    //    }
    //    NSString *documentsPath = [UIApplication sharedApplication].documentsPath;
    //    NSString *tpkFilePath = [documentsPath stringByAppendingPathComponent:@"mwdt.tpk"];
    //    NSLog(@"tpkFilePath = %@",tpkFilePath);
//    NSString *tpkFilePath = @"http://192.168.8.231:6080/arcgis/rest/services/MWGS/mwdt_wp/MapServer";
//    AGSArcGISTiledLayer *baseMapLayer = [[AGSArcGISTiledLayer alloc] initWithURL:[NSURL URLWithString:tpkFilePath]];
//    detailViewController.layers = layers;
//    detailViewController.baseMapLayer = baseMapLayer;
    //    MapEnvelope *mapEnvelope = [MobileConfig sharedMobileConfig].mapConfig.envelope;
    //    NSInteger wkid = [MobileConfig sharedMobileConfig].appConfig.wkid;
    //    if(mapEnvelope) {
    //        AGSSpatialReference *spatialReference = [[AGSSpatialReference alloc] initWithWKID:wkid];
    //        AGSEnvelope* env = [[AGSEnvelope alloc]initWithXMin:mapEnvelope.xmin yMin:mapEnvelope.ymin xMax:mapEnvelope.xmax yMax:mapEnvelope.ymax spatialReference:spatialReference];
    //        detailViewController.initialEnvelop = env;
    //    }
    
//    CATransition *transition = [[CATransition alloc] init];
//    transition.duration = 0.25;
//    transition.type = kCATransitionPush;
//    transition.subtype = kCATransitionFromRight;
//    [window.layer addAnimation:transition forKey:@"transition"];
//    window.rootViewController = splitViewController;
}
#pragma mark -request
- (void)requestLogin {
    NSDictionary *parameters = @{@"username":self.accountField.text,@"password":self.pwdField.text};
    __weak typeof(self) weakSelf = self;
    self.request = [[Z3LoginRequest alloc] initWithRelativeToURL:@"rest/userService/login" method:GET parameter:parameters success:^(__kindof Z3BaseResponse * _Nonnull response) {
        if (response.error) {
            [MBProgressHUD showError:NSLocalizedString(@"user_login_failure", @"登录失败")];
        }else {
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
- (void)requestMapXMLConfiguration {
    NSDictionary *parameters = @{};
    __weak typeof(self) weakSelf = self;
    NSString *absoluteURL = [Z3MobileConfig shareConfig].mobileMapURL;
    self.request = [[Z3MapConfigRequest alloc] initWithAbsoluteURL:absoluteURL method:GET parameter:parameters success:^(__kindof Z3BaseResponse * _Nonnull response) {
        if (response.error) {
            [MBProgressHUD showError:NSLocalizedString(@"get_configuration_failure", @"配置文件获取失败")];
        }else {
            [weakSelf requestCoordinate2dTransformXMLConfiguration];
        }
    } failure:^(__kindof Z3BaseResponse * _Nonnull response) {
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
        if (response.error) {
            [MBProgressHUD showError:NSLocalizedString(@"get_configuration_failure", @"配置文件获取失败")];
        }else {
            if (weakSelf.success) {
                weakSelf.success(response.responseJSONObject);
            }
        }
    } failure:^(__kindof Z3BaseResponse * _Nonnull response) {
        [MBProgressHUD showError:NSLocalizedString(@"get_configuration_failure", @"配置文件获取失败")];
    }];
    [self.request start];
    [self.indicatorView setAnimatingWithStateOfTask:self.request.requestTask];
}

#pragma mark - action
- (IBAction)loginBtnClicked:(id)sender {
    if (![self internal_check]) return;
//    if ([AFNetworkReachabilityManager sharedManager].isReachable) {
         [self requestLogin];
//    }else {
//         [self internal_offlineLogin];
//    }
   
    
}
- (IBAction)savePwdBtnClicked:(id)sender {
    [self updateUserDefault:self.rememberPwdBtn withKey:KEY_AUTO_FILL_PWD];
    
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
