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
#import "Z3URLConfig.h"
@interface Z3MapConfigResponse ()<NSXMLParserDelegate>
@property (nonatomic,strong) NSXMLParser *xmlParser;
@property (nonatomic,strong) NSMutableString *xmlValue;
@property (nonatomic,assign) BOOL storingFlag;
@property (nonatomic,copy) NSArray *storeElements;
@property (nonatomic,strong) NSMutableArray *basemaps;
@property (nonatomic,strong) NSMutableArray *sources;
@property (nonatomic,strong) NSMutableArray *tasks;
@property (nonatomic,strong) Z3MapConfig *mapConfig;
@property (nonatomic,strong) Z3Basemap *basemap;
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
                          @"value",
                          @"opacity",nil];
        
        [self.xmlParser parse];
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
    }else if ([elementName isEqualToString:@"Basemaps"]) {
            //初始化taskConfiguration
        _basemaps = [[NSMutableArray alloc] init];
    }else if ([elementName isEqualToString:@"basemap"]) {
            //初始化taskConfiguration
        _basemap  = [[Z3Basemap alloc] init];
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
    }else if ([elementName isEqualToString:@"Basemaps"]) {
        [_mapConfig setBasemaps:[_basemaps copy]];
        _basemaps = nil;
    }else if ([elementName isEqualToString:@"Sources"]) {
        [_mapConfig setSources:[_sources copy]];
        _sources = nil;
    }else if ([elementName isEqualToString:@"basemap"]){
        [_basemaps addObject:_basemap];
        _basemap = nil;
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
            if (_basemap) {
                [_basemap setSourceType:value];
            }else {
                [_mapLayer setSourceType:value];
            }
        }else if ([elementName isEqualToString:@"ID"]){
            if (_basemap) {
                [_basemap setID:value];
            }else {
                [_mapLayer setID:value];
            }
            
        }else if ([elementName isEqualToString:@"Name"]){
            if (_basemap) {
                [_basemap setName:value];
            }else {
                [_mapLayer setName:value];
            }
        }else if ([elementName isEqualToString:@"Description"]){
            if (_basemap) {
                [_basemap setDesc:value];
            }else {
                [_mapLayer setDesc:value];
            }
        }else if ([elementName isEqualToString:@"URL"]){
            if (_basemap) {
                [_basemap setUrl:value];
            }else {
                [_mapLayer setUrl:value];
            }
        }else if ([elementName isEqualToString:@"visible"]){
            if (_basemap) {
                [_basemap setVisible:value];
            }else {
                [_mapLayer setVisible:value];
            }
        }else if ([elementName isEqualToString:@"dispMaxScale"]){
            if (_basemap) {
                [_basemap setDispMaxScale:value];
            }else {
                [_mapLayer setDispMaxScale:value];
            }
        }else if ([elementName isEqualToString:@"dispMinScale"]){
            if (_basemap) {
                [_basemap setDispMinScale:value];
            }else {
                [_mapLayer setDispMinScale:value];
            }
        }else if ([elementName isEqualToString:@"dispRect"]){
            if (_basemap) {
                [_basemap setDispRect:value];
            }else {
                [_mapLayer setDispRect:value];
            }
            
        }else if ([elementName isEqualToString:@"opacity"]){
            if (_basemap) {
                [_basemap setOpacity:[value floatValue]];
            }else {
                [_mapLayer setOpacity:[value floatValue]];
            }
        }else if ([elementName isEqualToString:@"key"]){
            [_task setName:value];
        }else if ([elementName isEqualToString:@"value"]){
            
            if ([value hasPrefix:@"http"]) {
                [_task setBaseURL:value];
            }else {
                NSString *rootURL = [Z3URLConfig configration].rootURLPath;
                NSString *url = [NSString stringWithFormat:@"%@%@",rootURL,value];
                [_task setBaseURL:url];
            }
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
