//
//  QCXCollectionViewLayout.h
//  简单的瀑布流
//
//  Created by 春晓 on 2017/11/28.
//  Copyright © 2017年 春晓. All rights reserved.
//

#import <UIKit/UIKit.h>
@class QCXCollectionViewLayout;

@protocol QCXCollectionViewLayoutDelegate <NSObject>

@optional
// 列数
- (NSInteger)columnCountInFallsLayout:(QCXCollectionViewLayout *)fallsLayout;
// 列间距
- (CGFloat)columnMarginInFallsLayout:(QCXCollectionViewLayout *)fallsLayout;
// 行间距
- (CGFloat)rowMarginInFallsLayout:(QCXCollectionViewLayout *)fallsLayout;
// collectionView边距
- (UIEdgeInsets)edgeInsetsInFallsLayout:(QCXCollectionViewLayout *)fallsLayout;
// 行高
- (CGFloat)rowHeightInFallsLayoutWithCellWidth:(CGFloat)cellWidth;
@end

@interface QCXCollectionViewLayout : UICollectionViewLayout
// 代理
@property (nonatomic , weak) id<QCXCollectionViewLayoutDelegate> delegate;
@end
