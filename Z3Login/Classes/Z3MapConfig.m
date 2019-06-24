//
//  Z3MapConfig.m
//  Z3Newwork_Example
//
//  Created by 童万华 on 2019/6/5.
//  Copyright © 2019 Tony Tony. All rights reserved.
//

#import "Z3MapConfig.h"
#import "Z3LoginPrivate.h"
@implementation Z3MapConfig

@end

@implementation Z3MapLayer

@end


@implementation Z3MapConfig(Private)
- (void)setInitialExtent:(NSString *)initialExtent {
    _initialExtent = initialExtent;
}
- (void)setMapLoadType:(NSString *)mapLoadType {
    _mapLoadType = mapLoadType;
}
- (void)setDispMaxResolution:(NSString *)dispMaxResolution {
    _dispMaxResolution = dispMaxResolution;
}
- (void)setDispMinResolution:(NSString *)dispMinResolution {
    _dispMinResolution = dispMinResolution;
}
- (void)setAddressSearchType:(NSString *)addressSearchType {
    _addressSearchType = addressSearchType;
}
- (void)setSources:(NSArray *)sources {
    _sources = sources;
}
@end

@implementation Z3MapLayer(Private)
- (void)setSourceType:(NSString *)sourceType {
    _sourceType = sourceType;
}
- (void)setID:(NSString *)ID {
    _ID = ID;
}
- (void)setName:(NSString *)name {
    _name = name;
}
- (void)setDesc:(NSString *)desc {
    _desc = desc;
}
- (void)setUrl:(NSString *)url {
    _url = url;
}
- (void)setVisible:(BOOL)visible {
    _visible = visible;
}
- (void)setDispMaxScale:(NSString *)dispMaxScale {
    _dispMaxScale = dispMaxScale;
}
- (void)setDispMinScale:(NSString *)dispMinScale {
    _dispMinScale = dispMinScale;
}
- (void)setDispRect:(NSString *)dispRect {
    _dispRect = dispRect;
}

@end
