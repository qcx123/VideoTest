//
//  QCXCollectionViewLayout.m
//  简单的瀑布流
//
//  Created by 春晓 on 2017/11/28.
//  Copyright © 2017年 春晓. All rights reserved.
//

#import "QCXCollectionViewLayout.h"

@interface QCXCollectionViewLayout ()
// 所有的cell布局
@property (nonatomic , strong) NSMutableArray<UICollectionViewLayoutAttributes *> *attrsArray;
// 每一列的高度
@property (nonatomic , strong) NSMutableArray *columnHeights;
// 没有生成大尺寸次数
@property (nonatomic , assign) NSInteger noneDoubleTime;
// 最后一次大尺寸列数
@property (nonatomic , assign) NSInteger lastDoubleIndex;
// 最后一次对齐矫正列数
@property (nonatomic , assign) NSInteger lastFixIndex;

- (NSInteger)columnCount;     // 列数
- (CGFloat)columnMargin;    // 列边距
- (CGFloat)rowMargin;       // 行边距
- (UIEdgeInsets)edgeInsets; // collectionView边距

@end

@implementation QCXCollectionViewLayout
#pragma mark - 默认参数
static const CGFloat QCXDefaultColumnCount = 3;                     // 默认列数
static const CGFloat QCXDefaultColumnMargin = 10;                   // 默认列边距
static const CGFloat QCXDefaultRowMargin = 10;                      // 默认行边距
static const UIEdgeInsets QCXDefaultUIEdgeInsets = {10, 10, 10, 10};// 默认collectionView边距


- (void)prepareLayout{
    [super prepareLayout];
    
    // 判断如果有50个cell（首次刷新），就重新计算
    if ([self.collectionView numberOfItemsInSection:0] == 50) {
        [self.attrsArray removeAllObjects];
        [self.columnHeights removeAllObjects];
    }
    
    // 当高度数据为空时，即为第一行计算，每一列的基础高度加上collction的边框的top值
    if (!self.columnHeights.count) {
        for (int i = 0; i < self.columnCount; i++) {
            [self.columnHeights addObject:@(self.edgeInsets.top)];
        }
    }
    
    // 遍历所有的cell，计算所有cell的布局
    for (NSInteger i = self.attrsArray.count; i < [self.collectionView numberOfItemsInSection:0]; i++) {
        NSIndexPath *indexPatn = [NSIndexPath indexPathForItem:i inSection:0];
        // 计算布局属性并将结果添加到布局属性数组中
        [self.attrsArray addObject:[self layoutAttributesForItemAtIndexPath:indexPatn]];
    }
}

// 返回布局属性，一个UICollectionViewLayoutAttributes对象数组
- (NSArray<UICollectionViewLayoutAttributes *> *)layoutAttributesForElementsInRect:(CGRect)rect{
    NSLog(@"%ld",self.attrsArray.count);
    return self.attrsArray;
}

// 计算布局属性
- (UICollectionViewLayoutAttributes *)layoutAttributesForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    UICollectionViewLayoutAttributes *attrs = [UICollectionViewLayoutAttributes layoutAttributesForCellWithIndexPath:indexPath];
    
    // collectionView的宽度
    CGFloat collectionViewW = self.collectionView.frame.size.width;
    // cell的宽度
    CGFloat cellW = (collectionViewW - self.edgeInsets.left - self.edgeInsets.right - self.columnMargin * (self.columnCount - 1)) / self.columnCount;
    
    // cell的高度
    CGFloat cellH = cellW * 1.5;
    if ([_delegate respondsToSelector:@selector(rowHeightInFallsLayoutWithCellWidth:)]) {
        cellH = [_delegate rowHeightInFallsLayoutWithCellWidth:cellW];
    }
    
    // cell应该拼接的列数
    NSInteger destColumn = 0;
    
    // 高度最小的列数高度
    CGFloat minColumnHeight = [self.columnHeights[0] doubleValue];
    // 获取高度最小的列数
    for (NSInteger i = 1; i < self.columnCount; i++) {
        CGFloat columnHeight = [self.columnHeights[i] doubleValue];
        if (minColumnHeight > columnHeight) {
            minColumnHeight = columnHeight;
            destColumn = i;
        }
    }
    
    // 计算cell的x
    CGFloat x = self.edgeInsets.left + destColumn * (cellW + self.columnMargin);
    // 计算cell的y
    CGFloat y = minColumnHeight;
    if (y != self.edgeInsets.top) {
        y += self.rowMargin;
    }
    
    attrs.frame = CGRectMake(x, y, cellW, cellH);
    self.columnHeights[destColumn] = @(CGRectGetMaxY(attrs.frame));
    
    return attrs;
}

// 返回collectionView的contentSize
- (CGSize)collectionViewContentSize{
    // collectionView的contentSize的高度等于所有列高度中最大值
    CGFloat maxColumnHeight = [self.columnHeights[0] doubleValue];
    for (NSInteger i = 1; i < self.columnHeights.count; i++) {
        CGFloat columnHeight = [self.columnHeights[i] doubleValue];
        if (columnHeight > maxColumnHeight) {
            maxColumnHeight = columnHeight;
        }
    }
    return CGSizeMake(0, maxColumnHeight + self.edgeInsets.bottom);
}

#pragma mark -lazy-
- (NSMutableArray *)attrsArray{
    if (!_attrsArray) {
        _attrsArray = [NSMutableArray array];
    }
    return _attrsArray;
}

- (NSMutableArray *)columnHeights{
    if (!_columnHeights) {
        _columnHeights = [NSMutableArray array];
    }
    return _columnHeights;
}

- (CGFloat)rowMargin{
    if (_delegate && [_delegate respondsToSelector:@selector(rowMarginInFallsLayout:)]) {
        return [_delegate rowMarginInFallsLayout:self];
    }else{
        return QCXDefaultRowMargin;
    }
}

- (NSInteger)columnCount{
    if (_delegate && [_delegate respondsToSelector:@selector(columnCountInFallsLayout:)]) {
        return [_delegate columnCountInFallsLayout:self];
    }else{
        return QCXDefaultColumnCount;
    }
}

- (CGFloat)columnMargin
{
    if ([self.delegate respondsToSelector:@selector(columnMarginInFallsLayout:)]) {
        return [self.delegate columnMarginInFallsLayout:self];
    } else {
        return QCXDefaultColumnMargin;
    }
}

- (UIEdgeInsets)edgeInsets
{
    if ([self.delegate respondsToSelector:@selector(edgeInsetsInFallsLayout:)]) {
        return [self.delegate edgeInsetsInFallsLayout:self];
    } else {
        return QCXDefaultUIEdgeInsets;
    }
}


@end
