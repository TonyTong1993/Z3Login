//
//  Z3MapConfig.h
//  Z3Newwork_Example
//
//  Created by 童万华 on 2019/6/5.
//  Copyright © 2019 Tony Tony. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface Z3MapConfig : NSObject
@property (nonatomic,copy,readonly) NSString *initialExtent;
@property (nonatomic,copy,readonly) NSString *mapLoadType;
@property (nonatomic,copy,readonly) NSString *dispMaxResolution;
@property (nonatomic,copy,readonly) NSString *dispMinResolution;
@property (nonatomic,copy,readonly) NSString *addressSearchType;
@property (nonatomic,copy,readonly) NSArray  *sources;

@end

@interface Z3MapLayer : NSObject
@property (nonatomic,copy,readonly) NSString *sourceType;
@property (nonatomic,copy,readonly) NSString *ID;
@property (nonatomic,copy,readonly) NSString *name;
@property (nonatomic,copy,readonly) NSString *desc;
@property (nonatomic,copy,readonly) NSString *url;
@property (nonatomic,assign,readonly) BOOL    visible;
@property (nonatomic,copy,readonly) NSString  *dispMaxScale;
@property (nonatomic,copy,readonly) NSString  *dispMinScale;
@property (nonatomic,copy,readonly) NSString  *dispRect;
@end

NS_ASSUME_NONNULL_END
