//
//  Z3MapConfigRequest.m
//  Z3Newwork_Example
//
//  Created by 童万华 on 2019/6/4.
//  Copyright © 2019 Tony Tony. All rights reserved.
//

#import "Z3MapConfigRequest.h"
#import "Z3MapConfigResponse.h"
@implementation Z3MapConfigRequest
@synthesize responseClasz = _responseClasz;
- (Class)responseClasz {
    if (!_responseClasz) {
        _responseClasz = [Z3MapConfigResponse class];
    }
    return _responseClasz;
}
@end
