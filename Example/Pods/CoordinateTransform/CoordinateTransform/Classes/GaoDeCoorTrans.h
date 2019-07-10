//
//  GaoDeCoorTrans.h
//  IPipe
//
//  Created by DigitalCity on 15/6/9.
//  Copyright (c) 2015年 ZiZhengzhuan. All rights reserved.
//

#ifndef IPipe_GaoDeCoorTrans_h
#define IPipe_GaoDeCoorTrans_h
/**
 * 仅转换经度
 */
double transformLon(double x, double y);
/**
 * 仅转换纬度
 */
double transformLat(double x, double y);
/**
 * 是否超出中国范围
 */
bool outOfChina(double lat, double lon);
/**
 * 经纬度转成平面坐标
 */
CGPoint transformToXY(double wgLat, double wgLon);
/**
 * 平面坐标转成经纬度
 */
CGPoint transformToLonLat(double x, double y);
#endif
