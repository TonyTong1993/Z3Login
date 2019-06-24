//
//  Z3MobileTask.h
//  Z3Newwork_Example
//
//  Created by 童万华 on 2019/6/5.
//  Copyright © 2019 Tony Tony. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface Z3MobileTask : NSObject

/**
name:[SpacialSearchUrl,PatrolFeatureServer,PatrolServer,WaiQinServer,LeakingServer,PatrolDeviceQueryIpPort,AddressSearchServerUrl]
 */
@property (nonatomic,copy,readonly) NSString *name;
@property (nonatomic,copy,readonly) NSString *baseURL;
@end

NS_ASSUME_NONNULL_END
