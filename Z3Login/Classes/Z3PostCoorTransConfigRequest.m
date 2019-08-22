//
//  Z3PostCoorTransConfigRequest.m
//  AFNetworking
//
//  Created by ZZHT on 2019/8/20.
//

#import "Z3PostCoorTransConfigRequest.h"
#import <AFNetworking/AFNetworking.h>
@implementation Z3PostCoorTransConfigRequest
- (AFHTTPRequestSerializer *)requestSerializer {
    AFJSONRequestSerializer *serializer = [AFJSONRequestSerializer serializer];
    [serializer setValue:@"application/json" forHTTPHeaderField:@"Accept"];
    [serializer setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    return serializer;
}
@end
