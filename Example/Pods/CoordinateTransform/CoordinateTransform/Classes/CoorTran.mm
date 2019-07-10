//
//  transLocation.cpp
//  管网宝
//
//  Created by ZONDY on 12-12-17.
//  Copyright (c) 2012年 ZONDY-ZiZhengzhuan. All rights reserved.
//

#include "CoorTran.h"
#include "NNMatrix.h"
#import <Foundation/Foundation.h>

CoorTran::CoorTran(short transType,short ellipseType, double middleLine,TWOPARAM pTWOPARAM,FOURPARAM pFOURPARAM,SEVENPARAM pSEVENPARAM,SIXPARAM pSIXPARAM,SEVEN_FOUR pSEVEN_FOUR,SEVEN_PARAM_REV pSEVEN_PARAM_REV)
{
    //转换类型
    m_transType = 0;
    
    //椭球类型
    m_ellipseType = 0;
    
    //中央经线
    m_middleLine = 0.0;
    
    //北京-54椭球参数
    m_bjEllipse.a = 6378245;
    m_bjEllipse.f = 1 / 298.3;
    m_bjEllipse.e2 = 0.006693421623;
    m_bjEllipse.A1 = 111134.8611;
    m_bjEllipse.A2 = -16036.4803;
    m_bjEllipse.A3 = 16.8281;
    m_bjEllipse.A4 = -0.0220;
    
    //西安-80椭球参数
    m_xaEllipse.a = 6378140;
    m_xaEllipse.f = 1 / 298.257;
    m_xaEllipse.e2 = 0.0066943849995879;
    m_xaEllipse.A1 = 111133.0047;
    m_xaEllipse.A2 = -16038.5282;
    m_xaEllipse.A3 = 16.8326;
    m_xaEllipse.A4 = -0.0220;
    
    //WGS-84椭球参数
    m_gpsEllipse.a = 6378137;
    m_gpsEllipse.f = 1 / 298.257233563;
    m_gpsEllipse.e2 = 0.006694379989;
    m_gpsEllipse.A1 = 111133.0047;
    m_gpsEllipse.A2 = -16038.5282;
    m_gpsEllipse.A3 = 16.8326;
    m_gpsEllipse.A4 = -0.0220;
    //初始化转换参数 ,  两个函数，重载函数
    
    m_ellipseType = ellipseType;
    m_middleLine = middleLine;
    m_transType = transType;
    
    switch (m_transType)
    {
        case 1:
            //四参数转换 1
            m_fourParam  = pFOURPARAM;
            break;
        case 2:
            // 六参数转换 2
            m_sixParam = pSIXPARAM;
            break;
        case 3:
            // 七参数转换 3
            m_sevenParam = pSEVENPARAM;
            m_twoParam = pTWOPARAM;
            break;
        case 4:
        {
            //七参数+四参数转换
            SEVEN_FOUR sevenfour = pSEVEN_FOUR;
            m_fourParam.x_off = sevenfour.four_x_off;
            m_fourParam.y_off = sevenfour.four_y_off;
            m_fourParam.angle = sevenfour.four_angle;
            m_fourParam.m = sevenfour.four_m;
            m_sevenParam.x_off = sevenfour.seven_x_off;
            m_sevenParam.y_off = sevenfour.seven_y_off;
            m_sevenParam.z_off = sevenfour.seven_z_off;
            m_sevenParam.x_angle = sevenfour.seven_x_angle;
            m_sevenParam.y_angle = sevenfour.seven_y_angle;
            m_sevenParam.z_angle = sevenfour.seven_z_angle;
            m_sevenParam.m = sevenfour.seven_m;
            break;
        }
        case 5:// 二参数转换
            m_twoParam = pTWOPARAM;
            break;
        case 6://七参数+二参数反转
        {
            SEVEN_PARAM_REV sevenparamrev = pSEVEN_PARAM_REV;
            m_twoParam.x_off = sevenparamrev.x_off;
            m_twoParam.y_off = sevenparamrev.y_off;
            m_sevenParam.x_off = sevenparamrev.seven_x_off;
            m_sevenParam.y_off = sevenparamrev.seven_y_off;
            m_sevenParam.z_off = sevenparamrev.seven_z_off;
            m_sevenParam.x_angle = sevenparamrev.seven_x_angle;
            m_sevenParam.y_angle = sevenparamrev.seven_y_angle;
            m_sevenParam.z_angle = sevenparamrev.seven_z_angle;
            m_sevenParam.m = sevenparamrev.seven_m;
            break;
        }
        default:
            break;
    }
    
    
}
//高斯投影
//ellipseType 椭球类型
//middleLine 中央经线，单位：度
//B,L 纬度和经度，单位弧度
//x y 高斯投影后的平面坐标，单位：米
//x高斯平面纵轴
//y高斯平面横轴
//返回值：操作是否成功，0-失败，1-成功
short CoorTran::GaosPrj(short ellipseType, double middleLine, double B, double L, double &x, double &y)
{
    double e2 = 0.0;
    double a = 0.0;
    //e2=0.00669437999013;
    //a=6378137;
    //根据椭球类型取相应的参数
    switch (ellipseType)
    {
            //北京54椭球
        case 1:
            a = m_bjEllipse.a;
            e2 = m_bjEllipse.e2;
            break;
            //西安80椭球
        case 2:
            a = m_xaEllipse.a;
            e2 = m_xaEllipse.e2;
            break;
            //WGS-84椭球
        case 3:
            a = m_gpsEllipse.a;
            e2 = m_gpsEllipse.e2;
            break;
        default:
            break;
    }
    
    //将度转换为弧度
    double b = B;
    //DFMToRad(B,b);
    
    //计算经度差
    double l1 = 0.0;
    double mid = 0.0;
    mid = middleLine * PI / 180.0;
    l1 = L - mid;
    
    //高斯投影所需的系数
    double g = 0.0;
    g = sqrt(e2 / (1 - e2)) *cos(b);
    double g2 = 0.0, g4 = 0.0;
    g2 = g * g;
    g4 = g2 * g2;
    double t = 0.0;
    t = tan(b);
    double t2 = 0.0, t4 = 0.0;
    t2 = t * t;
    t4 = t2 * t2;
    double m = 0.0;
    m = l1 * cos(b);
    double m2 = 0.0, m3 = 0.0, m4 = 0.0, m5 = 0.0, m6 = 0.0;
    m2 = m * m;
    m3 = m2 * m;
    m4 = m3 * m;
    m5 = m4 * m;
    m6 = m5 * m;
    
    double N = 0.0;
    N = a / sqrt(1 - e2 * sin(b) * sin(b));
    //子午线弧长
    double x0 = 0.0;
    //求子午线弧长
    x0 = MeriddianArcLength(ellipseType, B, 5);
    //计算高斯平面坐标
    x = x0 + N * t * m2 / 2 + N * t * (5 - t2 + 9 * g2 + 4 * g4) * m4 / 24 + N * t * (61 - 58 * t2 + t4 + 270 * g2 - 330 * g2 * t2) * m6 / 720;
    y = N * m + N * (1 - t2 + g2) * m3 / 6 + N * (5 - 18 * t2 + 14 * g2 - 58 * g2 * t2) * m5 / 120 + 500000;
    return 1;
}
//高斯逆向投影
//ellipseType 椭球类型
//middleLine 中央经线，单位：度
//x y 高斯投影后的平面坐标，单位：米
//B,L 纬度和经度，单位弧度
//返回值：操作是否成功，0-失败，1-成功
short CoorTran::GaussProjInvCal(short ellipseType, double middleLine, double x, double y, double &B,  double &L)
{
    // 调整X,Y坐标
    y -= 500000;
    
    // 得到常数
    double a = 0.0f, e2 = 0.0f;
    double A1 = 0.0f, A2 = 0.0f, A3 = 0.0f, A4 = 0.0f;
    switch (ellipseType)
    {
            //北京54椭球
        case 1:
            a = m_bjEllipse.a;
            e2 = m_bjEllipse.e2;
            A1 = m_bjEllipse.A1;
            A2 = m_bjEllipse.A2;
            A3 = m_bjEllipse.A3;
            A4 = m_bjEllipse.A4;
            break;
            //西安80椭球
        case 2:
            a = m_xaEllipse.a;
            e2 = m_xaEllipse.e2;
            A1 = m_xaEllipse.A1;
            A2 = m_xaEllipse.A2;
            A3 = m_xaEllipse.A3;
            A4 = m_xaEllipse.A4;
            break;
            //WGS-84椭球
        case 3:
            a = m_gpsEllipse.a;
            e2 = m_gpsEllipse.e2;
            A1 = m_gpsEllipse.A1;
            A2 = m_gpsEllipse.A2;
            A3 = m_gpsEllipse.A3;
            A4 = m_gpsEllipse.A4;
            break;
        default:
            break;
    }
    
    // 计算底点纬度
    double B0 = x / A1;
    double preB0 = 0.0f;
    double eta = 0.0f;
    do
    {
        preB0 = B0;
        B0 = B0 * PI / 180.0;
        B0 = (x - (A2 * sin(2 * B0) + A3 * sin(4 * B0) + A4 * sin(6 * B0))) / A1;
        eta = fabs(B0 - preB0);
    } while (eta > 0.000000001);
    B0 = B0 * PI / 180.0;
    
    // 计算其它常数
    double sinB = sin(B0);
    double cosB = cos(B0);
    double t = tan(B0);
    double t2 = t * t;
    double N = a / sqrt(1 - e2 * sinB * sinB);
    double ng2 = cosB * cosB * e2 / (1 - e2);
    double V = sqrt(1 + ng2);
    double yN = y / N;
    
    // 得到经纬度
    double L0 = middleLine * PI / 180.0;
    B = B0 - (yN * yN - (5 + 3 * t2 + ng2 - 9 * ng2 * t2) * yN * yN * yN * yN / 12.0 + (61 + 90 * t2 + 45 * t2 * t2) * yN * yN * yN * yN * yN * yN / 360.0) * V * V * t / 2;
    L = L0 + (yN - (1 + 2 * t2 + ng2) * yN * yN * yN / 6.0 + (5 + 28 * t2 + 24 * t2 * t2 + 6 * ng2 + 8 * ng2 * t2) * yN * yN * yN * yN * yN / 120.0) / cosB;
    return 1;
}
//计算子午线弧长
//B纬度，单位：弧度，N为迭代次数
//返回值：子午线弧长
double CoorTran::MeriddianArcLength(short ellipseType, double B, int N)
{
    
    //椭球长半轴和扁率
    double a = 0.0;
    double f = 0.0;
    //椭球类型，1：54椭球，2：80椭球，3：84椭球
    switch (ellipseType)
    {
        case 1:
            a = m_bjEllipse.a;
            f = m_bjEllipse.f;
            break;
        case 2:
            a = m_xaEllipse.a;
            f = m_xaEllipse.f;
            break;
        case 3:
            a = m_gpsEllipse.a;
            f = m_gpsEllipse.f;
            break;
        default:
            break;
    }
    //将度转换为弧度
    double lat = B;
    //DFMToRad(B,lat);
    int i, n, m;
    double e2, ra, c, ff1, k, ff2, sin2;
    double *k2 = new double[5];
    for (i = 0; i < N; i++)
        k2[i] = 0.0;
    //计算椭球第一篇心率
    e2 = f * (2 - f);
    //
    ra = a * (1 - e2);
    for (c = 1.0, n = 1; n <= N; n++)
    {
        c *= (2 * n - 1.0) * (2 * n + 1.0) / (4 * n * n) * e2;
        for (m = 0; m < n; m++)
            k2[m] += c;
    }
    ff1 = 1.0 + k2[0];
    ff2 = -k2[0];
    sin2 = sin(lat) * sin(lat);
    for (k = 1.0, n = 1; n < N; n++)
    {
        k *= 2 * n / (2 * n + 1.0) * sin2;
        ff2 += -k2[n] * k;
    }
    return ra * (lat * ff1 + 0.5 * ff2 * sin(2.0 * lat));
}
//度分秒转换为弧度
//ddffmm，要转换的参数，单位ddffmm（1202532.6）
//rad，转换后的结果参数，单位：弧度
//返回值：操作是否成功，0-失败，1-成功
int CoorTran::DFMToRad(double ddffmm,  double &rad)
{
    ///*
    double degree = 0.0, minutes = 0.0, second = 0.0;
    //double tmp=0.0;
    int flag = 0;
    //判断参数的正负
    if (ddffmm < 0)
        flag = -1;
    else
        flag = 1;
    //取参数的绝对值
    ddffmm =fabs(ddffmm);
    //取度
    degree = floor(ddffmm / 10000);
    //取分
    minutes = floor((ddffmm - degree * 10000) / 100);
    //取秒
    second = ddffmm - degree * 10000 - minutes * 100;
    double dd = 0.0;
    //转换为弧度
    dd = flag * (degree + minutes / 60 + second / 3600);
    rad = dd * PI / 180.0f;
    //*/
    //rad = ddffmm * PI / 180.0f;
    return 1;
}
//弧度转为ddffmm
int CoorTran::RadToDFM(double rad,  double &ddffmm)
{
    // 转化为度
    double du = rad * 180.0f / PI;
    double degree = floor(du);
    double bigminutes = (du - degree) * 60;
    double minutes = floor(bigminutes);
    double second = (bigminutes - minutes) * 60;
    ddffmm = degree * 10000 + minutes * 100 + second;
    return 1;
}
//七参数转换
//param_7 七参数结构体
//X，Y，Z待转换的空间直角坐标，单位 米
//X1，Y1,Z1转换后的空间直角坐标，单位：米
//返回值：操作是否成功，0-失败，1-成功
short CoorTran::SevenParamTrans(SEVENPARAM param_7, double X, double Y, double Z,  double &X1,  double &Y1,double &Z1)
{
    X1 = param_7.x_off + Y * param_7.z_angle - Z * param_7.y_angle + (1 + param_7.m) * X;
    Y1 = param_7.y_off - X * param_7.z_angle + Z * param_7.x_angle + (1 + param_7.m) * Y;
    Z1 = param_7.z_off + X * param_7.y_angle - Y * param_7.x_angle + (1 + param_7.m) * Z;
    return 1;
}

