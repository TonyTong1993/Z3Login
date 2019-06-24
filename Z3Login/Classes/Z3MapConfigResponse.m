//
//  Z3MapConfigResponse.m
//  Z3Newwork_Example
//
//  Created by 童万华 on 2019/6/4.
//  Copyright © 2019 Tony Tony. All rights reserved.
//

#import "Z3MapConfigResponse.h"
#import "Z3LoginPrivate.h"
#import "Z3MobileConfig.h"
#import "Z3MapConfig.h"
#import "Z3MobileTask.h"
@interface Z3MapConfigResponse ()<NSXMLParserDelegate>
@property (nonatomic,strong) NSXMLParser *xmlParser;
@property (nonatomic,strong) NSMutableString *xmlValue;
@property (nonatomic,assign) BOOL storingFlag;
@property (nonatomic,copy) NSArray *storeElements;
@property (nonatomic,strong) NSMutableArray *sources;
@property (nonatomic,strong) NSMutableArray *tasks;
@property (nonatomic,strong) Z3MapConfig *mapConfig;
@property (nonatomic,strong) Z3MapLayer *mapLayer;
@property (nonatomic,strong) Z3MobileTask *task;
@end
@implementation Z3MapConfigResponse
@synthesize error = _error;
- (void)toModel {
    if (self.responseJSONObject) {
       self.xmlParser = self.responseJSONObject;
       self.xmlParser.delegate = self;
       _storeElements = [[NSArray alloc] initWithObjects:@"initExtent",
                         @"SourceType",
                         @"ID",
                         @"Name",
                         @"Description",
                         @"URL",
                         @"visible",
                         @"dispMaxScale",
                         @"dispMinScale",
                         @"dispRect",
                         @"mapLoadType",
                         @"dispMaxResolution",
                         @"dispMinResolution",
                         @"AddressSearchType",
                         @"key",
                         @"value",nil];

       BOOL isParse = [self.xmlParser parse];
       NSAssert(isParse, @"data format is not match xml");
    }
}

#pragma mark -NSXMLParserDelegate
    // Document handling methods
- (void)parserDidStartDocument:(NSXMLParser *)parser {
    
}

    // sent when the parser begins parsing of the document.
- (void)parserDidEndDocument:(NSXMLParser *)parser {
    
}
// sent when the parser has completed parsing. If this is encountered, the parse was successful.
- (void)parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName namespaceURI:(nullable NSString *)namespaceURI qualifiedName:(nullable NSString *)qName attributes:(NSDictionary<NSString *, NSString *> *)attributeDict {
    if ([elementName isEqualToString:@"Map"]) {
            //初始化mapConfiguration
        _mapConfig = [[Z3MapConfig alloc] init];
    }else if ([elementName isEqualToString:@"Sources"]) {
         //初始化taskConfiguration
        _sources = [NSMutableArray array];
    }else if ([elementName isEqualToString:@"Source"]) {
            //初始化taskConfiguration
        _mapLayer  = [[Z3MapLayer alloc] init];
    }else if ([elementName isEqualToString:@"tasks"]) {
        _tasks  = [NSMutableArray array];
    }else if ([elementName isEqualToString:@"task"]) {
        _task  = [[Z3MobileTask alloc] init];
    }
    _storingFlag = [_storeElements containsObject:elementName];
}


- (void)parser:(NSXMLParser *)parser didEndElement:(NSString *)elementName namespaceURI:(nullable NSString *)namespaceURI qualifiedName:(nullable NSString *)qName {
    if ([elementName isEqualToString:@"Map"]){
        [[Z3MobileConfig shareConfig] setMapConfig:_mapConfig];
    }else if ([elementName isEqualToString:@"tasks"]) {
         [[Z3MobileConfig shareConfig] setTasks:[_tasks copy]];
        _tasks = nil;
    }else if ([elementName isEqualToString:@"Sources"]) {
        [_mapConfig setSources:[_sources copy]];
        _sources = nil;
    }else if ([elementName isEqualToString:@"Source"]){
            [_sources addObject:_mapLayer];
            _mapLayer = nil;
    }else if ([elementName isEqualToString:@"task"]) {
        [_tasks addObject:_task];
        _task = nil;
    }
    if (_storingFlag) {
            //去掉字符串的空格
        NSString *value = [_xmlValue stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
            //将字符串置空
        [_xmlValue setString:@""];
        if ([elementName isEqualToString:@"initExtent"]) {
            [_mapConfig setInitialExtent:value];
        }else if ([elementName isEqualToString:@"SourceType"]){
            [_mapLayer setSourceType:value];
        }else if ([elementName isEqualToString:@"ID"]){
            [_mapLayer setID:value];
        }else if ([elementName isEqualToString:@"Name"]){
             [_mapLayer setName:value];
        }else if ([elementName isEqualToString:@"Description"]){
             [_mapLayer setDesc:value];
        }else if ([elementName isEqualToString:@"URL"]){
             [_mapLayer setUrl:value];
        }else if ([elementName isEqualToString:@"visible"]){
             [_mapLayer setVisible:[value boolValue]];
        }else if ([elementName isEqualToString:@"dispMaxScale"]){
             [_mapLayer setDispMaxScale:value];
        }else if ([elementName isEqualToString:@"dispMinScale"]){
             [_mapLayer setDispMinScale:value];
        }else if ([elementName isEqualToString:@"dispRect"]){
             [_mapLayer setDispRect:value];
        }else if ([elementName isEqualToString:@"key"]){
            [_task setName:value];
        }else if ([elementName isEqualToString:@"value"]){
            [_task setBaseURL:value];
        }
        
    }
}

- (void)parser:(NSXMLParser *)parser foundCharacters:(NSString *)string {
    if (_storingFlag) {
        if (!_xmlValue) {
            _xmlValue = [[NSMutableString alloc] initWithString:string];
        }
        else {
            [_xmlValue appendString:string];
        }
    }
}

- (void)parser:(NSXMLParser *)parser parseErrorOccurred:(NSError *)parseError {
    //TODO: handle error
    _error = parseError;
}

- (void)parser:(NSXMLParser *)parser validationErrorOccurred:(NSError *)validationError {
    //TODO: handle error
    _error = validationError;
}


@end
