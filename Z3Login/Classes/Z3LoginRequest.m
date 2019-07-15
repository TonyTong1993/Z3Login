//
//  Z3LoginRequest.m
//  Z3Newwork_Example
//
//  Created by 童万华 on 2019/6/2.
//  Copyright © 2019 Tony Tony. All rights reserved.
//

#import "Z3LoginRequest.h"
#import "Z3LoginResponse.h"
#import <AFNetworking/AFNetworking.h>
@implementation Z3LoginRequest
@synthesize responseSerializer = _responseSerializer;

- (AFHTTPResponseSerializer *)responseSerializer {
    if (!_responseSerializer) {
        _responseSerializer = (AFHTTPResponseSerializer *)[[AFJSONResponseSerializer alloc] init];
        _responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript",@"text/html", nil];
    }
    return _responseSerializer;
}

- (Class)responseClasz {
    return [Z3LoginResponse class];
}


@end