//七参数转换(矩阵版)
//param_7 七参数结构体
//X，Y，Z待转换的空间直角坐标，单位 米
//X1，Y1,Z1转换后的空间直角坐标，单位：米
//返回值：操作是否成功，0-失败，1-成功
short CoorTran::SevenParamTrans_Multi(SEVENPARAM param_7, double X, double Y, double Z, double &X1,  double &Y1,  double &Z1)
{
    // 条件
    double transX = X;
    double transY = Y;
    double transZ = Z;
    
    // Xi矩阵
    NNMatrix Xi(3, 1);
    Xi.Matrix[0][0] = transX;
    Xi.Matrix[1][0] = transY;
    Xi.Matrix[2][0] = transZ;
    
    // DX矩阵
    NNMatrix DX(3, 1);
    DX.Matrix[0][0] = param_7.x_off;
    DX.Matrix[1][0] = param_7.y_off;
    DX.Matrix[2][0] = param_7.z_off;
    
    // tY矩阵
    NNMatrix tY(3, 1);
    
    // k矩阵
    NNMatrix K(1, 1);
    K.Matrix[0][0] = 1 + param_7.m;
    
    // Mx矩阵
    NNMatrix Mx (3, 3);
    // Mx.Matrix = {{1.0f,0.0f,0.0f}, {0.0f,cos(param_7.x_angle),sin(param_7.x_angle)}, {0.0f,-sin(param_7.x_angle),cos(param_7.x_angle)} };
    Mx.Matrix[0][0] =1.0f;
    Mx.Matrix[1][1] =cos(param_7.x_angle);
    Mx.Matrix[1][2] =sin(param_7.x_angle);
    Mx.Matrix[2][1] =-sin(param_7.x_angle);
    Mx.Matrix[2][2] =cos(param_7.x_angle);
    // My矩阵
    NNMatrix My(3, 3);
    //My.Matrix = {        {cos(param_7.y_angle),0.0f,-sin(param_7.y_angle)},        {0.0f,1.0f,0.0f},        {sin(param_7.y_angle),0.0f, cos(param_7.y_angle)}    };
    My.Matrix[0][0] = cos(param_7.y_angle);
    My.Matrix[0][2] = -sin(param_7.y_angle);
    My.Matrix[1][1] = 1.0f;
    My.Matrix[2][0] = sin(param_7.y_angle);
    My.Matrix[2][2] = cos(param_7.y_angle);
    // Mz矩阵
    NNMatrix Mz(3, 3);
    // Mz.Matrix = {        {cos(param_7.z_angle),sin(param_7.z_angle),0.0f},        {-sin(param_7.z_angle),cos(param_7.z_angle),0.0f},        {0.0f,0.0f,1.0f}    };
    Mz.Matrix[0][0] = cos(param_7.z_angle);
    Mz.Matrix[0][1] = sin(param_7.z_angle);
    Mz.Matrix[1][0] = -sin(param_7.z_angle);
    Mz.Matrix[1][1] = cos(param_7.z_angle);
    Mz.Matrix[2][2] =1.0f;
    
    // 计算M矩阵
    NNMatrix M(3, 3);
    M = Mz * My;
    M = M * Mx;
    // 7参数矩阵变换
    tY = Xi * K;        //缩放
    tY = M * tY;        //旋转
    tY = tY + DX;       //平移
    // 返回
    X1 = tY.Matrix[0][ 0];
    Y1 = tY.Matrix[1][ 0];
    Z1 = tY.Matrix[2][0];
    return 1;
}
//四参数转换
//param_4 四参数结构体
// x0,y0 待转换的平面直角坐标，单位：米
//x，y转换后的平面直角坐标，单位：米
//返回值：操作是否成功，0-失败，1-成功
short CoorTran::FourParamTrans(FOURPARAM param_4, double x0, double y0,  double &x,  double &y)
{
    x = param_4.x_off + (1 + param_4.m) * (x0 * cos(param_4.angle) - y0 * sin(param_4.angle));
    y = param_4.y_off + (1 + param_4.m) * (x0 * sin(param_4.angle) + y0 * cos(param_4.angle));
    return 1;
}

