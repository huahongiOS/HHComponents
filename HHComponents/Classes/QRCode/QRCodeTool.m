//
//  QRCodeTool.m
//  HuaHong
//
//  Created by 华宏 on 2020/2/16.
//  Copyright © 2020 huahong. All rights reserved.
//

#import "QRCodeTool.h"
#import <AVFoundation/AVFoundation.h>
#import <CoreImage/CoreImage.h>

#define FILTERNAME @"CIQRCodeGenerator"

@implementation QRCodeTool

//MARK: - 生成 二维码/条形码

/// 生成 二维码/条形码
/// @param stringValue 内容
/// @param size 尺寸
/// @param codeStyle 条码类型
/// @param qrColor 二维码颜色  nil：默认颜色
/// @param backgroundColor 背景颜色 nil：默认颜色
+ (UIImage* )createCodeImage:(NSString*)stringValue CodeStyle:(CodeStyle)codeStyle Size:(CGSize)size QRColor:(UIColor*)qrColor backgroundColor:(UIColor*)backgroundColor
{
    if (stringValue == nil || stringValue.length == 0) {
        return nil;
    }
    
    NSData *data = data = [stringValue dataUsingEncoding: NSUTF8StringEncoding];
    NSString *filterName = codeStyle == QRCode ? @"CIQRCodeGenerator" : @"CICode128BarcodeGenerator";
    
    CIFilter *qrFilter = [CIFilter filterWithName:filterName];
    [qrFilter setDefaults];
    [qrFilter setValue:data forKey:@"inputMessage"];
    
//    [qrFilter setValue:@"H" forKey:@"inputCorrectionLevel"];
    
//    设置生成的条形码的上，下，左，右的margins的值
//    [qrFilter setValue:[NSNumber numberWithInteger:0] forKey:@"inputQuietSpace"];
    
    //上色
    CIFilter *colorFilter;
    if (qrColor && backgroundColor) {
        //    qrColor = qrColor ?: UIColor.blackColor;
        //    backgroundColor = backgroundColor ?: UIColor.whiteColor;

        colorFilter = [CIFilter filterWithName:@"CIFalseColor"
                                           keysAndValues:
                                 @"inputImage",qrFilter.outputImage,
                                 @"inputColor0",[CIColor colorWithCGColor:qrColor.CGColor],
                                 @"inputColor1",[CIColor colorWithCGColor:backgroundColor.CGColor],
                                 nil];
    }

    CIImage *qrImage = colorFilter ? colorFilter.outputImage : qrFilter.outputImage;
    
    return [self createImageWithCIImage:qrImage Size:size];
}


//MARK: - 绘制图片
+ (UIImage *)createImageWithCIImage:(CIImage *)ciImage Size:(CGSize)size
{
    if (ciImage == nil) {
        return nil;
    }
    
    CGImageRef cgImage = [[CIContext contextWithOptions:nil] createCGImage:ciImage fromRect:ciImage.extent];
//    UIGraphicsBeginImageContext(size);
    UIGraphicsBeginImageContextWithOptions(size, NO, 0);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetInterpolationQuality(context, kCGInterpolationNone);
    CGContextScaleCTM(context, 1.0, -1.0);
    CGContextDrawImage(context, CGContextGetClipBoundingBox(context), cgImage);
    UIImage *codeImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    CGImageRelease(cgImage);
    
    return codeImage;

}

//MARK: - <#mark#>
// 合成图片（code+logo）
+ (UIImage *)combinateCodeImage:(UIImage *)codeImage andLogo:(UIImage *)logo {
    
    UIGraphicsBeginImageContextWithOptions(codeImage.size, YES, [UIScreen mainScreen].scale);
    
    // 将codeImage画到上下文中
    [codeImage drawInRect:(CGRect){.0, .0, codeImage.size.width, codeImage.size.height}];
    
    // 定义logo的绘制参数
    CGFloat logoSide = fminf(codeImage.size.width, codeImage.size.height) / 4;
    CGFloat logoX = (codeImage.size.width - logoSide) / 2;
    CGFloat logoY = (codeImage.size.height - logoSide) / 2;
    CGRect logoRect = (CGRect){logoX, logoY, logoSide, logoSide};
    UIBezierPath *cornerPath = [UIBezierPath bezierPathWithRoundedRect:logoRect cornerRadius:logoSide / 5];
    [cornerPath setLineWidth:2.0];
    [[UIColor whiteColor] set];
    [cornerPath stroke];
    [cornerPath addClip];
    
    // 将logo画到上下文中
    [logo drawInRect:logoRect];
    
    // 从上下文中读取image
    codeImage = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    
    return codeImage;
}


