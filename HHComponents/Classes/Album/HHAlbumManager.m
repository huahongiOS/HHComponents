//
//  HHAlbumManager.m
//  iOS9Sample-Photos
//
//  Created by 华宏 on 2020/11/20.
//  Copyright © 2020 小码哥. All rights reserved.
//

#import "HHAlbumManager.h"
#import <Photos/Photos.h>

@implementation HHAlbumManager

//MARK: - 加载图片
+ (void)loadPhotosWithHandle:(void(^)(NSArray  <UIImage *> *))handle
{

    [PHPhotoLibrary requestAuthorization:^(PHAuthorizationStatus status) {
      if (status != PHAuthorizationStatusAuthorized) return;
        
       NSMutableArray *arrayM = [NSMutableArray array];
    
       dispatch_async(dispatch_get_main_queue(), ^{
           
//           PHFetchResult<PHAssetCollection *> *collections = [PHAssetCollection fetchAssetCollectionsWithType:PHAssetCollectionTypeSmartAlbum subtype:PHAssetCollectionSubtypeAlbumRegular options:nil];
           
//           if (collections.count != 0) {
               
               //获取资源时的参数
               PHFetchOptions *options = [[PHFetchOptions alloc] init];
               //按时间排序
               options.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"creationDate" ascending:YES]];
               //所有照片
               PHFetchResult *allPhotos = [PHAsset fetchAssetsWithOptions:options];
               
               
               for (NSInteger i = 0; i < allPhotos.count; i++) {
                   
                   PHAsset *asset = allPhotos[i];
                   if (asset.mediaType == PHAssetMediaTypeImage)
                   {
                       [self requestImageForAsset:asset handle:^(UIImage *image) {
                           if (image) {
                               [arrayM addObject:image];
                           }
                           
                       }];

                   }
                   
               }
               
               handle(arrayM.copy);

//           }
       });
        
    }];
}

// 将PHAsset转成UIImage
+ (void)requestImageForAsset:(PHAsset *)asset handle:(void(^)(UIImage *image))handle

{
    PHImageRequestOptions *options = [[PHImageRequestOptions alloc] init];
    options.synchronous = true;
    options.deliveryMode = PHImageRequestOptionsDeliveryModeHighQualityFormat;
    options.networkAccessAllowed = YES;
    options.progressHandler = ^(double progress, NSError *error, BOOL *stop, NSDictionary *info) {
    };
    
    [[PHImageManager defaultManager] requestImageForAsset:asset targetSize:[UIScreen mainScreen].bounds.size contentMode:PHImageContentModeAspectFit options:options resultHandler:^(UIImage *result, NSDictionary *info) {
        
        handle(result);
    }];
}

#pragma mark - 查询相册中的图片
/**
 * 查询所有的图片
 */
+ (void)searchAllImagesWithHandle:(void(^)(NSArray  <UIImage *> *))handle {
    // 判断授权状态
    [PHPhotoLibrary requestAuthorization:^(PHAuthorizationStatus status) {
        if (status != PHAuthorizationStatusAuthorized) return;
        
        NSMutableArray *arrayM = [NSMutableArray array];

        dispatch_async(dispatch_get_main_queue(), ^{
            // 遍历所有的自定义相册
            PHFetchResult<PHAssetCollection *> *collections = [PHAssetCollection fetchAssetCollectionsWithType:PHAssetCollectionTypeSmartAlbum subtype:PHAssetCollectionSubtypeAlbumRegular options:nil];
            for (PHAssetCollection *collection in collections) {
                [self searchAllImagesInCollection:collection Handle:^(UIImage *image) {
                    if (image) {
                        [arrayM addObject:image];
                    }
                }];
            }
            
            handle(arrayM);
        });
    }];
}

/**
 * 查询某个相册里面的所有图片
 */
+ (void)searchAllImagesInCollection:(PHAssetCollection *)collection Handle:(void(^)(UIImage *))handle
{
    
    NSLog(@"相册名字：%@", collection.localizedTitle);//相机胶卷 @"Camera Roll"
    
    if (!([collection.localizedTitle isEqualToString:@"相机胶卷"] || [collection.localizedTitle isEqualToString:@"Camera Roll"])) {
        return;
    }

    // 采取同步获取图片（只获得一次图片）
    PHImageRequestOptions *imageOptions = [[PHImageRequestOptions alloc] init];
    imageOptions.synchronous = YES;
    imageOptions.deliveryMode = PHImageRequestOptionsDeliveryModeHighQualityFormat;
//    imageOptions.networkAccessAllowed = YES;
//    imageOptions.progressHandler = ^(double progress, NSError *error, BOOL *stop, NSDictionary *info) {
//    };
    
    
    
    PHFetchOptions *options = [[PHFetchOptions alloc] init];
    //按时间排序
    options.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"creationDate" ascending:YES]];
    
    // 遍历这个相册中的所有图片
    PHFetchResult<PHAsset *> *assetResult = [PHAsset fetchAssetsInAssetCollection:collection options:options];
    for (PHAsset *asset in assetResult) {
        // 过滤非图片
        if (asset.mediaType != PHAssetMediaTypeImage) continue;
        
        // 图片原尺寸
        CGSize targetSize = CGSizeMake(asset.pixelWidth, asset.pixelHeight);
        // 请求图片
        [[PHImageManager defaultManager] requestImageForAsset:asset targetSize:targetSize contentMode:PHImageContentModeDefault options:imageOptions resultHandler:^(UIImage * _Nullable result, NSDictionary * _Nullable info) {
            
            handle(result);
//            NSLog(@"图片：%@ %@", result, [NSThread currentThread]);
        }];
    }
}