//六参数转换
//param_6 六参数结构体
//x0 y0 待转换的平面坐标，单位：米
//x y转换后的平面坐标，单位：米
//返回值：操作是否成功，0-失败，1-成功
short CoorTran::SixParamTrans(SIXPARAM param_6, double x0, double y0, double &x, double &y)
{
    
    x = param_6.x0_local + (1 + param_6.m) * ((x0 - param_6.x0_gps) *cos(param_6.angle) + (y0 - param_6.y0_gps) * sin(param_6.angle));
    y = param_6.y0_local + (1 + param_6.m) * ((y0 - param_6.y0_gps) * cos(param_6.angle) - (x0 - param_6.x0_gps) * sin(param_6.angle));
    return 1;
    
}
//将WGS-84椭球下的经纬度坐标转换为空间直角坐标
//B 纬度，单位，弧度
//L经度，单位：弧度
//H高程，单位：米
//X,Y,Z,单位：米
//返回值：操作是否成功，0-失败，1-成功
short CoorTran::BLH2XYZ(short ellipseType, double B, double L, double H, double &X,  double &Y,  double &Z)
{
    //根据椭球类型取相应的参数
    double a = 0.0, e2 = 0.0;
    switch (ellipseType)
    {
            //北京54椭球
        case 1:
            a = m_bjEllipse.a;
            e2 = m_bjEllipse.e2;
            break;
            //西安80椭球
        case 2:
            a = m_xaEllipse.a;
            e2 = m_xaEllipse.e2;
            break;
            //WGS-84椭球
        case 3:
            a = m_gpsEllipse.a;
            e2 = m_gpsEllipse.e2;
            break;
        default:
            break;
    }
    // 转换
    double N = 0.0;
    N = a / sqrt(1 - e2 * sin(B) * sin(B));
    X = (N + H) * cos(B) * cos(L);
    Y = (N + H) * cos(B) * sin(L);
    Z = (N * (1 - e2) + H) * sin(B);
    return 1;
}
//空间直角坐标转换为经纬度
//X,Y,Z,单位：米
//B, 纬度，单位：弧度
//L 经度，单位：弧度
//客户地图所采用的椭球类型，1为北京54椭球，2为西安80椭球
//返回值：操作是否成功，0-失败，1-成功
short CoorTran::XYZ2BL(short ellipseType, double X, double Y, double Z,  double &B,  double &L)
{
    //根据椭球类型取相应的参数
    double a = 0.0, e2 = 0.0;
    switch (ellipseType)
    {
            //北京54椭球
        case 1:
            a = m_bjEllipse.a;
            e2 = m_bjEllipse.e2;
            break;
            //西安80椭球
        case 2:
            a = m_xaEllipse.a;
            e2 = m_xaEllipse.e2;
            break;
            //WGS-84椭球
        case 3:
            a = m_gpsEllipse.a;
            e2 = m_gpsEllipse.e2;
            break;
        default:
            break;
    }
    
    // 经度arctan(y/x)
    double fResult = atan2(Y, X);
    double val = 0;
    double ang = fResult;
    while (true)
    {
        if (ang >= 0.0f && ang <= PI)
        {
            val = ang;
            break;
        }
        
        if (ang < 0.0f)
        {
            val += PI;
            break;
        }
        
        if (ang > PI)
        {
            val -= PI;
            break;
        }
    }
    fResult = val;
    L = fResult;
    
    // 纬度 atan((z+E*N*sin(B)) / sqrt(x*x + y*y))
    double eta = 0.0f, preLat = 0.0f, lat = 0.0f, fTmpL = 0.0f, fTmpR = 0.0f;
    do
    {
        preLat = lat;
        double E = e2;  //偏心率
        double N = a / sqrt(1 - e2 * sin(preLat) * sin(preLat));
        fTmpL = Z + E * N * sin(preLat);
        fTmpR = sqrt(X * X + Y * Y);
        lat = atan2(fTmpL, fTmpR);
        eta = fabs(lat - preLat);
    } while (eta > 0.000000001);
    ang = lat;
    while (true)
    {
        if (ang >= 0.0f && ang <= PI)
        {
            val = ang;
            break;
        }
        
        if (ang < 0.0f)
        {
            val += PI;
            break;
        }
        
        if (ang > PI)
        {
            val -= PI;
            break;
        }
    }
    B = val;
    
    return 1;
}

