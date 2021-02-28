//
//  HHCookieManager.m
//  HuaHong
//
//  Created by 华宏 on 2020/11/15.
//  Copyright © 2020 huahong. All rights reserved.
//

#import "HHCookieManager.h"

@implementation HHCookieManager

//设置Cookie
+ (void)setCookie:(NSHTTPCookie *)cookie{
    [[NSHTTPCookieStorage sharedHTTPCookieStorage] setCookie:cookie];
}

//设置cookie
+ (void)setCookieWithName:(NSString *)cookieName value:(NSString*)cookieValue ip:(NSString*)cookieip{
    NSMutableDictionary *cookieProperties = [NSMutableDictionary dictionary];
    [cookieProperties setObject:cookieName forKey:NSHTTPCookieName];
    [cookieProperties setObject:cookieip forKey:NSHTTPCookieDomain];
    [cookieProperties setObject:cookieip forKey:NSHTTPCookieOriginURL];
    [cookieProperties setObject:@"/" forKey:NSHTTPCookiePath];
    [cookieProperties setObject:@"0" forKey:NSHTTPCookieVersion];
    [cookieProperties setObject:cookieValue forKey:NSHTTPCookieValue];
    NSHTTPCookie *cookie = [NSHTTPCookie cookieWithProperties:cookieProperties];
    [[NSHTTPCookieStorage sharedHTTPCookieStorage] setCookie:cookie];
}

//删除对应url的Cookies 对应的key
+ (void)deleteCookiesForUrl:(NSString *)url withNames:(NSArray *)names{
    NSHTTPCookieStorage *storage = [NSHTTPCookieStorage sharedHTTPCookieStorage];
    NSArray *cookieList = [storage cookiesForURL:[NSURL URLWithString:url]];
    for (NSHTTPCookie *cookie in cookieList) {
        if([names containsObject:cookie.name]){
            [storage deleteCookie:cookie];
        }
    }
}

//清除对应url的Cookies
+ (void)clearCookiesForUrl:(NSString *)url{
    NSHTTPCookieStorage *storage = [NSHTTPCookieStorage sharedHTTPCookieStorage];
    NSArray *cookieList = [storage cookiesForURL:[NSURL URLWithString:url]];
    for (NSHTTPCookie *cookie in cookieList) {
        [storage deleteCookie:cookie];
    }
}

//删除本地Cookie 对应的key
+ (void)deleteCookieswithNames:(NSArray *)names{
    NSHTTPCookieStorage *storage = [NSHTTPCookieStorage sharedHTTPCookieStorage];
    NSArray *cookieList = [storage cookies];
    for (NSHTTPCookie *cookie in cookieList) {
        if([names containsObject:cookie.name]){
            [storage deleteCookie:cookie];
        }
    }
}

//清除本地Cookie
+ (void)clearCookies{
    NSHTTPCookieStorage *storage = [NSHTTPCookieStorage sharedHTTPCookieStorage];
    NSArray *cookieList = [storage cookies];
    for (NSHTTPCookie *cookie in cookieList) {
        [storage deleteCookie:cookie];
    }
}

@end
