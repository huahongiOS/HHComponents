//
//  WaterFallLayout.m
//  HuaHong
//
//  Created by 华宏 on 2017/11/30.
//  Copyright © 2017年 huahong. All rights reserved.
//

#import "WaterFallLayout.h"

/** 默认的列数 */
static const NSInteger DefaultColumnCount = 2;

@interface WaterFallLayout()
/** 存放所有cell的布局属性 */
@property (nonatomic, strong) NSMutableArray *attrsArray;
/** 存放所有列的当前高度 */
@property (nonatomic, strong) NSMutableArray *columnHeights;
/** 内容的高度 */
@property (nonatomic, assign) CGFloat contentHeight;

@end

@implementation WaterFallLayout

#pragma mark - 常见数据处理

//- (NSInteger)columnCount
//{
//    if ([self.delegate respondsToSelector:@selector(columnCountInWaterFallLayout:)]) {
//        return [self.delegate columnCountInWaterFallLayout:self];
//    } else {
//        return XMGDefaultColumnCount;
//    }
//}

#pragma mark - 懒加载
- (NSMutableArray *)columnHeights
{
    if (!_columnHeights) {
        _columnHeights = [NSMutableArray array];
    }
    return _columnHeights;
}

- (NSMutableArray *)attrsArray
{
    if (!_attrsArray) {
        _attrsArray = [NSMutableArray array];
    }
    return _attrsArray;
}

/**
 * 初始化
 */

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.columnCount = DefaultColumnCount;
    }
    
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)coder
{
    self = [super initWithCoder:coder];
    if (self) {
        self.columnCount = DefaultColumnCount;
    }
    
    return self;
    
}
- (void)prepareLayout
{
     [super prepareLayout];
        
    //先初始化内容的高度为0
     self.contentHeight = 0;
    
    // 清除以前计算的所有高度
    [self.columnHeights removeAllObjects];
    
    // 清除之前所有的布局属性
    [self.attrsArray removeAllObjects];
    
    //先初始化  存放所有列的当前高度 columnCount个值
    for (NSInteger i = 0; i < self.columnCount; i++) {
        [self.columnHeights addObject:@(self.sectionInset.top)];
    }

    
    // 开始创建每一个cell对应的布局属性
    NSInteger count = [self.collectionView numberOfItemsInSection:0];
    for (NSInteger i = 0; i < count; i++) {
        
        NSIndexPath *indexPath = [NSIndexPath indexPathForItem:i inSection:0];
        // 获取indexPath位置cell对应的布局属性
        UICollectionViewLayoutAttributes *attrs = [self layoutAttributesForItemAtIndexPath:indexPath];
        [self.attrsArray addObject:attrs];
    }
}


/**
 * 返回indexPath位置cell对应的布局属性
 */
- (UICollectionViewLayoutAttributes *)layoutAttributesForItemAtIndexPath:(NSIndexPath *)indexPath
{
    // 创建布局属性
    UICollectionViewLayoutAttributes *attrs = [UICollectionViewLayoutAttributes layoutAttributesForCellWithIndexPath:indexPath];
    
    // collectionView的宽度
    CGFloat collectionViewW = self.collectionView.frame.size.width;
    
    // 设置布局属性的frame
    CGFloat width = (collectionViewW - self.sectionInset.left - self.sectionInset.right - (self.columnCount - 1) * self.minimumInteritemSpacing) / self.columnCount;
    CGFloat height = 0;
    if ([self.delegate respondsToSelector:@selector(WaterFallLayout:heightForindexPath:itemWidth:)]) {
        height = [self.delegate WaterFallLayout:self heightForindexPath:indexPath itemWidth:width];
    }
    
    //找出来最短后 就把下一个cell 添加到底下
    NSInteger index = 0;
    CGFloat minColumnHeight = [self.columnHeights[0] floatValue];
    for (NSInteger i = 0; i < self.columnCount; i++) {
        // 取得第i列的高度
        CGFloat columnHeight = [self.columnHeights[i] floatValue];
        
        //找出最高的高度
        self.contentHeight = MAX(self.contentHeight, columnHeight);
        
        // 找出最短的那一列
        index = (minColumnHeight <= columnHeight) ? index : i;
        minColumnHeight = MIN(minColumnHeight, columnHeight);
        
        
    }
    
    CGFloat x = self.sectionInset.left + index * (width + self.minimumInteritemSpacing);
    CGFloat y = minColumnHeight;
    if (y != self.sectionInset.top) {
        y += self.minimumLineSpacing;
    }
    attrs.frame = CGRectMake(x, y, width, height);
    
    // 更新最短那列的高度
    self.columnHeights[index] = @(CGRectGetMaxY(attrs.frame));
   
    
    return attrs;
}

/**
 * 决定cell的排布
 */
- (NSArray *)layoutAttributesForElementsInRect:(CGRect)rect
{
    return self.attrsArray;
}

- (CGSize)collectionViewContentSize
{
    return CGSizeMake(0, self.contentHeight + self.sectionInset.bottom);
}

@end

