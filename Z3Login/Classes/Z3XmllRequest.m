//
//  Z3XmllRequest.m
//  AFNetworking
//
//  Created by 童万华 on 2019/6/24.
//

#import "Z3XmllRequest.h"
#import "AFURLResponseSerialization.h"
@implementation Z3XmllRequest
@synthesize responseSerializer = _responseSerializer;
- (AFHTTPResponseSerializer *)responseSerializer {
    if (!_responseSerializer) {
        _responseSerializer = [[AFXMLParserResponseSerializer alloc] init];
    }
    return _responseSerializer;
}
@end
