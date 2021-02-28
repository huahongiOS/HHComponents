//
//  KeyChainStore.h
//  RequestDemo
//
//  Created by 雷雷 on 2017/11/27.
//  Copyright © 2017年 雷雷. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface QKKeyChainStore : NSObject

+ (void)qk_save:(NSString *)service data:(id)data;
+ (id)qk_load:(NSString *)service;
+ (void)qk_deleteKeyData:(NSString *)service;

@end
