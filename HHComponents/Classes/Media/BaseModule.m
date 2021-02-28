//
//  BaseModule.m
//
//  Created by ldd on 2020/4/28.
//  Copyright © 2020 P&C Information. All rights reserved.
//

#import "BaseModule.h"

#define kPrefix @"HH"
#define kSuffix @"Module"

MpaasResponseCode const MpaasResponseCodeSuccess = @"mpaas_success";
MpaasResponseCode const MpaasResponseCodeApiFail = @"mpaas_api_fail"; //弃用
MpaasResponseCode const MpaasResponseCodeSysFail = @"mpaas_sys_fail"; //弃用
MpaasResponseCode const MpaasResponseCodeCallHandle = @"mpaas_api_callHandle";
//错误码
MpaasResponseCode const AUTHENTIC_LACK_OF_CONTACT = @"A001";
MpaasResponseCode const AUTHENTIC_LACK_OF_PHONE_INFO = @"A002";
MpaasResponseCode const AUTHENTIC_LACK_OF_LOCATION = @"A003";
MpaasResponseCode const AUTHENTIC_LACK_OF_STORAGE = @"A004";
MpaasResponseCode const AUTHENTIC_LACK_OF_CAMERA = @"A005";
MpaasResponseCode const PARAM_NULL = @"P001";
MpaasResponseCode const PARAM_TYPE_MISMATCH = @"P002";
MpaasResponseCode const PARAM_STAGE_NOT_EXIST = @"P003";
MpaasResponseCode const PARAM_JSON_FORMAT_ERROR = @"P004";
MpaasResponseCode const RUNTIME_UNKNOW = @"R001";
MpaasResponseCode const RUNTIME_VALUE_NULL = @"R002";
MpaasResponseCode const RUNTIME_SERVICE_UNSUPPORTED = @"R003";
MpaasResponseCode const RUNTIME_USER_CANCEL = @"R004";
MpaasResponseCode const NETWORK_BAD = @"N001";
MpaasResponseCode const IO_ERROR = @"I001";
MpaasResponseCode const SDK_ERROR = @"S001";
MpaasResponseCode const SDK_UNSUPPORTED = @"S002";
MpaasResponseCode const SDK_TARGET_UNINSTALL = @"S003";
MpaasResponseCode const SDK_TECENT_MAP_ERROR = @"S004";

@interface BaseModule ()

@property (nonatomic, strong) NSMutableDictionary *cachedTarget;

@end

@implementation BaseModule

SingletonM(Instance)


- (void)performTarget:(BaseModuleRequest *)resp response:(ModuleBResponseCallback )responseCallback reject:(ModuleBRejectCallback)rejectCallback
{
    // 回调传递
    resp.callback = [responseCallback copy];
    resp.rejectCallback = [rejectCallback copy];
    resp.errcodePre = [NSString stringWithFormat:@"native_%@_",resp.moduleName];
    NSString *targetClassString = [self targetClassName:resp.featureName];
    
    NSObject *target = self.cachedTarget[targetClassString];
    if (target == nil) {
        Class targetClass = NSClassFromString(targetClassString);
        target = [[targetClass alloc] init];
    }
    NSString *actionString = resp.methodName;
    SEL action = NSSelectorFromString(actionString);
    
    if (target == nil) {
        [self.cachedTarget removeObjectForKey:targetClassString];
        return ;
    }
    if (YES) {
        self.cachedTarget[targetClassString] = target;
    }
    
    if ([target respondsToSelector:action]) {
        IMP imp = [target methodForSelector:action];
        void (*func)(id, SEL, id) = (void *)imp;
        func(target, action, resp);
//        [target performSelector:action withObject:resp afterDelay:0];
    } else {
        action = NSSelectorFromString([NSString stringWithFormat:@"%@:",actionString]);
        if ([target respondsToSelector:action]) {
            IMP imp = [target methodForSelector:action];
            void (*func)(id, SEL, id) = (void *)imp;
            func(target, action, resp);
        }else {
            // 可以加上异常处理的方法调用
            [self.cachedTarget removeObjectForKey:targetClassString];
        }
    }
}

- (NSMutableDictionary *)cachedTarget
{
    if (_cachedTarget == nil) {
        _cachedTarget = [[NSMutableDictionary alloc] init];
    }
    return _cachedTarget;
}

///featureName转换为标准类名，前缀+驼峰+后缀；示例：SPDExceptionModule
- (NSString *)targetClassName:(NSString *)str
{
    if (str && str.length > 0) {
        NSString *resultStr = @"";
        resultStr = [str stringByReplacingCharactersInRange:NSMakeRange(0,1) withString:[[str substringToIndex:1] capitalizedString]];
        return [NSString stringWithFormat:@"%@%@%@",kPrefix,resultStr,kSuffix];
    } else {return @"";}
}

@end

@implementation BaseModuleRequest

@end


@implementation BaseModuleResponse

-(id)init
{
    if (self = [super init]) {
        self.errorMsg = @"";
        self.responseCode = MpaasResponseCodeSuccess;
        self.responseData = nil;
    }
    return self;
}

+ (BaseModuleResponse *)callBackMsg:(NSString *)msg responseCode:(NSString *)responseCode responseData:(id)responseData
{
    BaseModuleResponse *resp = [[BaseModuleResponse alloc] init];
    resp.errorMsg = msg;
    resp.responseCode = responseCode;
    resp.responseData = responseData;
    return resp;
}

@end


@implementation BaseModuleCallHandle

-(id)init
{
    if (self = [super init]) {
        self.funcName = @"";
        self.paramData = nil;
    }
    return self;
}

+(BaseModuleCallHandle *)callHandle:(NSString *)funcName paramData:(id)paramData
{
    BaseModuleCallHandle *handle = [[BaseModuleCallHandle alloc] init];
    handle.funcName = funcName;
    handle.paramData = paramData;
    return handle;
}

@end

