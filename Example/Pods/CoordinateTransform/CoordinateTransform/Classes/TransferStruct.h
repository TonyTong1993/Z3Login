//
//  TransferStruct.h
//  管网宝
//
//  Created by ZONDY on 12-12-17.
//  Copyright (c) 2012年 ZONDY. All rights reserved.
//

#ifndef ____transferStruct_h
#define ____transferStruct_h
#define  PI   3.14159265358979323846

// Object-C 没有命名空间、没有操作符重载、不像c++那样复杂 
//四参数结构体
typedef struct 
{
    //x方向偏移量，单位：米
    double x_off;
    //y方向偏移量，单位：米
    double y_off;
    //尺度因子，单位，无
    double m;
    //旋转角度，单位弧度
    double angle;
}FOURPARAM;

//七参数结构体
typedef struct 
{
    //x方向偏移量，单位：米
    double x_off;
    //y方向偏移量，单位：米
    double y_off;
    //z方向偏移量，单位：米
    double z_off;
    //绕x轴旋转的角度，单位：弧度
    double x_angle;
    //绕y轴旋转的角度，单位：弧度
    double y_angle;
    //绕z轴旋转的角度，单位：弧度
    double z_angle;
    //尺度因子，单位，无
    double m;
}SEVENPARAM;

//六参数结构体
typedef struct 
{
    //a为地方独立坐标系下已知的一点
    //a在地方坐标系下的x坐标，单位：米
    double x0_local;
    //a在地方独立坐标下的y坐标，单位：米
    double y0_local;
    //a点的gps经纬度经高斯投影后的平面坐标x，单位：米
    double x0_gps;
    //a点的gps经纬度经高斯投影后的平面坐标y，单位：米
    double y0_gps;
    //旋转角度，单位：弧度
    double angle;
    //尺度因子，单位：无
    double m;
}SIXPARAM;

//中央经线投影时所需的偏移参数结构体（二参数结构体）
typedef struct 
{
    //x方向偏移量
    double x_off;
    //y方向偏移量
    double y_off;
}TWOPARAM;
//WGS-84椭球参数
typedef struct 
{
    //椭球长半轴，单位：米
    double a;
    //扁率，单位：无
    double f;
    //第一偏心率的平方，单位：无
    double e2;
    //测绘计算常数
    double A1, A2, A3, A4;
}GPS_ELLIPSE;

//北京54椭球参数
typedef struct 
{
    //椭球长半轴，单位：米
    double a;
    //扁率，单位：无
    double f;
    //第一偏心率的平方，单位：无
    double e2;
    //测绘计算常数
    double A1, A2, A3, A4;
}BJ_ELLIPSE;

//西安80椭球参数
typedef struct 
{
    //椭球长半轴，单位：米
    double a;
    //扁率，单位，无
    double f;
    //第一偏心率的平方，单位：无
    double e2;
    //测绘计算常数
    double A1, A2, A3, A4;
}XA_ELIPSE;

typedef struct
{
    double four_x_off;
    double four_y_off;
    double four_angle;
    double four_m;
    
    //x方向偏移量，单位：米
    double seven_x_off;
    //y方向偏移量，单位：米
    double seven_y_off;
    //z方向偏移量，单位：米
    double seven_z_off;
    //绕x轴旋转的角度，单位：弧度
    double seven_x_angle;
    //绕y轴旋转的角度，单位：弧度
    double seven_y_angle;
    //绕z轴旋转的角度，单位：弧度
    double seven_z_angle;
    //尺度因子，单位，无
    double seven_m;
}SEVEN_FOUR;

typedef struct
{
    double x_off;
    double y_off;

    //x方向偏移量，单位：米
    double seven_x_off;
    //y方向偏移量，单位：米
    double seven_y_off;
    //z方向偏移量，单位：米
    double seven_z_off;
    //绕x轴旋转的角度，单位：弧度
    double seven_x_angle;
    //绕y轴旋转的角度，单位：弧度
    double seven_y_angle;
    //绕z轴旋转的角度，单位：弧度
    double seven_z_angle;
    //尺度因子，单位，无
    double seven_m;

}SEVEN_PARAM_REV;
#endif