//+ (UIImage *)createNonInterpolatedUIImageFormCIImage:(CIImage *)image withSize:(CGFloat) size {
//
//    CGRect extent = CGRectIntegral(image.extent);
//    CGFloat scale = MIN(size/CGRectGetWidth(extent), size/CGRectGetHeight(extent));
//        // 1.创建bitmap;
//    size_t width = CGRectGetWidth(extent) * scale;
//    size_t height = CGRectGetHeight(extent) * scale;
//    CGColorSpaceRef cs = CGColorSpaceCreateDeviceGray();
//    CGContextRef bitmapRef = CGBitmapContextCreate(nil, width, height, 8, 0, cs, (CGBitmapInfo)kCGImageAlphaNone);
//
//    CIContext *context = [CIContext contextWithOptions:nil];
//    CGImageRef bitmapImage = [context createCGImage:image fromRect:extent];
//    CGContextSetInterpolationQuality(bitmapRef, kCGInterpolationNone);
//    CGContextScaleCTM(bitmapRef, scale, scale);
//    CGContextDrawImage(bitmapRef, extent, bitmapImage);
//         // 2.保存bitmap到图片
//    CGImageRef scaledImage = CGBitmapContextCreateImage(bitmapRef);
//    CGContextRelease(bitmapRef);
//    CGImageRelease(bitmapImage);
//    return [UIImage imageWithCGImage:scaledImage];
//}

//+ (UIImage *)resizeCodeImage:(CIImage *)image withSize:(CGSize)size
//{
//    CGRect extent = CGRectIntegral(image.extent);
//    CGFloat scaleWidth = size.width/CGRectGetWidth(extent);
//    CGFloat scaleHeight = size.height/CGRectGetHeight(extent);
//    size_t width = CGRectGetWidth(extent) * scaleWidth;
//    size_t height = CGRectGetHeight(extent) * scaleHeight;
//    CGColorSpaceRef colorSpaceRef = CGColorSpaceCreateDeviceGray();
//    CGContextRef contentRef = CGBitmapContextCreate(nil, width, height, 8, 0, colorSpaceRef, (CGBitmapInfo)kCGImageAlphaNone);
//    CIContext *context = [CIContext contextWithOptions:nil];
//
//    CGImageRef imageRef = [context createCGImage:image fromRect:extent];
//    CGContextSetInterpolationQuality(contentRef, kCGInterpolationNone);
//    CGContextScaleCTM(contentRef, scaleWidth, scaleHeight);
//    CGContextDrawImage(contentRef, extent, imageRef);
//    CGImageRef imageRefResized = CGBitmapContextCreateImage(contentRef);
//    CGContextRelease(contentRef);
//    CGImageRelease(imageRef);
//    return [UIImage imageWithCGImage:imageRefResized];
//
//}

////条形码
//+ (UIImage *)creatTiaoXingMaWithValue:(NSString *)dataValue size:(CGSize)size{
//
//    UIImage *image = [QRCodeTool createCodeImage:dataValue CodeStyle:BarCode Size:size QRColor:nil backgroundColor:nil];
//
//    return  [QRCodeTool text:dataValue addToView:image];;
//}

////条形码图片添加文字
//+ (UIImage*)text:(NSString*)text addToView:(UIImage*)image
//{
//    UIFont*font = [UIFont fontWithName:@"Arial-BoldItalicMT"size:13];
//    NSDictionary*dict =@{NSFontAttributeName:font,NSForegroundColorAttributeName:[UIColor blackColor]};
//    CGSize textSize = [text sizeWithAttributes:dict];
//
//    UIGraphicsBeginImageContextWithOptions(image.size, NO, [[UIScreen mainScreen] scale]);
//
//    //绘制图片
//    [image drawInRect:CGRectMake(5,5, image.size.width - 10, image.size.height*0.8 - textSize.height)];
//
//    //绘制文字
//    CGRect rectt = CGRectMake((image.size.width-textSize.width)/2, image.size.height*0.8, textSize.width, textSize.height);
//    [text drawInRect:rectt withAttributes:dict];
//
//    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
//    UIGraphicsEndImageContext();
//
//    return newImage;
//}

@end
