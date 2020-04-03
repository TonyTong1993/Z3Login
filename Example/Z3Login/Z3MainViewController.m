//
//  Z3MainViewController.m
//  Z3Login_Example
//
//  Created by 童万华 on 2019/7/26.
//  Copyright © 2019 Tony Tony. All rights reserved.
//

#import "Z3MainViewController.h"
#import <PromiseKit.h>
#import <MBProgressHUD+Z3.h>
#import "Z3BaseRequest.h"
#import "Z3BaseResponse.h"
@interface Z3MainViewController ()
@property (weak, nonatomic) IBOutlet UIView *targetView;

@end

@implementation Z3MainViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    PMKPromise *promise = [PMKPromise promiseWithResolver:^(PMKResolver resolve) {
        [self resolver:resolve];
    }];
    
    promise.then(^(NSString *message){
        NSLog(@"resolver: %@",message);
    }).finally(^{
         NSLog(@"finally");
    });
    
}

- (void)resolver:(PMKResolver)resolve {
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        resolve(@"把问题解决了");
    });
}


- (IBAction)test:(id)sender {
    //上传用户信息
    NSDictionary *parameters = @{@"username":@"admin",@"password":@"123456",@"sys":@"android"};
    [self postUserInfo:parameters].then(^(NSDictionary *response){
        NSLog(@"%@",response);
        //获取配置信息
       return [self getConfigurations];
    }).then(^(NSDictionary *configuration) {
         NSLog(@"%@",configuration);
    }).catch(^(NSError *error){
        NSLog(@"error = %@",[error localizedDescription]);
    }).finally(^{
       NSLog(@"完成操作");
    });

}

- (PMKPromise *)postUserInfo:(NSDictionary *)userInfo {
    return [PMKPromise new:^(PMKFulfiller fulfill, PMKRejecter reject) {
        NSString *url = @"http://222.92.12.42:8888/ServiceEngine/rest/userService/login";
       Z3BaseRequest *request = [[Z3BaseRequest alloc] initWithAbsoluteURL:url method:GET parameter:userInfo success:^(__kindof Z3BaseResponse * _Nonnull response) {
           NSInteger code = [response.responseJSONObject[@"code"] integerValue];
           BOOL success = [response.responseJSONObject[@"Success"] boolValue];
           if (success) {
//               NSDictionary *data = response.responseJSONObject[@"data"];
               NSDictionary *data = response.responseJSONObject;
               fulfill(data);
           }else {
               NSString *message = @"用户密码不正确";//response.responseJSONObject[@"message"];
               NSError *error = [NSError errorWithDomain:@"zzht.com.error" code:400 userInfo:@{NSLocalizedDescriptionKey:message}];
               reject(error);
           }
           [MBProgressHUD hideHUDForView:self.view animated:YES];
        } failure:^(__kindof Z3BaseResponse * _Nonnull response) {
            NSError *error = response.error;
            reject(error);
            [MBProgressHUD hideHUDForView:self.view animated:YES];
        }];
        [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        [request start];
    }];
    
}

- (PMKPromise *)getConfigurations {
    return [PMKPromise promiseWithAdapter:^(PMKAdapter adapter) {
        [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            NSDictionary *response = @{
                                       @"code":@(200),
                                       @"message":@"",
                                       @"data":@{
                                               @"map":@{@"url":@"http://www.baidu.com"}
                                               },
                                       };
            [MBProgressHUD hideHUDForView:self.view animated:YES];
            adapter(response,nil);
        });
        
    }];
}



@end
