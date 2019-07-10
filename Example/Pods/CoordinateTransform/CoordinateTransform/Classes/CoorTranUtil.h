//
//  CoorTranUtil.h
//  IPipe
//
//  Created by DigitalCity on 14-8-19.
//  Copyright (c) 2014年 ZiZhengzhuan. All rights reserved.
//

#import <Foundation/Foundation.h>
@interface CoorTranUtil : NSObject
-(instancetype)initWithTransParamFilePath:(NSString*)filePath;
-(instancetype)initWithParser:(NSXMLParser*)parser;
-(void)parserransParamFilePath:(NSString*)filePath;
-(Boolean)isParamInited;

//度分秒转换为弧度
//ddffmm，要转换的参数，单位ddffmm（1202532.6）
//rad，转换后的结果参数，单位：弧度
//返回值：操作是否成功，99999999-失败
-(double)DFMToRad:(double)ddffmm;

//弧度转为ddffmm 99999999-失败
-(double)RadToDFM:(double) rad;
//度转为度分秒
-(double)DuToDFM:(double) du;
//度分秒转成度
-(double)DFMToDu:(double) ddffmm;
//坐标转换，
//@parameter: B 维度单位（度分秒 ddffmm如1203036.23）L经度，单位（度分秒 ddffmm）
//@return：CGPoint(x y)为转换后的平面坐标，单位为 米
-(CGPoint)CoorTransDFM:(double)B L:(double) L H:(double) H;

//度分秒格式的经纬度转平面
//@parameter:平面坐标 x，y 单位米
//@return：CGPoint(x y)为转换后的经纬度，单位为（度分秒 ddffmm）
-(CGPoint)CoorTransReverseDFM:(double)x Y:(double)y;
//坐标转换，
//@parameter: lat 纬度 单位（度）lon经度，单位（度），height g海拔高，单位米，可以为0
//@return：CGPoint(x y)为转换后的平面坐标，单位为 米
-(CGPoint)CoorTrans:(double)lat lon:(double) lon height:(double) height;
//坐标转换经纬度
//@parameter:平面坐标 x，y 单位米
//@return：CGPoint(x y)为转换后的经纬度， x为维度，y为经度 单位为（度）
//返回值：
-(CGPoint)CoorTransReverse:(double)x Y:(double)y;
@end
