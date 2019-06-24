//
//  Z3MapConfigRequest.m
//  Z3Newwork_Example
//
//  Created by 童万华 on 2019/6/4.
//  Copyright © 2019 Tony Tony. All rights reserved.
//

#import "Z3MapConfigRequest.h"
#import "Z3MapConfigResponse.h"
#import "AFNetworking.h"
@implementation Z3MapConfigRequest
@synthesize responseSerializer = _responseSerializer,responseClasz = _responseClasz;
- (AFHTTPResponseSerializer *)responseSerializer {
    if (!_responseSerializer) {
        _responseSerializer = [[AFXMLParserResponseSerializer alloc] init];
    }
    return _responseSerializer;
}

- (Class)responseClasz {
    if (!_responseClasz) {
        _responseClasz = [Z3MapConfigResponse class];
    }
    return _responseClasz;
}
@end
