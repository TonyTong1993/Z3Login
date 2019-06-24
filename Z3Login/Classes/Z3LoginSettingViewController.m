//
//  ZZLoginSettingViewController.m
//  OutWork
//
//  Created by ZZHT on 2018/10/11.
//  Copyright © 2018年 ZZHT. All rights reserved.
//

#import "Z3LoginSettingViewController.h"
#import <Z3Network/Z3NetworkConfig.h>
#import <Z3Network/Z3URLConfig.h>
#import <Z3Network/Z3BaseResponse.h>
#import "Z3LoginRequest.h"
#import "UIKit+AFNetworking.h"
#import "MBProgressHUD.h"
@interface Z3LoginSettingViewController ()
@property (weak, nonatomic) IBOutlet UISegmentedControl *settingModeSegment;
@property (weak, nonatomic) IBOutlet UIView *portBgView;
@property (weak, nonatomic) IBOutlet UISegmentedControl *protModeSegment;
@property (weak, nonatomic) IBOutlet UITextField *ipTF;
@property (weak, nonatomic) IBOutlet UITextField *protTF;
@property (weak, nonatomic) IBOutlet UITextField *virtualTF;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *portBgViewHeightConstraint;
@property (nonatomic,strong) Z3LoginRequest *request;
@property (nonatomic,strong) UIActivityIndicatorView *indicatorView;
@end

@implementation Z3LoginSettingViewController

#pragma mark - life circle
- (instancetype)init {
    NSBundle *bundle = [NSBundle bundleForClass:[self class]];
    NSString *path = [bundle pathForResource:@"Z3Login" ofType:@"bundle"];
    bundle = [NSBundle bundleWithPath:path];
    self = [super initWithNibName:NSStringFromClass([Z3LoginSettingViewController class]) bundle:bundle];
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
    return @"设置";
}
#pragma mark - private metod
- (void)initView {
    self.view.backgroundColor = [UIColor whiteColor];
    UIBarButtonItem *btnDone = [[UIBarButtonItem alloc]
                                initWithTitle:@"完成"
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

- (void)onCompletionButtonClicked:(id)sender {
    [self saveLoginSettings];
    [self.navigationController popViewControllerAnimated:YES];
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
    self.request = [[Z3LoginRequest alloc] initWithAbsoluteURL:url method:GET parameter:nil success:^(__kindof Z3BaseResponse * _Nonnull response) {
        [self showToast:@"连接成功"];
    } failure:^(__kindof Z3BaseResponse * _Nonnull response) {
        [self showToast:@"连接失败"];
        NSLog(@"error = %@",[response.error localizedDescription]);
    }];
    [self.request start];
    [self.indicatorView setAnimatingWithStateOfTask:self.request.requestTask];
    
}
- (BOOL)validateTextFields {
    BOOL valid = self.ipTF.text.length != 0 && self.protTF.text.length != 0;
    return valid;
}
- (void)saveLoginSettings {
    Z3URLConfig *config = [Z3URLConfig configration];
    [config setHost:_ipTF.text];
    [config setPort:_protTF.text];
    [config setVirtualPath:_virtualTF.text];
    [[Z3NetworkConfig shareConfig] setUrlConfig:config];
}

- (void)showToast:(NSString *)msg {
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.mode = MBProgressHUDModeText;
    hud.label.text = msg;//
    [hud hideAnimated:YES afterDelay:2.0];
}

- (IBAction)onBack:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)onSave:(id)sender {
    [self saveLoginSettings];
}

#pragma mark - delegate

#pragma mark - getter and setter method
- (UIActivityIndicatorView *)indicatorView {
    if (!_indicatorView) {
        _indicatorView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
        [self.view addSubview:_indicatorView];
        _indicatorView.center = self.view.center;
    }
    return _indicatorView;
}



@end
