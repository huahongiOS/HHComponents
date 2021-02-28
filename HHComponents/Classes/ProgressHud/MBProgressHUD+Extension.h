//
//  MBProgressHUD+Extension.h
//  HuaHong
//
//  Created by 华宏 on 2018/11/26.
//  Copyright © 2018年 huahong. All rights reserved.
//
#import "MBProgressHUD.h"
#import "UIViewController+MBProgressHUD.h"

@interface MBProgressHUD (Extension)

/**
 * 参数说明(下同):
 * showMessage直接加在currentViewController.view上,若无currentVC,则加在window上
 * message 提示信息
 * view HUD的父视图,若view==nil,则view==window
 */

//MARK: - 警告提示信息
+ (void)showMessage:(NSString *_Nonnull)message;
+ (void)showMessage:(NSString *_Nonnull)message toView:(UIView *_Nullable)view;

//MARK: - 成功提示信息
+ (void)showSuccess:(NSString *_Nonnull)message;
+ (void)showSuccess:(NSString *_Nonnull)message toView:(UIView *_Nullable)view;

//MARK: - 失败提示信息
+ (void)showError:(NSString *_Nonnull)message;
+ (void)showError:(NSString *_Nonnull)message toView:(UIView *_Nullable)view;

//MARK: - 显示加载框
+ (void)showLoading:(NSString *_Nonnull)message;
+ (void)showLoading:(NSString *_Nonnull)message toView:(UIView *_Nullable)view;

//MARK: - 隐藏加载框
+ (void)hideHUD;
+ (void)hideHUDForView:(UIView *_Nullable)view;

@end