short CoorTran::InitTransParams(short transType)
{
    m_transType = transType;
    m_ellipseType = 1;   // 转换为北京54
    m_middleLine = 120;  //  此为常州 中央经线
    if (transType == 3)
    {
        m_twoParam.x_off = 3124298.95946784;
        m_twoParam.y_off = -4295215.51819202;
        
        m_sevenParam.x_off = 3124298.95946784;
        m_sevenParam.y_off = -4295215.51819202;
        m_sevenParam.z_off = 386.92943042428;
        m_sevenParam.x_angle = 7.02273911757136e-005 *PI/648000;
        m_sevenParam.y_angle = -0.00108009026703524 *PI/648000;
        m_sevenParam.z_angle = -0.673753386685497 *PI/648000;
        m_sevenParam.m = 2.82480055610832;
        /*
         m_sevenParam.x_off = 3124298.95946784;
         m_sevenParam.y_off = -4295215.51819202;
         m_sevenParam.z_off = 386.92943042428;
         m_sevenParam.x_angle = 7.02273911757136e-005 * PI / 648000;
         m_sevenParam.y_angle = -0.00108009026703524 * PI / 648000;
         m_sevenParam.z_angle = -0.673753386685497 * PI / 648000;
         m_sevenParam.m = 2.82480055610832;
         */
    }
    if (transType == 6)
    {
        m_twoParam.x_off = -2000;
        m_twoParam.y_off = -2000;
        
        m_sevenParam.x_off = -75.737629;
        m_sevenParam.y_off = -9.885620;
        m_sevenParam.z_off = -358.204988;
        m_sevenParam.x_angle = -51.11757561 * PI / 648000;
        m_sevenParam.y_angle = 67.38949678 * PI / 648000;
        m_sevenParam.z_angle = 51.52917703 * PI / 648000;
        m_sevenParam.m = 0.00000950159700;
    }
    
    return 1;
}
//坐标转换，
//B 维度单位（度分秒 ddffmm如1203036.23）L经度，单位（度分秒 ddffmm）
//x y为转换后的平面坐标，单位为 米
//返回值：操作是否成功，0-失败，1-成功
short CoorTran::CoorTrans(double B, double L, double H, double &x, double &y,double &z,short transType)
{
    double x0 = 0.0, y0 = 0.0;
    double PX = 0.0, PY = 0.0, PZ = H, X1 = 0.0, Y1 = 0.0, Z1 = H;
    double b = 0.0, l = 0.0;//h=0.0;
    z = H;
    //将度分秒转换为弧度
    if (m_transType < 6)
    {
        DFMToRad(B, b);
        DFMToRad(L, l);
    }
    else
    {
        b = B;
        l = L;
    }
    //根据转换类型进行分类处理
    //1为四参数，2六参数，3七参数(七参+2)，4：七参数+四参数,5中央经线投影，二参数
    //椭球类型：1:北京54，2：西安80，3：WGS-84 椭球
    switch (m_transType)
    {
        case 1:
        {
            //高斯投影
            GaosPrj(3, m_middleLine, b, l,  y0,  x0);
            //四参数坐标转换
            FourParamTrans(m_fourParam, x0, y0,  x,  y);
            break;
        }
        case 2:
        {
            //高斯投影
            GaosPrj(3, m_middleLine, b, l,  y0, x0);
            //六参数坐标转换
            SixParamTrans(m_sixParam, x0, y0,  x,  y);
            break;
        }
        case 3:
        {
            double t_B = 0.0, t_L = 0.0;
            
            // 空间直角坐标系  过空间定点O作三条互相垂直的数轴,它们都以O为原点,具有相同的单位长度.这三条数轴分别称为X轴(横轴).Y轴(纵轴).Z轴(竖轴),统称为坐标轴.
            // 大地坐标
            // 大地测量中以参考椭球面为基准面的坐标。地面点P的位置用大地经度L、大地纬度B和大地高H表示。当点在参考椭球面上时，仅用大地经度和大地纬度表示。大地经度是通过该点的大地子午面与起始大地子午面（通过格林尼治天文台的子午面）之间的夹角。规定以起始子午面起算，向东由0°至180°称为东经；向西由0°至180°称为西经。
            // 目前，我国经常使用的坐标系有：
            //（1）1954年北京坐标系 大地原点在苏[1]联，将与苏联大地网联测后我国东北边境的三个点的坐标作为我国天文大地网起算数据，然后通过天文大地网坐标计算，推算出北京一点的坐标，故命名为北京坐标系。
            //（2）1980年国家大地坐标系 采用1975年国际椭球，大地原点在陕西省永乐镇，椭球面与我国境内的大地水准面密合最佳。
            //（3）WGS-84坐标系 是世界大地坐标系统，其坐标原点在地心，采用WGS-84椭球。
            
            // 平面坐标  某一点在平面坐标系中的坐标分量，即纵坐标(X)，横坐标(Y)
            
            //经纬度换算为空间直角坐标
            BLH2XYZ(3, b, l, H, PX,  PY,  PZ);
            //七参数坐标转换
            //SevenParamTrans(m_sevenParam, X, Y, Z,  X1,  Y1,  Z1);
            SevenParamTrans_Multi(m_sevenParam, PX, PY, PZ,  X1,  Y1,  Z1);  // 矩阵版本
            //空间直角坐标转换为经纬度
            XYZ2BL(m_ellipseType, X1, Y1, Z1, t_B,  t_L);
            //高斯投影
            // 以中央经线为投影的对称轴，将东西各3°或1°30′的两条子午线所夹经差6°或3°的带状地区按数学法则、投影法则投影到圆柱面上，再展开成平面，即高斯-克吕格投影，简称高斯投影
            // 式中L,B是椭球面上某点的大地坐标，而X,Y是该点投影后的平面直角坐标
            GaosPrj(m_ellipseType, m_middleLine, t_B, t_L,  y, x);
            x = x + m_twoParam.x_off;
            y = y + m_twoParam.y_off;
            z = Z1;
            break;
        }
        case 4:
        {
            //经纬度转换为空间直角坐标
            BLH2XYZ(3, b, l, H,  PX, PY,  PZ);
            //七参数坐标转换
            SevenParamTrans(m_sevenParam, PX, PY, PZ,  X1,  Y1, Z1);
            //空间直角坐标转换为经纬度
            XYZ2BL(m_ellipseType, X1, Y1, Z1,  b,  l);
            //高斯投影
            GaosPrj(m_ellipseType, m_middleLine, b, l, y0,x0);
            //四参数坐标转换
            FourParamTrans(m_fourParam, x0, y0, x,  y);
            z = Z1;
            break;
        }
        case 5:
        {
            //进行高斯投影
            GaosPrj(3, m_middleLine, b, l,  y,  x);
            //偏移量
            x = x + m_twoParam.x_off;
            y = y + m_twoParam.y_off;
            break;
        }
        default:
            break;
    }
    return 1;
}
////////


