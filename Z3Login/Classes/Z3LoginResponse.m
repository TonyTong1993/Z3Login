//
//  Z3LoginResponse.m
//  Z3Login_Example
//
//  Created by 童万华 on 2019/6/12.
//  Copyright © 2019 Tony Tony. All rights reserved.
//

#import "Z3LoginResponse.h"
#import "Z3User.h"
#import "Z3AppMenu.h"
#import "Z3MobileConfig.h"
#import "YYKit.h"
#import "Z3LoginPrivate.h"
#import "Z3NetworkConfig.h"
@implementation Z3LoginResponse
@synthesize error = _error;
- (void)toModel {
    NSDictionary *data = self.responseJSONObject;
    //服务器处理失败
    if (![data[@"isSuccess"] boolValue]) {
        return;
    }
    NSArray *menus = [data valueForKey:@"menus"];
    NSDictionary *userDict = [data valueForKey:@"user"];
    NSArray *mapConfigs = [data valueForKey:@"mobileCfg"];
    if (data == nil) {
        return;
    }
    [self toUser:userDict];
    if (menus.count) {
         [self toAppMenus:menus];
    }
    [self toMapConfig:mapConfigs];
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
    NSString *token = [json valueForKey:@"token"];
    
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
//    [[Z3NetworkConfig shareConfig] setToken:token ?:@""];
}

- (void)toAppMenus:(NSArray *)menus {
    NSString *plistPath = [[NSBundle mainBundle] pathForResource:@"appmenulist" ofType:@"plist"];
    NSData *data = [[NSData alloc] initWithContentsOfFile:plistPath];
    if (data == nil) {
        return;
    }
    NSError * __autoreleasing error = nil;
    NSArray *metas = [NSPropertyListSerialization propertyListWithData:data options:0 format:0 error:&error];
    if (error) {
        NSAssert(false, @"parse appmenulist.plist failure");
    }
    NSArray *names = [metas valueForKey:@"name"];
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"pageUrl BEGINSWITH[c] 'MAIN_TAB'"];
    NSArray *tabmenus = [menus filteredArrayUsingPredicate:predicate];
    if (!tabmenus.count) {
        tabmenus = [self loadDefaultAppMenus];
    }
    
    NSMutableArray *tabs = [NSMutableArray arrayWithCapacity:5];
    __block NSArray *appdicts = nil;
    __block NSDictionary *appCenter = nil;
    //合并metas与tabmenus中相同的数据
    [tabmenus enumerateObjectsUsingBlock:^(NSDictionary *obj, NSUInteger idx, BOOL * _Nonnull stop) {
        NSString *nodename = [obj objectForKey:@"nodeName"];
        if ([names containsObject:nodename]) {
            NSUInteger index = [names indexOfObject:nodename];
            NSDictionary *tab = [metas objectAtIndex:index];
            if ([nodename isEqualToString:@"外勤应用"]) {
                appdicts = [tab valueForKey:@"menus"];
                appCenter = tab;
            }
            [tabs addObject:tab];
        }else {
            NSAssert(false, @"tab menu not config");
        }
    }];
    
    //合并metas与appmenus中相同的数据
    predicate = [NSPredicate predicateWithFormat:@"pageUrl BEGINSWITH[c] 'app:'"];
    NSArray *appmenus = menus; //[menus filteredArrayUsingPredicate:predicate];
    if (!appmenus.count) return;
    NSAssert(appCenter, @"don`t have app center");
    NSAssert(appdicts, @"don`t have apps");
    names = [appdicts valueForKey:@"name"];
    NSMutableArray *apps = [NSMutableArray array];
    [appmenus enumerateObjectsUsingBlock:^(NSDictionary *obj, NSUInteger idx, BOOL * _Nonnull stop) {
        NSString *nodename = [obj objectForKey:@"nodeName"];
        if ([names containsObject:nodename]) {
            NSUInteger index = [names indexOfObject:nodename];
            NSDictionary *app = [appdicts objectAtIndex:index];
            [apps addObject:app];
        }else {
            //TODO:苏州水利简易版
//            NSAssert(false, @"tab menu not config");
        }
    }];
    
    NSMutableDictionary *mappcenter = [appCenter mutableCopy];
    [mappcenter setObject:[apps copy] forKey:@"menus"];
    NSUInteger index = [tabs indexOfObject:appCenter];
    [tabs replaceObjectAtIndex:index withObject:mappcenter];
    
    NSMutableArray *mmenus = [NSMutableArray arrayWithCapacity:5];
    for (NSDictionary *json in tabs) {
        Z3AppMenu *menu = [Z3AppMenu modelWithJSON:json];
        [mmenus addObject:menu];
    }
    [[Z3MobileConfig shareConfig] setMenus:[mmenus copy]];
}

- (void)toMapConfig:(NSArray *)datas {
    for (NSDictionary *dict in datas) {
        if ([[dict valueForKey:@"key"] isEqualToString:@"MobileMap"]) {
            [[Z3MobileConfig shareConfig] setMobileMapURL:[dict valueForKey:@"value"]];
        }else if ([[dict valueForKey:@"key"] isEqualToString:@"TransParams"]) {
             [[Z3MobileConfig shareConfig] setTransParamsURL:[dict valueForKey:@"value"]];
        }
    }
}

- (NSArray *)loadDefaultAppMenus {
    NSString *path = [[NSBundle mainBundle] pathForResource:@"app_default_menus" ofType:@"json"];
        NSData *data = [[NSData alloc] initWithContentsOfFile:path];
        NSError * __autoreleasing error = nil;
        NSDictionary *json = [NSJSONSerialization JSONObjectWithData:data options:0 error:&error];
        if (error) {
            NSAssert(false, @"模拟轨迹点读取失败");
        }
        return  json[@"menus"];
}
@end
