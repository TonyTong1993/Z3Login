//
//  TransParamParser.h
//  SQLiteSpatialite
//
//  Created by iefmac004 on 13-1-4.
//  Copyright (c) 2013年 iefmac004. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "transferStruct.h"

@interface TransParamParser : NSObject <NSXMLParserDelegate>
{
    NSError* _error;
    NSString *_currentElement;
    NSString *_lastElement;
    NSMutableArray *_lods;
    NSXMLParser* _xmlParser;
    double ellipseType,middleLine,transType,rev;
    TWOPARAM  twoparam;
    FOURPARAM fourparam;
    SEVENPARAM sevenparam;
    SIXPARAM sixparam;
    SEVEN_FOUR sevenfour;
    SEVEN_PARAM_REV sevenparamrev;
}

@property (nonatomic,retain,readwrite) NSError* error;
@property (nonatomic,retain,readwrite) NSString* lastElement;
@property (nonatomic,retain,readwrite) NSString* currenElementName;
@property (nonatomic,retain,readwrite) NSMutableArray *lods;
-(void)startParsing:(NSString *)filePath;
-(void)startParsingWithParser:(NSXMLParser *)parser;
-(double)getEllipseType;
-(double)getMiddleLine;
-(double)getTransType;
-(double)getRev;
-(TWOPARAM)getTWOPARAM;
-(FOURPARAM)getFOURPARAM;
-(SEVENPARAM)getSEVENPARAM;
-(SIXPARAM)getSIXPARAM;
-(SEVEN_FOUR)getSEVEN_FOUR;
-(SEVEN_PARAM_REV)getSEVEN_PARAM_REV;

@end
