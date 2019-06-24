//
//  Z3MobileConfig.h
//  Z3Newwork_Example
//
//  Created by 童万华 on 2019/6/5.
//  Copyright © 2019 Tony Tony. All rights reserved.
/*
 *configs from mobileConfig.xml
 */

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN
@class Z3MapConfig,Z3MobileTask,Z3AppMenu;
@interface Z3MobileConfig : NSObject
+ (instancetype)shareConfig;
- (instancetype)init NS_UNAVAILABLE;
+ (instancetype)new NS_UNAVAILABLE;

@property (nonatomic,strong,readonly) Z3MapConfig *mapConfig;
@property (nonatomic,strong,readonly) NSArray *tasks;
@property (nonatomic,strong,readonly) NSArray<Z3AppMenu *> *menus;
@property (nonatomic,strong,readonly) NSString *mobileMapURL;
@property (nonatomic,strong,readonly) NSString *transParamsURL;
@property (nonatomic,strong) NSArray *gisMetas;
@end

NS_ASSUME_NONNULL_END
