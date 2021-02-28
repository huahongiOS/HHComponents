//
//  QKLocationManager.h
//  HuaHong
//
//  Created by 华宏 on 2017/11/23.
//  Copyright © 2017年 huahong. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>

/// 授权状态
typedef NS_ENUM(NSInteger, QKAuthStatus)
{
    /** 用户未决定，首次访问会提示用户进行授权 */
    QKAuthStatusNotDetermined  = 0,
    /** 已授权 */
    QKAuthStatusAuthorized     = 1,
    /** 拒绝 */
    QKAuthStatusDenied         = 2,
    /** 应用没有相关权限，且当前用户无法改变这个权限，比如:家长控制 */
    QKAuthStatusRestricted     = 3,
    /** 硬件等不支持 */
    QKAutStatusNotSupport     = 4,
    /** 首次申请被拒绝----alert是系统弹框 */
    QKAuthStatusDenied_system    = 5
    
};

@interface QKLocationManager : NSObject

+ (instancetype)sharedManager;

//MARK: - 定位权限
- (void)requestAuthWithCompletionHandler:(void(^)(QKAuthStatus status))handler;

/// 开启定位
/// @param complate 完成回调
- (void)startLocation:(void(^)(double longitude,double latitude,CLPlacemark *placemark))complate;

/// 停止定位
- (void)stopLocation;

/// 计算一个坐标与我当前定位点的距离
/// @param latitude 纬度
/// @param longitude 经度
/// @complate 返回两点之间的距离，单位：米
- (void)distanceFromMyLocation:(double)latitude longitude:(double)longitude complate:(void(^)(CLLocationDistance distance))complate;

/// 计算两点间距离
/// @param latitude1 纬度1
/// @param longitude1 经度1
/// @param latitude2 纬度2
/// @param longitude2 经度2
/// @return 两点之间的距离，单位：米
- (CLLocationDistance)distanceFromLatitude1:(double)latitude1 longitude1:(double)longitude1 latitude2:(double)latitude2 longitude2:(double)longitude2;
@end
