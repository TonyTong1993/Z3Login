//
//  Z3HUDLoginSettingViewController.m
//  Z3Login_Example
//
//  Created by ZZHT on 2019/7/2.
//  Copyright © 2019年 Tony Tony. All rights reserved.
//

#import "Z3HUDLoginSettingViewController.h"
#import "UIKit+AFNetworking.h"
#import "MBProgressHUD+Z3.h"
#import "Z3Network.h"
#import "Z3MobileConfig.h"
@interface Z3HUDLoginSettingViewController (){
    NSString *_ip;
    NSString *_port;
    NSString *_virtualPath;
}
@property (weak, nonatomic) IBOutlet UISegmentedControl *settingModeSegment;
@property (weak, nonatomic) IBOutlet UIView *portBgView;
@property (weak, nonatomic) IBOutlet UISegmentedControl *protModeSegment;
@property (weak, nonatomic) IBOutlet UITextField *ipTF;
@property (weak, nonatomic) IBOutlet UITextField *protTF;
@property (weak, nonatomic) IBOutlet UITextField *virtualTF;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *portBgViewHeightConstraint;
@property (nonatomic,strong) Z3BaseRequest *request;
@property (nonatomic,strong) UIActivityIndicatorView *indicatorView;

@end

@implementation Z3HUDLoginSettingViewController

#pragma mark - life circle
- (instancetype)init {
    NSBundle *bundle = [NSBundle bundleForClass:[self class]];
    NSString *path = [bundle pathForResource:@"Z3Login" ofType:@"bundle"];
    bundle = [NSBundle bundleWithPath:path];
    self = [super initWithNibName:NSStringFromClass([Z3HUDLoginSettingViewController class]) bundle:bundle];
    if (self == nil) {
        self = [super init];
    }
    if (self) {
        
    }
    return self;
}
#pragma mark - view life circle

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self initView];
    [self initDefaultData];

    
}

- (void)dealloc {
    if ([self.request isExecuting]) {
        [self.request stop];
    }
}

- (void)updateViewConstraints {
    if (0 == self.settingModeSegment.selectedSegmentIndex) {
        self.portBgViewHeightConstraint.constant = 48.0f;
    }else if (1 == self.settingModeSegment.selectedSegmentIndex) {
        self.portBgViewHeightConstraint.constant = 0.0f;
    }else {
        
    }
    [super updateViewConstraints];
}
#pragma mark - public method
- (NSString *)screenTitle {
    return NSLocalizedString(@"str_set_menu","设置");
}
#pragma mark - private metod
- (void)initView {
    self.view.backgroundColor = [UIColor whiteColor];
    UIBarButtonItem *btnDone = [[UIBarButtonItem alloc]
                                initWithTitle:NSLocalizedString(@"sel_ok",@"Done")
                                style:UIBarButtonItemStylePlain
                                target:self
                                action:@selector(onCompletionButtonClicked:)];
    [self.navigationItem setRightBarButtonItem:btnDone];
}
- (void)initDefaultData {
    Z3URLConfig *config = [Z3URLConfig configration];
    self.ipTF.text = config.host;
    self.protTF.text = config.port;
    self.virtualTF.text = config.virtualPath;
}

- (IBAction)onSettingModeDidChange:(UISegmentedControl *)sender {
    if (0 == self.settingModeSegment.selectedSegmentIndex) {
        [self.portBgView setHidden:NO];
    }else if (1 == self.settingModeSegment.selectedSegmentIndex) {
        [self.portBgView setHidden:YES];
    }else {
        [self.portBgView setHidden:YES];
    }
    [self.view setNeedsUpdateConstraints];
    
    
}
- (IBAction)onPortModeDidChange:(UISegmentedControl *)sender {
    switch (sender.selectedSegmentIndex) {
        case 0:
            
            break;
        case 1:
            
            break;
        default:
            break;
    }
}

- (IBAction)onCompletionButtonClicked:(id)sender {
    [self saveLoginSettings];
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)onBackButton:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)testOnConnect:(id)sender {
    if (![self validateTextFields]) return;
    NSString *ip = self.ipTF.text;
    NSString *port = self.protTF.text;
    NSString *virtualPath = self.virtualTF.text;
    NSMutableString *testURL = @"".mutableCopy;
    [testURL appendString:@"http://"];
    [testURL appendString:ip];
    [testURL appendString:@":"];
    [testURL appendString:port];
    if (virtualPath.length) {
        [testURL appendString:@"/"];
        [testURL appendString:virtualPath];
    }
    [testURL appendString:@"/rest/userService/login"];
    NSString *url = [testURL copy];
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    self.request = [[Z3BaseRequest alloc] initWithAbsoluteURL:url method:GET parameter:@{} success:^(__kindof Z3BaseResponse * _Nonnull response) {
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        [self showToast:NSLocalizedString(@"setting_test_connection_success", @"连接成功")];
        
    } failure:^(__kindof Z3BaseResponse * _Nonnull response) {
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        [self showToast:NSLocalizedString(@"setting_test_connection_failed", @"连接失败")];
        NSLog(@"error = %@",[response.error localizedDescription]);
    }];
    [self.request start];
   
    
}
- (BOOL)validateTextFields {
    BOOL valid = self.ipTF.text.length != 0 && self.protTF.text.length != 0;
    return valid;
}

- (void)showToast:(NSString *)msg {
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.mode = MBProgressHUDModeText;
    hud.label.text = msg;
    [hud hideAnimated:YES afterDelay:2.0];
}

- (void)saveLoginSettings {
    Z3URLConfig *config = [Z3URLConfig configration];
    [config setHost:_ipTF.text];
    [config setPort:_protTF.text];
    [config setVirtualPath:_virtualTF.text];
    [[Z3NetworkConfig shareConfig] setUrlConfig:config];
}

@end
