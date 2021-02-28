//
//  HHCookieManager.h
//  HuaHong
//
//  Created by 华宏 on 2020/11/15.
//  Copyright © 2020 huahong. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface HHCookieManager : NSObject

//设置Cookie
+ (void)setCookie:(NSHTTPCookie *)cookie;

//设置cookie
+ (void)setCookieWithName:(NSString *)cookieName value:(NSString*)cookieValue ip:(NSString*)cookieip;

//删除对应url的Cookies 对应的key
+ (void)deleteCookiesForUrl:(NSString *)url withNames:(NSArray *)names;

//清除对应url的Cookies
+ (void)clearCookiesForUrl:(NSString *)url;

//删除本地Cookie 对应的key
+ (void)deleteCookieswithNames:(NSArray *)names;

//清楚本地Cookie
+ (void)clearCookies;


@end

NS_ASSUME_NONNULL_END
