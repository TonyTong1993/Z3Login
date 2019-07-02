//
//  Z3HUDLoginViewController.h
//  Z3Login_Example
//
//  Created by ZZHT on 2019/7/1.
//  Copyright © 2019年 Tony Tony. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
typedef void (^LoginSuccessBlock)(id result);
@interface Z3HUDLoginViewController : UIViewController
- (instancetype)initWithLoginSuccessBlock:(LoginSuccessBlock)success;
+ (instancetype)new NS_UNAVAILABLE;
- (instancetype)init NS_UNAVAILABLE;
@end

NS_ASSUME_NONNULL_END

