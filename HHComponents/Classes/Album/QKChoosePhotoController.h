//
//  QKChoosePhotoController.h
//  HuaHong
//
//  Created by 华宏 on 2017/12/4.
//  Copyright © 2017年 huahong. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^finishChoiseBlock)(NSArray <UIImage *> *photos);

@interface QKChoosePhotoController : UIViewController


/// 最多选几张，默认1张
@property (nonatomic,assign) NSInteger maxImageCount;


/// 完成回调
@property (nonatomic,copy) finishChoiseBlock finishBlock;

@end
