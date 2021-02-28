//
//  BaseModule.h
//
//  Created by ldd on 2020/4/28.
//  Copyright © 2020 P&C Information. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Singleton.h"

@class BaseModuleResponse;
@class BaseModuleRequest;
@class BaseModuleCallHandle;

typedef NSString *MpaasResponseCode NS_STRING_ENUM;

/// 接口调用成功
FOUNDATION_EXPORT MpaasResponseCode _Nonnull const MpaasResponseCodeSuccess;
/// 接口报错(弃用)
FOUNDATION_EXPORT MpaasResponseCode _Nonnull const MpaasResponseCodeApiFail;
/// 系统报错(弃用)
FOUNDATION_EXPORT MpaasResponseCode _Nonnull const MpaasResponseCodeSysFail;
/// 交互使用，暂不传给前端
FOUNDATION_EXPORT MpaasResponseCode _Nonnull const MpaasResponseCodeCallHandle;

/// 缺少通讯录权限
FOUNDATION_EXPORT MpaasResponseCode _Nonnull const AUTHENTIC_LACK_OF_CONTACT;
/// 缺少手机信息权限
FOUNDATION_EXPORT MpaasResponseCode _Nonnull const AUTHENTIC_LACK_OF_PHONE_INFO;
/// 缺少定位权限
FOUNDATION_EXPORT MpaasResponseCode _Nonnull const AUTHENTIC_LACK_OF_LOCATION;
/// 缺少存储权限
FOUNDATION_EXPORT MpaasResponseCode _Nonnull const AUTHENTIC_LACK_OF_STORAGE;
/// 缺少摄像头权限
FOUNDATION_EXPORT MpaasResponseCode _Nonnull const AUTHENTIC_LACK_OF_CAMERA;
/// 参数为空
FOUNDATION_EXPORT MpaasResponseCode _Nonnull const PARAM_NULL;
/// 参数不正确（参数不匹配）
FOUNDATION_EXPORT MpaasResponseCode _Nonnull const PARAM_TYPE_MISMATCH;
/// stageId为空或未注册
FOUNDATION_EXPORT MpaasResponseCode _Nonnull const PARAM_STAGE_NOT_EXIST;
/// JSON格式错误
FOUNDATION_EXPORT MpaasResponseCode _Nonnull const PARAM_JSON_FORMAT_ERROR;
/// 系统未知异常
FOUNDATION_EXPORT MpaasResponseCode _Nonnull const RUNTIME_UNKNOW;
/// 获取到空值
FOUNDATION_EXPORT MpaasResponseCode _Nonnull const RUNTIME_VALUE_NULL;
/// 当前服务不支持
FOUNDATION_EXPORT MpaasResponseCode _Nonnull const RUNTIME_SERVICE_UNSUPPORTED;
/// 用户主动取消
FOUNDATION_EXPORT MpaasResponseCode _Nonnull const RUNTIME_USER_CANCEL;
/// 网络不佳
FOUNDATION_EXPORT MpaasResponseCode _Nonnull const NETWORK_BAD;
/// IO异常
FOUNDATION_EXPORT MpaasResponseCode _Nonnull const IO_ERROR;
/// SDK调用异常
FOUNDATION_EXPORT MpaasResponseCode _Nonnull const SDK_ERROR;
/// 当前版本API不支持
FOUNDATION_EXPORT MpaasResponseCode _Nonnull const SDK_UNSUPPORTED;
/// 目标APP未安装
FOUNDATION_EXPORT MpaasResponseCode _Nonnull const SDK_TARGET_UNINSTALL;
/// 腾讯地图使用异常
FOUNDATION_EXPORT MpaasResponseCode _Nonnull const SDK_TECENT_MAP_ERROR;


NS_ASSUME_NONNULL_BEGIN

typedef void (^ModuleBResponseCallback)(BaseModuleResponse *responseData);
typedef void (^ModuleBRejectCallback)(BaseModuleResponse *rejectData);

/// Union API基类
@interface BaseModule : NSObject

SingletonH(Instance)


/// excu 指定类的指定方法
/// @param resp 调用对象的信息
/// @param responseCallback 调用回调
/// @param rejectCallback 异常回调
- (void)performTarget:(BaseModuleRequest *)resp response:(ModuleBResponseCallback )responseCallback reject:(ModuleBRejectCallback)rejectCallback;

@end


/// 请求类
@interface BaseModuleRequest : NSObject

/// 归属的业务
@property (nonatomic, copy) NSString *moduleName;

/// 业务场景对应的类
@property (nonatomic, copy) NSString *featureName;

/// 调用方法
@property (nonatomic, copy) NSString *methodName;

/// 传入数据
@property (nonatomic, strong) id requestData;

/// vue响应方法名
@property (nonatomic, copy) NSString *responseCallback;

/// 正常状态响应回调
@property (nonatomic, copy) ModuleBResponseCallback callback;

/// 异常状态响应回调
@property (nonatomic, copy) ModuleBRejectCallback rejectCallback;

/// 异常码前缀
@property (nonatomic, copy) NSString *errcodePre;

@end


/// 响应类
@interface BaseModuleResponse : NSObject

/// 错误信息 成功默认空
@property (nonatomic, copy) NSString * _Nonnull errorMsg;

/// 响应码 成功默认0
@property (nonatomic, copy) MpaasResponseCode responseCode;

/// 响应数据
@property (nonatomic, strong) id _Nullable responseData;

/// Construct 视需要使用
+ (BaseModuleResponse *)callBackMsg:(NSString *)msg responseCode:(NSString *)responseCode responseData:(id)responseData;

@end


/// 交互类
@interface BaseModuleCallHandle : NSObject

/// 执行方法
@property (nonatomic, copy) NSString * _Nonnull funcName;

/// 执行参数
@property (nonatomic, strong) id _Nullable paramData;

+(BaseModuleCallHandle *)callHandle:(NSString *)funcName paramData:(id)paramData;

@end

NS_ASSUME_NONNULL_END
