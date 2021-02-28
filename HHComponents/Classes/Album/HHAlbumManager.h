//
//  HHAlbumManager.h
//  iOS9Sample-Photos
//
//  Created by 华宏 on 2020/11/20.
//  Copyright © 2020 小码哥. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface HHAlbumManager : NSObject

+ (void)loadPhotosWithHandle:(void(^)(NSArray  <UIImage *> *))handle;

+ (void)searchAllImagesWithHandle:(void(^)(NSArray  <UIImage *> *))handle;



+ (void)saveImage1:(UIImage *)image;

+ (void)saveImage2:(UIImage *)image Album:(NSString *)albumName;

+ (void)addNewAssetWithImage:(UIImage *)image toAlbum:(NSString *)albumName;

@end

NS_ASSUME_NONNULL_END
