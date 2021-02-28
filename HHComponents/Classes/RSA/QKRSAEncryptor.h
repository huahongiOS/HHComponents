//
//  RSAEncryptor.h
//  QKPublic
//
//  Created by qk365 on 2017/9/7.
//  Copyright © 2017年 qk365. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Security/Security.h>

@interface QKRSAEncryptor : NSObject
    /**
     *  加密方法
     *
     *  @param str    需要加密的字符串
     *  @param pubKey 公钥字符串
     */
+ (NSString *)encryptString:(NSString *)str publicKey:(NSString *)pubKey;
    
    /**
     *  解密方法
     *
     *  @param str     需要解密的字符串
     *  @param privKey 私钥字符串
     */
+ (NSString *)decryptString:(NSString *)str privateKey:(NSString *)privKey;


@end
