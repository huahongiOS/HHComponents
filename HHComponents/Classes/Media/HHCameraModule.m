//
//  SPDVideoModule.m
//  PNCBank
//
//  Created by LTC on 2020/6/16.
//  Copyright © 2020 P&C Information. All rights reserved.
//

#import "HHCameraModule.h"
#import <AVFoundation/AVCaptureMetadataOutput.h>
#import "HHBaseKit.h"
#import "BaseModule.h"

@interface HHCameraModule () <AVCaptureMetadataOutputObjectsDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate>
{
    ModuleBResponseCallback responseCallBack;
    BaseModuleResponse *responseData;
}
@end

@implementation HHCameraModule

/// 摄像机
/// @param resp 请求信息
- (void)captureCamera:(BaseModuleRequest *)resp
{
    responseCallBack = resp.callback;
    responseData = [[BaseModuleResponse alloc] init];
    
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypePhotoLibrary]) {
        UIImagePickerController *picker = [[UIImagePickerController alloc] init];
        picker.delegate = self;
        picker.allowsEditing = YES;
        ///拍照
        picker.sourceType = UIImagePickerControllerSourceTypeCamera;
        [[Util rootNav] presentViewController:picker animated:YES completion:nil];
        
    } else {
        responseData.responseCode = responseData.responseCode = [NSString stringWithFormat:@"native_%@_%@", @"camera", AUTHENTIC_LACK_OF_CAMERA];
        responseData.responseData = @"本应用需要打开相机权限，请您允许或打开设置修改应用程序的权限。";
        responseCallBack(responseData);
    }
}

#pragma mark - UIImagePickerControllerDelegate
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info{
    if([[UIDevice currentDevice].systemVersion floatValue] >= 8.0){
        ///获取选中的照片
        UIImage *image = info[UIImagePickerControllerEditedImage];
        
        if (!image) {
            image = info[UIImagePickerControllerOriginalImage];
        }
        NSData *imageData = UIImageJPEGRepresentation(image, 1);
        NSString *imageString = [imageData base64EncodedString];

        [picker dismissViewControllerAnimated:YES completion:^{
            self->responseData.responseCode = MpaasResponseCodeSuccess;
            self->responseData.responseData = @{@"imgBase": imageString};
            self->responseCallBack(self->responseData);
        }];
    }
}

@end
