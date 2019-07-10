//
//  CoorTranUtil.m
//  IPipe
//
//  Created by DigitalCity on 14-8-19.
//  Copyright (c) 2014年 ZiZhengzhuan. All rights reserved.
//

#import "CoorTranUtil.h"
#import "transferStruct.h"
#import "CoorTran.h"
#import "TransParamParser.h"
#import <math.h>
/*=============================================================================================
*转换工具外部接口
=============================================================================================*/
@interface CoorTranUtil()
{
    TransParamParser* _parser;
    Boolean isInited;
}
@end

@implementation CoorTranUtil

static CoorTranUtil *sharedCoorTranUtil;

-(Boolean)isParamInited
{
    return isInited;
}

-(instancetype)initWithTransParamFilePath:(NSString*)filePath
{
    self = [super init];
    if(self)
    {
        [self parserransParamFilePath:filePath];
    }
    return self;
}

- (instancetype)initWithParser:(NSXMLParser *)parser {
     self = [super init];
    if (self) {
        [self parserransParamParser:parser];
    }
    
    return self;
}

-(void)parserransParamFilePath:(NSString*)filePath
{
    @try {
        _parser = [[TransParamParser alloc]init];
        [_parser startParsing:filePath];
        isInited = YES;
    }
    @catch (NSException *exception) {
        isInited = NO;
    }
    @finally {
        
    }

}

-(void)parserransParamParser:(NSXMLParser*)parser
{
    @try {
        _parser = [[TransParamParser alloc]init];
        [_parser startParsingWithParser:parser];
        isInited = YES;
    }
    @catch (NSException *exception) {
        isInited = NO;
    }
    @finally {
        
    }
    
}



//度分秒转换为弧度
//ddffmm，要转换的参数，单位ddffmm（1202532.6）
//rad，转换后的结果参数，单位：弧度
//返回值：操作是否成功，-99999999-失败
-(double)DFMToRad:(double)ddffmm
{
    if(!_parser)
        return -99999999;
    CoorTran _coorTran([_parser getTransType],[_parser getEllipseType], [_parser getMiddleLine],[_parser getTWOPARAM],[_parser getFOURPARAM],[_parser getSEVENPARAM],[_parser getSIXPARAM],[_parser getSEVEN_FOUR],[_parser getSEVEN_PARAM_REV]);
    double rad = 0;
    if(1==_coorTran.DFMToRad(ddffmm,rad))
        return rad;
    else
        return -99999999;
}

//弧度转为ddffmm -99999999-失败
-(double)RadToDFM:(double) rad
{
    if(!_parser)
        return -99999999;
    CoorTran _coorTran([_parser getTransType],[_parser getEllipseType], [_parser getMiddleLine],[_parser getTWOPARAM],[_parser getFOURPARAM],[_parser getSEVENPARAM],[_parser getSIXPARAM],[_parser getSEVEN_FOUR],[_parser getSEVEN_PARAM_REV]);
    double dfm = 0;
    if(1==_coorTran.RadToDFM(rad,dfm))
        return dfm;
    else
        return -99999999;
}

//度转为度分秒
-(double)DuToDFM:(double)du {
    double degree = floor(du);
    double bigminutes = (du - degree) * 60;
    double minutes = floor(bigminutes);
    double second = (bigminutes - minutes) * 60;
    double ddffmm = degree * 10000 + minutes * 100 + second;
    
    return ddffmm;
}
//度分秒转成度
-(double) DFMToDu:(double)ddffmm {
    double degree = 0.0, minutes = 0.0, second = 0.0;
    int flag = 0;
    // 判断参数的正负
    if (ddffmm < 0) {
        flag = -1;
    } else {
        flag = 1;
    }
    // 取参数的绝对值
    ddffmm = abs(ddffmm);
    // 取度
    degree = floor(ddffmm / 10000);
    // 取分
    minutes = floor((ddffmm - degree * 10000) / 100);
    // 取秒
    second = ddffmm - degree * 10000 - minutes * 100;
    double dd = 0.0;
    // 转换为弧度
    dd = flag * (degree + minutes / 60 + second / 3600);
    return dd;
}

//坐标转换，
//@parameter: B 维度单位（度分秒 ddffmm如1203036.23）L经度，单位（度分秒 ddffmm）
//@return：CGPoint(x y)为转换后的平面坐标，单位为 米
-(CGPoint)CoorTransDFM:(double)B L:(double) L H:(double) H
{
    if(!_parser)
        return CGPointMake(-99999999, -99999999);
    double x = 0;
    double y = 0;
    double z = 0;
    CoorTran _coorTran([_parser getTransType],[_parser getEllipseType], [_parser getMiddleLine],[_parser getTWOPARAM],[_parser getFOURPARAM],[_parser getSEVENPARAM],[_parser getSIXPARAM],[_parser getSEVEN_FOUR],[_parser getSEVEN_PARAM_REV]);
    if(1 == _coorTran.CoorTrans(B,L,H,x,y,z,[_parser getTransType])) {
        if(0 ==[_parser getRev]){
             return  CGPointMake(y, x);
        } else {
             return  CGPointMake(x, y);
        }
    }
    return  CGPointMake(-99999999, -99999999);
}

//度分秒格式的经纬度转平面
//@parameter:平面坐标 x，y 单位米
//@return：CGPoint(x y)为转换后的经纬度，单位为（度分秒 ddffmm）
-(CGPoint)CoorTransReverseDFM:(double)x Y:(double)y
{
    if(!_parser)
        return CGPointMake(-99999999, -99999999);
    double B = 0;
    double L = 0;
    double H = 0;
    CoorTran _coorTran([_parser getTransType],[_parser getEllipseType], [_parser getMiddleLine],[_parser getTWOPARAM],[_parser getFOURPARAM],[_parser getSEVENPARAM],[_parser getSIXPARAM],[_parser getSEVEN_FOUR],[_parser getSEVEN_PARAM_REV]);
    double ix = x;
    double iy = y;
    double iz = 0;
    if(0 ==[_parser getRev])
    {
        ix = y;
        iy = x;
    }
    
    if(1 == _coorTran.CoorTransReverse(ix,iy,iz,B,L,H,[_parser getTransType]))
        return  CGPointMake(B, L);
    
    return  CGPointMake(-99999999, -99999999);
}


//坐标转换，
//@parameter: lat 纬度 单位（度）lon经度，单位（度），height g海拔高，单位米，可以为0
//@return：CGPoint(x y)为转换后的平面坐标，单位为 米
-(CGPoint)CoorTrans:(double)lat lon:(double) lon height:(double) height{
    double B = [self DuToDFM:lat];
    double L = [self DuToDFM:lon];
    return [self CoorTransDFM:B L:L H:height];
}

//坐标转换经纬度
//@parameter:平面坐标 x，y 单位米
//@return：CGPoint(x y)为转换后的经纬度， x为维度，y为经度 单位为（度）
//返回值：
-(CGPoint)CoorTransReverse:(double)x Y:(double)y{
    CGPoint dfm = [self CoorTransReverseDFM:x Y:y];
    double lat = [self DFMToDu:dfm.x];
    double lon = [self DFMToDu:dfm.y];
    return CGPointMake(lat,lon);
}

@end
