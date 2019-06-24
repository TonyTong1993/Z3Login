//
//  Z3LoginPrivate.h
//  Z3Login_Example
//
//  Created by 童万华 on 2019/6/13.
//  Copyright © 2019 Tony Tony. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Z3MobileConfig.h"
#import "Z3MapConfig.h"
#import "Z3MobileTask.h"
NS_ASSUME_NONNULL_BEGIN

@interface Z3LoginPrivate : NSObject

@end

@interface Z3MobileConfig(Private)
- (void)setMapConfig:(Z3MapConfig * _Nonnull)mapConfig;
- (void)setTasks:(NSArray * _Nonnull)tasks;
- (void)setMenus:(NSArray<Z3AppMenu *> * _Nonnull)menus;
- (void)setMobileMapURL:(NSString * _Nonnull)mobileMapURL;
- (void)setTransParamsURL:(NSString * _Nonnull)transParamsURL;
@end

@interface Z3MapConfig(Private)
- (void)setInitialExtent:(NSString * _Nonnull)initialExtent;
- (void)setMapLoadType:(NSString * _Nonnull)mapLoadType;
- (void)setDispMaxResolution:(NSString * _Nonnull)dispMaxResolution;
- (void)setDispMinResolution:(NSString * _Nonnull)dispMinResolution;
- (void)setAddressSearchType:(NSString * _Nonnull)addressSearchType;
- (void)setSources:(NSArray * _Nonnull)sources;
@end

@interface Z3MapLayer(Private)
- (void)setSourceType:(NSString * _Nonnull)sourceType;
- (void)setID:(NSString * _Nonnull)ID;
- (void)setName:(NSString * _Nonnull)name;
- (void)setDesc:(NSString * _Nonnull)desc;
- (void)setUrl:(NSString * _Nonnull)url;
- (void)setVisible:(BOOL)visible;
- (void)setDispMaxScale:(NSString * _Nonnull)dispMaxScale;
- (void)setDispMinScale:(NSString * _Nonnull)dispMinScale;
- (void)setDispRect:(NSString * _Nonnull)dispRect;
@end

@interface Z3MobileTask(Private)
- (void)setName:(NSString * _Nonnull)name;
- (void)setBaseURL:(NSString * _Nonnull)baseURL;
@end
NS_ASSUME_NONNULL_END
