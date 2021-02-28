//
//  QKPrivacyTool.h
//  HuaHong
//
//  Created by 华宏 on 2020/8/9.
//  Copyright © 2020 huahong. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

/// 权限类型
typedef NS_ENUM(NSInteger, QKPrivacyType)
{
        QKPrivacyTypePhotoLibrary,     // 相册
        QKPrivacyTypeCamera,           // 摄像头
        QKPrivacyTypeLocateWhenInUse,  // 在使用期间定位
        QKPrivacyTypeLocateAlways,     // 持续定位
        QKPrivacyTypeLocateBoth,       // WhenInUse & Always
        QKPrivacyTypeMicrophone,       // 麦克风
        QKPrivacyTypeContacts,         // 通讯录
        QKPrivacyTypeBluetooth,        // 蓝牙
        QKPrivacyTypeSpeechRecognizer, // 语音识别 >= 10.0
        QKPrivacyTypeSiri,             // Siri   >= 10.0
        QKPrivacyTypeNotification,     // 通知
        QKPrivacyTypeCalendar,         // 日历
        QKPrivacyTypeReminder,         // 提醒
        QKPrivacyTypeCellularNetWork   // 网络   >= 9.0
//        QKPrivacyTypeHealth,           // 健康(暂未提供)
//        QKPrivacyTypeMotion,           // 运动(暂未提供)

};

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

/// 授权回调Block
typedef void (^CompletionHandle) (QKAuthStatus status);


@interface QKPrivacyTool : NSObject

+(instancetype)sharedManager;


/// 检查和请求对应类型的隐私权限
/// @param type 权限类型
/// @param handler 回调
- (void)requestAuthorizationWithType:(QKPrivacyType)type
                      completionHandler:(CompletionHandle)handler;


// 判断用户是否允许接收通知
+ (BOOL)isUserNotificationEnable;


/// 弹出Alert，提示去系统设置还是返回
/// @param vc 当前viewController
/// @param title Alert标题
/// @param message Alert message
//- (void)pushSettingWithCurrentVC:(UIViewController *)vc title:(NSString *)title message:(NSString *)message/* withHandle:(void(^) (NSInteger i))handler*/;

@end

NS_ASSUME_NONNULL_END
