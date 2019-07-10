//
//  transLocation.h
//  管网宝
//
//  Created by ZONDY on 12-12-17.
//  Copyright (c) 2012年 ZONDY-ZiZhengzhuan. All rights reserved.
//

#ifndef _______transLocation__
#define _______transLocation__
#pragma once

#import "transferStruct.h"
#include "nnMatrix.h"
#import <string.h>
#import <math.h>
class CoorTran
{
public:
    CoorTran(short transType,short ellipseType, double middleLine,TWOPARAM pTWOPARAM,FOURPARAM pFOURPARAM,SEVENPARAM pSEVENPARAM,SIXPARAM pSIXPARAM,SEVEN_FOUR pSEVEN_FOUR,SEVEN_PARAM_REV pSEVEN_PARAM_REV);
private:
    //转换类型，1：为七参数法，2为七参数+四参数法，3为四参数法，4为六参数法,6为七参数+四参数反转
    short m_transType;
    //客户地图所采用的椭球类型，1为北京54椭球，2为西安80椭球,3为WGS-84椭球
    short m_ellipseType;
    //中央经线，单位：度
    double m_middleLine;
    //西安80椭球
    XA_ELIPSE m_xaEllipse;
    //北京54椭球
    BJ_ELLIPSE m_bjEllipse;
    //WGS-84椭球
    GPS_ELLIPSE m_gpsEllipse;
    //六参数
    SIXPARAM m_sixParam;
    //四参数
    FOURPARAM m_fourParam;
    //七参数
    SEVENPARAM m_sevenParam;
    //二参数
    TWOPARAM m_twoParam;
private:
    //高斯投影
    //ellipseType 椭球类型
    //middleLine 中央经线，单位：度
    //B,L 纬度和经度，单位弧度
    //x y 高斯投影后的平面坐标，单位：米
    //返回值：操作是否成功，0-失败，1-成功
    short GaosPrj(short ellipseType, double middleLine, double B, double L,  double &x, double &y);
    //高斯逆向投影
    //ellipseType 椭球类型
    //middleLine 中央经线，单位：度
    //x y 高斯投影后的平面坐标，单位：米
    //B,L 纬度和经度，单位弧度
    //返回值：操作是否成功，0-失败，1-成功
    short GaussProjInvCal(short ellipseType, double middleLine, double x, double y, double &B,  double &L);
    //计算子午线弧长
    //B纬度，单位：弧度，N为迭代次数
    //返回值：子午线弧长
    double MeriddianArcLength(short ellipseType, double B, int N);
    //七参数转换
    //param_7 七参数结构体
    //X，Y，Z待转换的空间直角坐标，单位 米
    //X1，Y1,Z1转换后的空间直角坐标，单位：米
    //返回值：操作是否成功，0-失败，1-成功
    short SevenParamTrans(SEVENPARAM param_7, double X, double Y, double Z, double &X1,  double &Y1,double &Z1);
    //七参数转换(矩阵版)
    //param_7 七参数结构体
    //X，Y，Z待转换的空间直角坐标，单位 米
    //X1，Y1,Z1转换后的空间直角坐标，单位：米
    //返回值：操作是否成功，0-失败，1-成功
    short SevenParamTrans_Multi(SEVENPARAM param_7, double X, double Y, double Z, double &X1,  double &Y1,  double &Z1);
    //四参数转换
    //param_4 四参数结构体
    // x0,y0 待转换的平面直角坐标，单位：米
    //x，y转换后的平面直角坐标，单位：米
    //返回值：操作是否成功，0-失败，1-成功
    short FourParamTrans(FOURPARAM param_4, double x0, double y0,  double &x,  double &y);
    //六参数转换
    //param_6 六参数结构体
    //x0 y0 待转换的平面坐标，单位：米
    //x y转换后的平面坐标，单位：米
    //返回值：操作是否成功，0-失败，1-成功
    short SixParamTrans(SIXPARAM param_6, double x0, double y0, double &x,  double &y);
    //将WGS-84椭球下的经纬度坐标转换为空间直角坐标
    //B 纬度，单位，弧度
    //L经度，单位：弧度
    //H高程，单位：米
    //X,Y,Z,单位：米
    //返回值：操作是否成功，0-失败，1-成功
    short BLH2XYZ(short ellipseType, double B, double L, double H,  double &X,  double &Y,  double &Z);
    //空间直角坐标转换为经纬度
    //X,Y,Z,单位：米
    //B, 纬度，单位：弧度
    //L 经度，单位：弧度
    //客户地图所采用的椭球类型，1为北京54椭球，2为西安80椭球
    //返回值：操作是否成功，0-失败，1-成功
    short XYZ2BL(short ellipseType, double X, double Y, double Z, double &B,  double &L);
    short InitTransParams(short transType);
    //取转换参数，转换参数、转换类型和椭球类型保存在xml文件中，通过该函数读取转换参数
    //返回值：操作是否成功，0-失败，1-成功
    short InitTransParams();
    
    short FourParamTransReverse(FOURPARAM param_4,double x,double y,double z,double &OX ,double &OY,double &OZ);
    
    short SevenParamTransReverse(SEVENPARAM param_7, double x,double y,double z,double &OX ,double &OY,double &OZ);
public:
    //度分秒转换为弧度
    //ddffmm，要转换的参数，单位ddffmm（1202532.6）
    //rad，转换后的结果参数，单位：弧度
    //返回值：操作是否成功，0-失败，1-成功
    int DFMToRad(double ddffmm,  double &rad);
    //弧度转为ddffmm
    int RadToDFM(double rad,double &ddffmm);
    //坐标转换，
    //B 维度单位（度分秒 ddffmm如1203036.23）L经度，单位（度分秒 ddffmm），H高度 米
    //x y,z为转换后的平面坐标，单位为 米
    //返回值：操作是否成功，0-失败，1-成功
    short CoorTrans(double B, double L, double H,double &x, double &y,double &z,short transType);
    
    //坐标反转，
    //x y z为转换后的平面坐标，单位为 米
    //B 维度单位（度分秒 ddffmm如1203036.23）L经度，单位（度分秒 ddffmm）H单位米
    //返回值：
    short CoorTransReverse(double x, double y, double z,double &B, double &L,double &H,short transType);
    
};
#endif /* defined(_______transLocation__) */
