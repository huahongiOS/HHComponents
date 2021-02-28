//
//  CleanCacheHelp.m
//  HuaHong
//
//  Created by 华宏 on 2018/11/23.
//  Copyright © 2018年 huahong. All rights reserved.
//

#import "CleanCacheHelp.h"

@implementation CleanCacheHelp

/** 计算单个文件大小 */
+(long long)fileSizeAtPath:(NSString *)filePath
{
    NSFileManager *manager = [NSFileManager defaultManager];
    if ([manager fileExistsAtPath:filePath]) {
        NSDictionary *dic =[manager attributesOfItemAtPath:filePath error:nil];
        return [dic fileSize];
    }
    
    return 0;
}

/** 整个缓存目录的大小 */
+(float)getCacheSize
{
    //文件夹路径
    NSString *folderPath = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES)firstObject];
    
    NSFileManager *manager = [NSFileManager defaultManager];
    if (![manager fileExistsAtPath:folderPath]) {
        return 0;
    }
    
    /** 子路径:以递归的方式获取子项列表，子目录的子目录的子目录 所有的都可以拿到 */
    NSArray *subpaths = [manager subpathsAtPath:folderPath];
    
    /** 遍历器 */
    NSEnumerator *enumerator = [subpaths objectEnumerator];
    
    NSString *fileName;
    long long folderSize = 0;
    while ((fileName = [enumerator nextObject])) {
        NSString *absolutePath = [folderPath stringByAppendingPathComponent:fileName];
        folderSize += [self fileSizeAtPath:absolutePath];
    }
    
    return folderSize/(1024.0 * 1024.0);
}

/** 清理缓存 */
+(void)cleanCache:(void(^)(void))complete
{
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
     
        //文件夹路径
        NSString *directoryPath = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES)firstObject];
        
        /** 子路径:以非递归的方式获取子项列表，获取指定目录下的所有的子目录和文件 不保护孙子辈*/
        NSArray *subpaths = [[NSFileManager defaultManager] contentsOfDirectoryAtPath:directoryPath error:nil];
        
        for (NSString *subpath in subpaths) {
            NSString *filePath = [directoryPath stringByAppendingPathComponent:subpath];
            [[NSFileManager defaultManager] removeItemAtPath:filePath error:nil];
        }
        
        dispatch_async(dispatch_get_main_queue(), ^{
            complete();
        });
    });
}


+ (void)clearCache
{
    [[NSURLCache sharedURLCache] removeAllCachedResponses];
}

@end
