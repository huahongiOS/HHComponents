//
//  HHProgressHUD.h
//  TheHousing
//
//  Created by qk-huahong on 2019/7/12.
//  Copyright © 2019 com.qk365. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MBProgressHUD+Extension.h"
#import "SVProgressHUD.h"

NS_ASSUME_NONNULL_BEGIN

@interface HHProgressHUD : NSObject

/**
 * 参数说明(下同):
 * showMessage 直接加在currentViewController.view上,若无currentVC,则加在window上
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

NS_ASSUME_NONNULL_END
