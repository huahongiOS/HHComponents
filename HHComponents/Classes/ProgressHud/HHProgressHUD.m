//
//  HHProgressHUD.m
//  TheHousing
//
//  Created by qk-huahong on 2019/7/12.
//  Copyright © 2019 com.qk365. All rights reserved.
//

#import "HHProgressHUD.h"

#define kUseMBProgress 0  //快速切换 0:SVProgressHUD, 1:MBProgressHUD
@implementation HHProgressHUD

//MARK: - 提醒信息
+ (void)showMessage:(NSString *)message
{
    if (kUseMBProgress) {
           [MBProgressHUD showMessage:message];
       }else
       {
           [SVProgressHUD showInfoWithStatus:message];
       }
}
+ (void)showMessage:(NSString *)message toView:(UIView *)view
{
    if (kUseMBProgress) {
        [MBProgressHUD showMessage:message toView:view];
    }else
    {
        [SVProgressHUD showInfoWithStatus:message];
    }
}

//MARK: - 成功信息
+ (void)showSuccess:(NSString *)message
{
    if (kUseMBProgress) {
        [MBProgressHUD showSuccess:message];
    }else
    {
        [SVProgressHUD showSuccessWithStatus:message];
    }
}
+ (void)showSuccess:(NSString *)message toView:(UIView *)view
{
    if (kUseMBProgress) {
        [MBProgressHUD showSuccess:message toView:view];
    }else
    {
        [SVProgressHUD showSuccessWithStatus:message];
    }
}

//MARK: - 错误信息
+ (void)showError:(NSString *)message
{
    if (kUseMBProgress) {
        [MBProgressHUD showError:message];
    }else
    {
        [SVProgressHUD showErrorWithStatus:message];
    }
}

+ (void)showError:(NSString *)message toView:(UIView *)view
{
    if (kUseMBProgress) {
        [MBProgressHUD showError:message toView:view];
    }else
    {
        [SVProgressHUD showErrorWithStatus:message];
    }
}

//MARK: - 显示加载框
+ (void)showLoading:(NSString *)message
{
    if (kUseMBProgress) {
        [MBProgressHUD showLoading:message];
    }else
    {
        [SVProgressHUD showWithStatus:message];
    }
}
+ (void)showLoading:(NSString *)message toView:(UIView *)view
{
    if (kUseMBProgress) {
        [MBProgressHUD showLoading:message toView:view];
    }else
    {
        [SVProgressHUD showWithStatus:message];
    }
}

//MARK: - 隐藏加载框
+ (void)hideHUD
{
    if (kUseMBProgress) {
        [MBProgressHUD hideHUD];
    }else
    {
        [SVProgressHUD dismiss];
    }
}
+ (void)hideHUDForView:(UIView *)view
{
    if (kUseMBProgress) {
        [MBProgressHUD hideHUDForView:view];
    }else
    {
        [SVProgressHUD dismiss];
    }
}

@end
