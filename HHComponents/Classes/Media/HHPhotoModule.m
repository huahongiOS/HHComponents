//
//  SPDElbumModule.m
//  PNCBank
//
//  Created by LTC on 2020/6/16.
//  Copyright © 2020 P&C Information. All rights reserved.
//

#import "HHPhotoModule.h"
#import <AVFoundation/AVCaptureMetadataOutput.h>
#import "HHBaseKit.h"
#import "BaseModule.h"

@interface HHPhotoModule ()<AVCaptureMetadataOutputObjectsDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate>
{
    ModuleBResponseCallback responseCallBack;
    BaseModuleResponse *responseData;
}
@end

@implementation HHPhotoModule

/// 打开相册
/// @param resp 请求信息
- (void)capturePhoto:(BaseModuleRequest *)resp {
    responseCallBack = resp.callback;
    responseData = [[BaseModuleResponse alloc] init];
    
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypePhotoLibrary]) {
        UIImagePickerController *picker = [[UIImagePickerController alloc] init];
        picker.delegate = self;
        picker.allowsEditing = YES;
        ///打开相册选择照片
        picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        [[Util rootNav] presentViewController:picker animated:YES completion:nil];
    } else {
        responseData.responseCode = [NSString stringWithFormat:@"native_%@_%@", @"photo", AUTHENTIC_LACK_OF_CAMERA];
        responseData.responseData = @"本应用需要打开相机权限，请您允许或打开设置修改应用程序的权限。";
        responseCallBack(responseData);
    }
}

#pragma mark - UIImagePickerControllerDelegate
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    if ([[UIDevice currentDevice].systemVersion floatValue] >= 8.0) {
        ///获取选中的照片
        UIImage *image = info[UIImagePickerControllerEditedImage];
        
        if (!image) {
            image = info[UIImagePickerControllerOriginalImage];
        }
        NSData *MaximageData = UIImageJPEGRepresentation(image, 1);
        NSString *imageString = [MaximageData base64EncodedString];

        [picker dismissViewControllerAnimated:YES completion:^{
            self->responseData.responseCode = MpaasResponseCodeSuccess;
            self->responseData.responseData = @{@"imgBase": imageString};
            self->responseCallBack(self->responseData);
        }];
    }
}

@end
