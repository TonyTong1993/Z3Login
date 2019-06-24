//
//  LoginViewController.h
//  OutWork
//
//  Created by ZZHT on 2018/5/23.
//  Copyright © 2018年 ZZHT. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef void (^LoginSuccessBlock)(id result);
@interface Z3LoginViewController : UIViewController
- (instancetype)initWithLoginSuccessBlock:(LoginSuccessBlock)success;
+ (instancetype)new NS_UNAVAILABLE;
- (instancetype)init NS_UNAVAILABLE;
@end