//坐标转换，
//x y为转换后的平面坐标，单位为 米
//B 维度单位（度分秒 ddffmm如1203036.23）L经度，单位（度分秒 ddffmm）
//返回值：
short CoorTran::CoorTransReverse(double x, double y,double z,double &B, double &L,double &H,short transType){
    double X = x, Y = y, Z = z;
    
    // 偏移量
    X = x;
    Y = y;
    H = z;
    
    double tX0 = 0.0, tY0 = 0.0, tZ0 = 0.0;
    double tB1 = 0.0,tL1 = 0.0,tH1= 0.0,tX1= 0.0,tY1= 0.0,tZ1 = 0.0;
    double tX2 = 0.0,tY2 = 0.0,tZ2 = 0.0;
    double tB2 = 0.0,tL2 = 0.0;
    
    switch (m_transType) {
        case 1: {
            FourParamTransReverse(m_fourParam, X, Y,Z,tX0,tY0,tZ0);
            GaussProjInvCal(m_ellipseType, m_middleLine, tX0, tY0,tB1,tL1);
            H = tZ0;
            break;
        }
        case 2: {
            return 0;
        }
        case 3: {
            x = x - m_twoParam.x_off;
            y = y - m_twoParam.y_off;
            GaussProjInvCal(m_ellipseType, m_middleLine, tX0, tY0,tB1,tL1);
            BLH2XYZ(m_ellipseType, tB1, tL1, tH1,tX1,tY1,tZ1);
            SevenParamTransReverse(m_sevenParam, tX1, tY1, tZ1,tX2, tY2, tZ2);
            XYZ2BL((short)3, tX2, tY2, tZ2,tB2,tL2);
            H = tZ2;
            break;
        }
        case 4: {
            FourParamTransReverse(m_fourParam, X, Y,Z,tX0,tY0,tZ0);
            GaussProjInvCal(m_ellipseType, m_middleLine, tX0, tY0,tB1,tL1);
            BLH2XYZ(m_ellipseType, tB1, tL1, tH1,tX1,tY1,tZ1);
            SevenParamTransReverse(m_sevenParam, tX1, tY1, tZ1,tX2, tY2, tZ2);
            XYZ2BL((short)3, tX2, tY2, tZ2,tB2,tL2);
            H = tZ2;
            break;
        }
        case 5: {
            x = x - m_twoParam.x_off;
            y = y - m_twoParam.y_off;
            GaussProjInvCal(m_ellipseType, m_middleLine, tX0, tY0,tB1,tL1);
            break;
        }
        default:
        break;
    }
    double lat = tB2 * 180 / PI;
    double lon = tL2 * 180 / PI;
    
    double oB = 0.0;
    double oL = 0.0;
    RadToDFM(lat, oB);
    RadToDFM(lon, oL);
    
    B = oB;
    L = oL;
    
    return 1;
}


