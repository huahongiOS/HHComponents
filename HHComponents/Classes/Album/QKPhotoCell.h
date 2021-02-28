//
//  QKPhotoCell.h
//  HuaHong
//
//  Created by 华宏 on 2017/12/4.
//  Copyright © 2017年 huahong. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface QKPhotoCell : UICollectionViewCell


/// 图片内容
@property (strong,nonatomic) UIImageView *contentImgView;

/// 右上角是否选中
@property (strong,nonatomic) UIImageView *checkView;

@end
