//
//  HHCommunicationModule.m
//  HuaHong
//
//  Created by 华宏 on 2020/11/15.
//  Copyright © 2020 huahong. All rights reserved.
//

#import "HHCommunicationModule.h"
#import <CoreTelephony/CTTelephonyNetworkInfo.h>
#import <CoreTelephony/CTCarrier.h>
#import "HHBaseKit.h"
#import "BaseModule.h"

@implementation HHCommunicationModule


/// 拨打传入的电话号码，可能传入多个电话号码，原生会先根据正则匹配，获取电话号码列表并展示，用户可选择拨打任一电话号码，网点相关功能中使用

-(void)dialPhoneNumber:(BaseModuleRequest *)request{
    BaseModuleResponse *response = [BaseModuleResponse callBackMsg:@"" responseCode:MpaasResponseCodeSuccess responseData:@""];
    ModuleBResponseCallback responseCallBack = request.callback;
    
    CTTelephonyNetworkInfo *networkInfo = [[CTTelephonyNetworkInfo alloc] init];
    CTCarrier *carrier = [networkInfo subscriberCellularProvider];
    if (!carrier.isoCountryCode) {
       response.responseCode = [NSString stringWithFormat:@"%@%@",request.errcodePre,RUNTIME_SERVICE_UNSUPPORTED];
       response.errorMsg = @"您未安装SIM卡!";
       responseCallBack(response);
       return;
    }else{
        id data = request.requestData;
        NSDictionary *requestDic = [[NSDictionary alloc] init];
        if ([data isKindOfClass:[NSDictionary class]]) {
              requestDic = (NSDictionary *)data;
          }else{
              requestDic = (NSDictionary *)[data JSONValue];
          }
        if(![requestDic objectForKey:@"phoneList"]){
            BaseModuleResponse* response = [BaseModuleResponse callBackMsg:@"phoneList为空" responseCode:[NSString stringWithFormat:@"%@%@",request.errcodePre,PARAM_NULL] responseData:@""];
            request.callback(response);
            return;
        }
        
        NSString* phoneList = requestDic[@"phoneList"];
        NSArray* phoneArray = [phoneList componentsSeparatedByString:@","];
        for(NSString* phoneStr in phoneArray){
            NSString *regexString  = @"(\\d+\\-)*\\d{7,100}";
            NSPredicate *phoneTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",regexString];
            if(![phoneTest evaluateWithObject:phoneStr]){
                response.responseCode = [NSString stringWithFormat:@"%@%@",request.errcodePre,PARAM_TYPE_MISMATCH];
                response.errorMsg = @"电话号中有不符合正则的号码";
                responseCallBack(response);
                return;
            }
        }
        
        UIAlertController *alertVC = [UIAlertController alertControllerWithTitle:@"电话号码" message:nil preferredStyle:UIAlertControllerStyleActionSheet];
        for(int i=0;i<phoneArray.count;i++){
            UIAlertAction *dialMobileAction = [UIAlertAction actionWithTitle:[phoneArray objectAtIndex:i] style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                       [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[NSString stringWithFormat:@"tel://%@", [phoneArray objectAtIndex:i]]]];
                   }];
                   [alertVC addAction:dialMobileAction];
        }
        UIAlertAction *actionCancel = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
           }];
           [alertVC addAction:actionCancel];
        
        UIViewController *topRootViewController = [UIApplication sharedApplication].keyWindow.rootViewController;
        while (topRootViewController.presentedViewController)
        {
        topRootViewController = topRootViewController.presentedViewController;
        }
        [topRootViewController presentViewController:alertVC animated:YES completion:nil];
        request.callback(response);
    }
}

@end
