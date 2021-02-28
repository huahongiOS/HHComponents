//
//  CleanCacheHelp.h
//  HuaHong
//
//  Created by 华宏 on 2018/11/23.
//  Copyright © 2018年 huahong. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface CleanCacheHelp : NSObject

/** 整个缓存目录的大小 */
+(float)getCacheSize;

/** 清理缓存 */
+(void)cleanCache:(void(^)(void))complete;

+ (void)clearCache;

@end


