//
//  HHAlbumModule.m
//  PNCBank
//
//  Created by LTC on 2020/7/2.
//  Copyright © 2020 P&C Information. All rights reserved.
//

#import "HHAlbumModule.h"
#import <Photos/Photos.h>
#import "HHBaseKit.h"
#import "BaseModule.h"

@interface HHAlbumModule (){
    BaseModuleRequest *resRequest;
}
@end

@implementation HHAlbumModule

/// 保存到相册
/// @param resp 请求信息
- (void)saveToAlbum:(BaseModuleRequest *)resp {
    resRequest = resp;
    
    id data = resp.requestData;
    NSDictionary *dict;
    if ([data isKindOfClass:[NSDictionary class]]) {
        dict = (NSDictionary *)data;
    } else {
        dict = (NSDictionary *)[data JSONValue];
    }
    
    NSString *imageStr = dict[@"imgBase64"];
    if (!imageStr || imageStr.length == 0) {
        resp.callback([BaseModuleResponse callBackMsg:@"图片base64数据为空" responseCode:[NSString stringWithFormat:@"%@%@",resp.errcodePre,PARAM_NULL] responseData:@{}]);
        return;
    }
    // 将base64字符串转为NSData
    NSData *imageData = [[NSData alloc] initWithBase64EncodedString:imageStr options:(NSDataBase64DecodingIgnoreUnknownCharacters)];
    __block UIImage *img = [UIImage imageWithData:imageData];
    
    NSArray *array = [dict[@"path"] componentsSeparatedByString:@"/"];
    NSUInteger count = array.count;
    __block NSString *album = array[count-1];
    
    //申请相册权限
    PHAuthorizationStatus photoStatus = [PHPhotoLibrary authorizationStatus];
    if (photoStatus == PHAuthorizationStatusNotDetermined) {
        [PHPhotoLibrary requestAuthorization:^(PHAuthorizationStatus status) {
            if (status == PHAuthorizationStatusAuthorized) {
                //用户第一次允许访问相册
                dispatch_async(dispatch_get_main_queue(), ^{
                    [self addNewAssetWithImage:img toAlbum:album];
                });
            } else if (status == PHAuthorizationStatusDenied){
                //用户第一次拒绝访问相册
                dispatch_async(dispatch_get_main_queue(), ^{
                    resp.callback([BaseModuleResponse callBackMsg:@"缺少存储权限" responseCode:[NSString stringWithFormat:@"%@%@",resp.errcodePre,AUTHENTIC_LACK_OF_STORAGE] responseData:@{}]);
                });
            }
        }];
    } else if (photoStatus == PHAuthorizationStatusAuthorized) {//已经允许
        dispatch_async(dispatch_get_main_queue(), ^{
            [self addNewAssetWithImage:img toAlbum:album];
        });
    } else if (photoStatus == PHAuthorizationStatusDenied) {//已经拒绝访问
        dispatch_async(dispatch_get_main_queue(), ^{
            resp.callback([BaseModuleResponse callBackMsg:@"缺少存储权限" responseCode:[NSString stringWithFormat:@"%@%@",resp.errcodePre,AUTHENTIC_LACK_OF_STORAGE] responseData:@{}]);
        });
    } else {//PHAuthorizationStatusRestricted
        //系统原因，无法访问(没有被授权访问相册，可能是家长控制权限)
        dispatch_async(dispatch_get_main_queue(), ^{
            resp.callback([BaseModuleResponse callBackMsg:@"缺少存储权限" responseCode:[NSString stringWithFormat:@"%@%@",resp.errcodePre,AUTHENTIC_LACK_OF_STORAGE] responseData:@{}]);
        });
    }
}

// image:保存相册的图片 album:相册名称(没有则创建该相册)
- (void)addNewAssetWithImage:(UIImage *)image toAlbum:(NSString *)album {
    [[PHPhotoLibrary sharedPhotoLibrary] performChanges:^{
        // 请求通过一个图片创建一个资源。
        PHAssetChangeRequest *createAssetRequest = [PHAssetChangeRequest creationRequestForAssetFromImage:image];
         // 请求编辑这个相册。
        PHAssetCollectionChangeRequest *albumChangeRequest = [self photoCollectionWithAlbumName:album];
         // 得到一个新的资源的占位对象并添加它到相册编辑请求中。
        PHObjectPlaceholder *assetPlaceholder = [createAssetRequest placeholderForCreatedAsset];
        [albumChangeRequest addAssets:@[assetPlaceholder]];
     } completionHandler:^(BOOL success, NSError *error) {
         if (success) {
             self->resRequest.callback([BaseModuleResponse callBackMsg:@"图片保存成功" responseCode:MpaasResponseCodeSuccess responseData:@{}]);
         } else {
             self->resRequest.callback([BaseModuleResponse callBackMsg:@"图片保存失败" responseCode:[NSString stringWithFormat:@"%@%@",self->resRequest.errcodePre,RUNTIME_UNKNOW] responseData:@{}]);
         }
    }];
}

// albumName:相册名称，没有则创建该相册
- (PHAssetCollectionChangeRequest *)photoCollectionWithAlbumName:(NSString *)albumName {
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
