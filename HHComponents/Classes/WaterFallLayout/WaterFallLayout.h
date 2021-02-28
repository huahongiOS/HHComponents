//
//  WaterFallLayout.h
//  HuaHong
//
//  Created by 华宏 on 2017/11/30.
//  Copyright © 2017年 huahong. All rights reserved.
//

#import <UIKit/UIKit.h>

@class WaterFallLayout;

@protocol WaterFallLayoutDelegate <NSObject>

//cell高度
- (CGFloat)WaterFallLayout:(WaterFallLayout *)layout heightForindexPath:(NSIndexPath *)indexPath itemWidth:(CGFloat)itemWidth;

////列数
//- (CGFloat)columnCountInWaterFallLayout:(WaterFallLayout *)WaterFallLayout;

@end

@interface WaterFallLayout : UICollectionViewFlowLayout

/// 列数，默认2
@property (assign,nonatomic) NSInteger columnCount;

/// 代理 
@property (nonatomic, weak) id<WaterFallLayoutDelegate> delegate;

@end

