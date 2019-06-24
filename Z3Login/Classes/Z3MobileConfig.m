//
//  Z3MobileConfig.m
//  Z3Newwork_Example
//
//  Created by 童万华 on 2019/6/5.
//  Copyright © 2019 Tony Tony. All rights reserved.
//

#import "Z3MobileConfig.h"
#import "Z3LoginPrivate.h"
@implementation Z3MobileConfig
+ (instancetype)shareConfig {
    static dispatch_once_t onceToken;
    static Z3MobileConfig *_instance;
    dispatch_once(&onceToken, ^{
        _instance = [[self alloc] init];
    });
    return _instance;
}

- (instancetype)init {
    self = [super init];
    if (self) {
        
    }
    return self;
}


@end
@implementation Z3MobileConfig(Private)
- (void)setMapConfig:(Z3MapConfig *)mapConfig {
    _mapConfig = mapConfig;
}
- (void)setTasks:(NSArray *)tasks {
    _tasks = tasks;
}
- (void)setMenus:(NSArray<Z3AppMenu *> *)menus {
    _menus = menus;
}
- (void)setMobileMapURL:(NSString *)mobileMapURL {
    _mobileMapURL = mobileMapURL;
}
- (void)setTransParamsURL:(NSString *)transParamsURL {
    _transParamsURL = transParamsURL;
}
@end