short CoorTran::FourParamTransReverse(FOURPARAM param_4,double x,double y,double z,double &OX ,double &OY,double &OZ) {
    // 原点矩阵
    NNMatrix X0(2, 1);
    X0.Matrix[0][0] = -param_4.x_off;
    X0.Matrix[1][0] = -param_4.y_off;
    
    // 尺度差矩阵
    NNMatrix ppm(1, 1);
    ppm.Matrix[0][0] = 1 / (1 + param_4.m);
    
    // 角度矩阵
    double ang_Cvt = param_4.angle * PI / 180.0 / 3600.0;
    NNMatrix ang_Matrix(2, 2);
    
    ang_Matrix.Matrix[0][0] = cos(ang_Cvt);
    ang_Matrix.Matrix[0][1] = sin(ang_Cvt);
    ang_Matrix.Matrix[1][0] = -sin(ang_Cvt);
    ang_Matrix.Matrix[1][1] = cos(ang_Cvt);
    
    // 入口矩阵
    NNMatrix input_Matrix(2, 1);
    input_Matrix.Matrix[0][0] = x;
    input_Matrix.Matrix[1][0] = y;
    
    // 矩阵变换
    NNMatrix out_Matrix(2, 1);
    input_Matrix = input_Matrix+X0;
    input_Matrix = input_Matrix*ppm;
    out_Matrix = ang_Matrix*input_Matrix;
    
    // 结果
    double x1 = out_Matrix.Matrix[0][0];
    double y1 = out_Matrix.Matrix[1][0];
    
    OX = x1;
    OY = y1;
    OZ = 0.0;
    return 1;
}