//MARK: - 保存图片到相册

+(void)saveimage0:(UIImage *)image
{
   UIImageWriteToSavedPhotosAlbum(image, self, @selector(image:didFinishSavingWithError:contextInfo:),@"identifier");
}

- (void)image:(UIImage *)image didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo
{
    
    if(!error)
    {
        NSLog(@"保存成功:%@",contextInfo);
    }
}

+ (void)saveImage1:(UIImage *)image
{
    [PHPhotoLibrary requestAuthorization:^(PHAuthorizationStatus status) {
           if (status != PHAuthorizationStatusAuthorized) return;
        
        dispatch_async(dispatch_get_main_queue(), ^{
            
            [[PHPhotoLibrary sharedPhotoLibrary] performChanges:^{
                [PHAssetChangeRequest creationRequestForAssetFromImage:image];
            } completionHandler:^(BOOL success, NSError * _Nullable error) {

            }];
        });
        
        
    }];
}

+ (void)saveImage2:(UIImage *)image Album:(NSString *)albumName
{
    // 判断授权状态
    [PHPhotoLibrary requestAuthorization:^(PHAuthorizationStatus status) {
        if (status != PHAuthorizationStatusAuthorized) return;
        
        dispatch_async(dispatch_get_main_queue(), ^{
            NSError *error = nil;
    
            // 保存相片到相机胶卷
            __block PHObjectPlaceholder *createdAsset = nil;
            [[PHPhotoLibrary sharedPhotoLibrary] performChangesAndWait:^{
                createdAsset = [PHAssetCreationRequest creationRequestForAssetFromImage:image].placeholderForCreatedAsset;
            } error:&error];
            
            if (error) {
                NSLog(@"保存失败：%@", error);
                return;
            }
            
            // 拿到自定义的相册对象
            PHAssetCollection *collection = [self collection:albumName];
            if (collection == nil) return;
            
            [[PHPhotoLibrary sharedPhotoLibrary] performChangesAndWait:^{
                [[PHAssetCollectionChangeRequest changeRequestForAssetCollection:collection] insertAssets:@[createdAsset] atIndexes:[NSIndexSet indexSetWithIndex:0]];
            } error:&error];
            
            if (error) {
                NSLog(@"保存失败：%@", error);
            } else {
                NSLog(@"保存成功");
            }
        });
    }];
}

/**
 * 获得自定义的相册对象
 */
+ (PHAssetCollection *)collection:(NSString *)albumName
{
    // 先从已存在相册中找到自定义相册对象
    PHFetchResult<PHAssetCollection *> *collectionResult = [PHAssetCollection fetchAssetCollectionsWithType:PHAssetCollectionTypeAlbum subtype:PHAssetCollectionSubtypeAlbumRegular options:nil];
    for (PHAssetCollection *collection in collectionResult) {
        if ([collection.localizedTitle isEqualToString:albumName]) {
            return collection;
        }
    }
    
    // 新建自定义相册
    __block NSString *collectionId = nil;
    NSError *error = nil;
    [[PHPhotoLibrary sharedPhotoLibrary] performChangesAndWait:^{
        collectionId = [PHAssetCollectionChangeRequest creationRequestForAssetCollectionWithTitle:albumName].placeholderForCreatedAssetCollection.localIdentifier;
    } error:&error];
    
    if (error) {
        NSLog(@"获取相册【%@】失败", albumName);
        return nil;
    }
    
    return [PHAssetCollection fetchAssetCollectionsWithLocalIdentifiers:@[collectionId] options:nil].lastObject;
}


//MARK: - 

// image:保存相册的图片 album:相册名称(没有则创建该相册)
+ (void)addNewAssetWithImage:(UIImage *)image toAlbum:(NSString *)albumName {
    [[PHPhotoLibrary sharedPhotoLibrary] performChanges:^{
        // 请求通过一个图片创建一个资源。
        PHAssetChangeRequest *createAssetRequest = [PHAssetChangeRequest creationRequestForAssetFromImage:image];
         // 请求编辑这个相册。
        PHAssetCollectionChangeRequest *albumChangeRequest = [self photoCollectionWithAlbumName:albumName];
         // 得到一个新的资源的占位对象并添加它到相册编辑请求中。
        PHObjectPlaceholder *assetPlaceholder = [createAssetRequest placeholderForCreatedAsset];
        [albumChangeRequest addAssets:@[assetPlaceholder]];
     } completionHandler:^(BOOL success, NSError *error) {
         
    }];
}

// albumName:相册名称，没有则创建该相册
+ (PHAssetCollectionChangeRequest *)photoCollectionWithAlbumName:(NSString *)albumName {
    // 创建搜索集合
    PHFetchResult *result = [PHAssetCollection fetchAssetCollectionsWithType:PHAssetCollectionTypeAlbum subtype:PHAssetCollectionSubtypeAlbumRegular options:nil];
    
    // 遍历相册，获取对应相册的changeRequest
    for (PHAssetCollection *assetCollection in result) {
        if ([assetCollection.localizedTitle containsString:albumName]) {
            PHAssetCollectionChangeRequest *collectionRuquest = [PHAssetCollectionChangeRequest changeRequestForAssetCollection:assetCollection];
            return collectionRuquest;
        }
    }
    
    // 不存在，创建albumName为名的相册changeRequest
    PHAssetCollectionChangeRequest *collectionRequest = [PHAssetCollectionChangeRequest creationRequestForAssetCollectionWithTitle:albumName];
    return collectionRequest;
}


@end
