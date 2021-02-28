//
//  QKPhotoBrowser.h
//  HuaHong
//
//  Created by 华宏 on 2018/6/29.
//  Copyright © 2018年 huahong. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface QKPhotoBrowser : UIViewController

/// 初始化图片浏览器
/// @param images  数组元素可以是UIImage、Path、URL
/// @param index        当前图片的索引
- (instancetype)initWithImages:(NSArray *)images currentPage:(NSInteger)index;


@end
