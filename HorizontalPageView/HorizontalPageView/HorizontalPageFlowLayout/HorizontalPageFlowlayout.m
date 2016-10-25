//
//  HorizontalPageFlowlayout.m
//  HorizontanPageView
//
//  Created by CJW on 16/10/20.
//  Copyright © 2016年 Datong. All rights reserved.
//

#import "HorizontalPageFlowlayout.h"

@implementation HorizontalPageFlowlayout

#pragma mark - Public
- (void)setColumnSpacing:(CGFloat)columnSpacing rowSpacing:(CGFloat)rowSpacing edgeInsets:(UIEdgeInsets)edgeInsets
{
    self.columnSpacing = columnSpacing;
    self.rowSpacing = rowSpacing;
    self.edgeInsets = edgeInsets;
}

- (void)setRowCount:(NSInteger)rowCount itemCountPerRow:(NSInteger)itemCountPerRow
{
    self.rowCount = rowCount;
    self.itemCountPerRow = itemCountPerRow;
}

#pragma mark - 构造方法
+ (instancetype)horizontalPageFlowlayoutWithRowCount:(NSInteger)rowCount itemCountPerRow:(NSInteger)itemCountPerRow
{
    return [[self alloc] initWithRowCount:rowCount itemCountPerRow:itemCountPerRow];
}

- (instancetype)initWithRowCount:(NSInteger)rowCount itemCountPerRow:(NSInteger)itemCountPerRow
{
    self = [super init];
    if (self) {
        self.rowCount = rowCount;
        self.itemCountPerRow = itemCountPerRow;
    }
    return self;
}


#pragma mark - 重写父类方法
- (instancetype)init
{
    self = [super init];
    if (self) {
        [self setColumnSpacing:0 rowSpacing:0 edgeInsets:UIEdgeInsetsZero];
    }
    return self;
}

/** 布局前做一些准备工作 */
- (void)prepareLayout
{
    [super prepareLayout];
    
    // 从collectionView中获取到有多少个item
    NSInteger itemTotalCount = [self.collectionView numberOfItemsInSection:0];
    
    // 遍历出item的attributes,把它添加到管理它的属性数组中去
    for (int i = 0; i < itemTotalCount; i++) {
        NSIndexPath *indexpath = [NSIndexPath indexPathForItem:i inSection:0];
        UICollectionViewLayoutAttributes *attributes = [self layoutAttributesForItemAtIndexPath:indexpath];
        [self.attributesArrayM addObject:attributes];
    }
}

/** 计算collectionView的滚动范围 */
- (CGSize)collectionViewContentSize
{
    // 计算出item的宽度
    CGFloat itemWidth = (self.collectionView.frame.size.width - self.edgeInsets.left - self.itemCountPerRow * self.columnSpacing) / self.itemCountPerRow;
    // 从collectionView中获取到有多少个item
    NSInteger itemTotalCount = [self.collectionView numberOfItemsInSection:0];
    
    // 理论上每页展示的item数目
    NSInteger itemCount = self.rowCount * self.itemCountPerRow;
    // 余数（用于确定最后一页展示的item个数）
    NSInteger remainder = itemTotalCount % itemCount;
    // 除数（用于判断页数）
    NSInteger pageNumber = itemTotalCount / itemCount;
    // 总个数小于self.rowCount * self.itemCountPerRow
    if (itemTotalCount <= itemCount) {
        pageNumber = 1;
    }else {
        if (remainder == 0) {
            pageNumber = pageNumber;
        }else {
            // 余数不为0,除数加1
            pageNumber = pageNumber + 1;
        }
    }
    
    CGFloat width = 0;
    // 考虑特殊情况(当item的总个数不是self.rowCount * self.itemCountPerRow的整数倍,并且余数小于每行展示的个数的时候)
    if (pageNumber > 1 && remainder != 0 && remainder < self.itemCountPerRow) {
        width = self.edgeInsets.left + (pageNumber - 1) * self.itemCountPerRow * (itemWidth + self.columnSpacing) + remainder * itemWidth + (remainder - 1)*self.columnSpacing + self.edgeInsets.right;
    }else {
        width = self.edgeInsets.left + pageNumber * self.itemCountPerRow * (itemWidth + self.columnSpacing) - self.columnSpacing + self.edgeInsets.right;
    }
    
    // 只支持水平方向上的滚动
    return CGSizeMake(width, 0);
}

/** 设置每个item的属性(主要是frame) */
- (UICollectionViewLayoutAttributes *)layoutAttributesForItemAtIndexPath:(NSIndexPath *)indexPath
{
    NSInteger item = indexPath.item;
    // 当前item所在的页
    NSInteger pageNumber = item / (self.rowCount * self.itemCountPerRow);
    NSInteger x = item % self.itemCountPerRow + pageNumber * self.itemCountPerRow;
    NSInteger y = item / self.itemCountPerRow - pageNumber * self.rowCount;
    
    // item的宽高由行列间距和collectionView的内边距决定
    CGFloat itemWidth = (self.collectionView.frame.size.width - self.edgeInsets.left - self.itemCountPerRow * self.columnSpacing) / self.itemCountPerRow;
    CGFloat itemHeight = (self.collectionView.frame.size.height - self.edgeInsets.top - self.edgeInsets.bottom - (self.rowCount - 1) * self.rowSpacing) / self.rowCount;
    // 计算出item的坐标
    CGFloat itemX = self.edgeInsets.left + (itemWidth + self.columnSpacing) * x;
    CGFloat itemY = self.edgeInsets.top + (itemHeight + self.rowSpacing) * y;
    
    UICollectionViewLayoutAttributes *attributes = [super layoutAttributesForItemAtIndexPath:indexPath];
    // 每个item的frame
    attributes.frame = CGRectMake(itemX, itemY, itemWidth, itemHeight);
    
    return attributes;
}

/** 返回collectionView视图中所有视图的属性数组 */
- (NSArray<UICollectionViewLayoutAttributes *> *)layoutAttributesForElementsInRect:(CGRect)rect
{
    return self.attributesArrayM;
}


#pragma mark - Lazy
- (NSMutableArray *)attributesArrayM
{
    if (!_attributesArrayM) {
        _attributesArrayM = [NSMutableArray array];
    }
    return _attributesArrayM;
}

@end