short CoorTran::SevenParamTransReverse(SEVENPARAM param_7, double x,double y,double z,double &OX ,double &OY,double &OZ){
    
    // Xi矩阵
    NNMatrix Xi(3, 1);
    Xi.Matrix[0][0] = x;
    Xi.Matrix[1][0] = y;
    Xi.Matrix[2][0] = z;
    // DX矩阵
    NNMatrix DX(3, 1);
    DX.Matrix[0][0] = -param_7.x_off;
    DX.Matrix[1][0] = -param_7.y_off;
    DX.Matrix[2][0] = -param_7.z_off;
    // tY矩阵
    NNMatrix tY(3, 1);
    // k值
    double K = 1.0 / (1.0 + param_7.m);
    // k矩阵
    //var K = new NNMatrix(1, 1);
    //K.Matrix[0, 0] = 1.0 / (1.0 + param_7.m);
    // Mx矩阵
    NNMatrix Mx(3, 3);
    Mx.Matrix[0][0] = 1.0;
    Mx.Matrix[0][1] = 0.0;
    Mx.Matrix[0][2] = 0.0;
    
    Mx.Matrix[1][0] = 0.0;
    Mx.Matrix[1][1] = cos(-param_7.x_angle);
    Mx.Matrix[1][2] = sin(-param_7.x_angle);
    
    Mx.Matrix[2][0] = 0.0;
    Mx.Matrix[2][1] = -sin(-param_7.x_angle);
    Mx.Matrix[2][2] = cos(-param_7.x_angle);
    
    
    // My矩阵
    NNMatrix My(3, 3);
    My.Matrix[0][0] = cos(-param_7.y_angle);
    My.Matrix[0][1] = 0.0;
    My.Matrix[0][2] = -sin(-param_7.y_angle);
    
    My.Matrix[1][0] = 0.0;
    My.Matrix[1][1] = 1.0;
    My.Matrix[1][2] = 0.0;
    
    My.Matrix[2][0] = sin(-param_7.y_angle);
    My.Matrix[2][1] = 0.0;
    My.Matrix[2][2] = cos(-param_7.y_angle);
    
    
    // Mz矩阵
    NNMatrix Mz(3, 3);
    Mz.Matrix[0][0] = cos(-param_7.z_angle);
    Mz.Matrix[0][1] = sin(-param_7.z_angle);
    Mz.Matrix[0][2] = 0.0;
    
    Mz.Matrix[1][0] = -sin(-param_7.z_angle);
    Mz.Matrix[1][1] = cos(-param_7.z_angle);
    Mz.Matrix[1][2] = 0.0;
    
    Mz.Matrix[2][0] = 0.0;
    Mz.Matrix[2][1] = 0.0;
    Mz.Matrix[2][2] = 1.0;
    
    // 计算M矩阵
    NNMatrix M(3, 3);
    M = Mz*My;
    M = M*Mx;
    // 7参数矩阵变换
    tY = Xi + DX;       //平移
    tY = M * tY;        //旋转
    tY = tY * K;        //缩放
    // 返回
    double x1 = tY.Matrix[0][0];
    double y1 = tY.Matrix[1][0];
    double z1 = tY.Matrix[2][0];
    
    OX = x1;
    OY = y1;
    OZ = z1;
    return 1;
}
