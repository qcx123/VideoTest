//
//  DKGameVideoListCell.m
//  VideoTest
//
//  Created by 乔春晓 on 2018/8/27.
//  Copyright © 2018年 乔春晓. All rights reserved.
//

#import "DKGameVideoListCell.h"
#import "QCXCollectionViewLayout.h"
#import "DKVideoListInfo.h"
#import "UIButton+DKFont.h"

@interface DKGameVideoListCell ()<UICollectionViewDelegate,UICollectionViewDataSource,QCXCollectionViewLayoutDelegate>
/**
 collectionView
 */
@property (nonatomic, strong) UICollectionView *collectionView;
@end

static NSString *collectionViewCell = @"collectionViewCell";

@implementation DKGameVideoListCell{
    
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self setupUI];
    }
    return self;
}

- (void)setupUI{
    QCXCollectionViewLayout *layout = [[QCXCollectionViewLayout alloc] init];
    layout.delegate = self;
    _collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, KScreenW, KScreenH - 64) collectionViewLayout:layout];
    [self.contentView addSubview:_collectionView];
    [_collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.right.bottom.mas_equalTo(self.contentView);
    }];
    _collectionView.scrollEnabled = NO;
    _collectionView.backgroundColor = [UIColor whiteColor];
    _collectionView.delegate = self;
    _collectionView.dataSource = self;
    
    [self.collectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:collectionViewCell];
    
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return 100;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:collectionViewCell forIndexPath:indexPath];
    cell.contentView.backgroundColor = [UIColor cyanColor];
    return cell;
}

// 列数
- (NSInteger)columnCountInFallsLayout:(QCXCollectionViewLayout *)fallsLayout{
    return ColumnCount;
}
// 列间距
- (CGFloat)columnMarginInFallsLayout:(QCXCollectionViewLayout *)fallsLayout{
    return ColumnMargin;
}
// 行间距
- (CGFloat)rowMarginInFallsLayout:(QCXCollectionViewLayout *)fallsLayout{
    return RowMargin;
}
// collectionView边距
- (UIEdgeInsets)edgeInsetsInFallsLayout:(QCXCollectionViewLayout *)fallsLayout{
    return UIEdgeInsetsMake(10, EdgeLeftRight, 10, EdgeLeftRight);
}
// 行高
- (CGFloat)rowHeightInFallsLayoutWithCellWidth:(CGFloat)cellWidth{
    return RowHeight;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
