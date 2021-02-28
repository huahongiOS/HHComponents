//
//  QRCodeTool.h
//  HuaHong
//
//  Created by 华宏 on 2020/2/16.
//  Copyright © 2020 huahong. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 二维码工具
 */
@interface QRCodeTool : NSObject

typedef NS_ENUM(NSUInteger, CodeStyle) {
    QRCode,  //二维码
    BarCode, //条形码
};

//MARK: - 生成 二维码/条形码

/// 生成 二维码/条形码
/// @param stringValue 内容
/// @param size 尺寸
/// @param codeStyle 条码类型
/// @param qrColor 二维码颜色  nil：默认颜色
/// @param backgroundColor 背景颜色 nil：默认颜色
+ (UIImage* )createCodeImage:(NSString*)stringValue CodeStyle:(CodeStyle)codeStyle Size:(CGSize)size QRColor:(UIColor*)qrColor backgroundColor:(UIColor*)backgroundColor;

// 合成图片（code+logo）
+ (UIImage *)combinateCodeImage:(UIImage *)codeImage andLogo:(UIImage *)logo;


// 创建条形码
//
// @param dataValue 条形码存储值
// @param superVie superVie 的size
// @return image
// */
//+ (UIImage *)creatTiaoXingMaWithValue:(NSString *)dataValue size:(CGSize)size;

@end
