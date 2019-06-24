//
//  Z3User.h
//  Z3Login_Example
//
//  Created by 童万华 on 2019/6/12.
//  Copyright © 2019 Tony Tony. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN
extern NSString * const KEY_AUTO_LOGIN ;
extern NSString * const KEY_AUTO_FILL_PWD;
extern  NSString * const KEY_USER_NAME;
extern  NSString * const KEY_USER_PASSWORD;
extern  NSString * const KEY_USER_LOGIN_FLAG;//登录状态
extern  NSString * const KEY_USER_AUTHORIZATION_EVENT_EDIT;//事件编辑
extern NSString * const KEY_USER_AUTHORIZATION_EVENT_SELF_QUERY;
extern  NSString * const KEY_USER_AUTHORIZATION_EVENT_TO_WORK_ORDER;//一键转工单


@interface Z3User : NSObject
+ (instancetype)shareInstance;
+ (instancetype)new NS_UNAVAILABLE;
- (instancetype)init NS_UNAVAILABLE;

@property (nonatomic,copy) NSString *username;//用户名
@property (nonatomic,assign) NSInteger uid;//用户唯一标识
@property (nonatomic,copy) NSString *email;//用户邮箱地址
@property (nonatomic,copy) NSString *phone;//用户手机号
@property (nonatomic,copy) NSString *company;//公司名
@property (nonatomic,copy) NSString *ecode;//公司唯一标示码
@property (nonatomic,assign) NSInteger groupId;//组织ID
@property (nonatomic,assign) NSInteger groupLev;//组织级别
@property (nonatomic,copy) NSString *groupCode;//组织编号
@property (nonatomic,copy) NSString *groupName;
@property (nonatomic,copy) NSString *role;
@property (nonatomic,copy) NSString *roleCode;
@property (nonatomic,copy) NSString *trueName;


@end

NS_ASSUME_NONNULL_END
