//
//  DKGameMsgCell.m
//  VideoTest
//
//  Created by 乔春晓 on 2018/8/27.
//  Copyright © 2018年 乔春晓. All rights reserved.
//

#import "DKGameMsgCell.h"
#import "UIView+Frame.h"
#import "UILabel+MBCategory.h"

@interface DKGameMsgCell ()
/**
 背景视图
 */
@property (nonatomic, strong) UIView *bgView;
/**
 头部图片
 */
@property (nonatomic, strong) UIImageView *topImgView;
/**
 icon
 */
@property (nonatomic, strong) UIImageView *icon;
/**
 标题
 */
@property (nonatomic, strong) UILabel *titleLabel;
/**
 游戏信息
 */
@property (nonatomic, strong) UILabel *msgLabel;
/**
 标签数组
 */
@property (nonatomic, strong) NSMutableArray *signArray;
/**
 下载按钮
 */
@property (nonatomic, strong) UIButton *downLoadBtn;
/**
 游戏介绍
 */
@property (nonatomic, strong) UILabel *introduceLabel;
/**
 查看完整介绍按钮
 */
@property (nonatomic, strong) UIButton *allIntroduceBtn;
@end

@implementation DKGameMsgCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.signArray = [NSMutableArray array];
        [self setupUI];
    }
    return self;
    
}

- (void)setupUI {
    _bgView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 100, 100)];
    _bgView.backgroundColor = [UIColor cyanColor];
    _bgView.layer.masksToBounds = YES;
    _bgView.layer.cornerRadius = 8;
    [self.contentView addSubview:_bgView];
    
    _topImgView = [[UIImageView alloc] init];
    _topImgView.backgroundColor = [UIColor redColor];
    [_bgView addSubview:_topImgView];
    
    _icon = [[UIImageView alloc] init];
    _icon.image = [UIImage imageNamed:@"btn_tx"];
    [_bgView addSubview:_icon];
    
    _titleLabel = [[UILabel alloc] init];
    _titleLabel.text = @"飞人学院";
    [_bgView addSubview:_titleLabel];
    
    _msgLabel = [[UILabel alloc] init];
    _msgLabel.text = @"厂商：多酷游戏 | 版本号：V1.5.1 | 28M";
    [_bgView addSubview:_msgLabel];
    
    _downLoadBtn = [UIButton buttonWithType:(UIButtonTypeCustom)];
    [_downLoadBtn setTitle:@"下载" forState:(UIControlStateNormal)];
    _downLoadBtn.backgroundColor = [UIColor blueColor];
    [_bgView addSubview:_downLoadBtn];
    _downLoadBtn.frame = CGRectMake(0, 0, 60, 40);
    _downLoadBtn.layer.masksToBounds = YES;
    _downLoadBtn.layer.cornerRadius = 20;
    
    
    UILabel *inLabel = [[UILabel alloc] init];
    inLabel.text = @"游戏介绍";
    [_bgView addSubview:inLabel];
    
    _introduceLabel = [[UILabel alloc] init];
    _introduceLabel.numberOfLines = 3;
    _introduceLabel.text = @"游戏介绍游戏介绍游戏介绍游戏介绍游戏介绍游戏介绍游戏介绍游戏介绍游戏介绍游戏介绍游戏介绍游戏介绍游戏介绍游戏介绍游戏介绍游戏介绍游戏介绍游戏介绍游戏介绍游戏介绍游戏介绍游戏介绍游戏介绍游戏介绍游戏介绍游戏介绍游戏介绍游戏介绍游戏介绍游戏介绍游戏介绍游戏介绍游戏介绍游戏介绍游戏介绍游戏介绍游戏介绍游戏介绍游戏介绍游戏介绍游戏介绍游戏介绍游戏介绍游戏介绍游戏介绍游戏介绍游戏介绍游戏介绍游戏介绍游戏介绍游戏介绍游戏介绍游戏介绍游戏介绍游戏介绍游戏介绍游戏介绍游戏介绍游戏介绍游戏介绍游戏介绍游戏介绍游戏介绍游戏介绍游戏介绍游戏介绍游戏介绍游戏介绍游戏介绍游戏介绍游戏介绍游戏介绍";
//    [UILabel changeLineSpaceForLabel:_introduceLabel WithSpace:1];
    
    [_bgView addSubview:_introduceLabel];
    
    _allIntroduceBtn = [UIButton buttonWithType:(UIButtonTypeCustom)];
    [_allIntroduceBtn setTitle:@"查看完整介绍" forState:(UIControlStateNormal)];
    _allIntroduceBtn.backgroundColor = [UIColor blueColor];
    [_bgView addSubview:_allIntroduceBtn];
    
    [_bgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.mas_equalTo(self.contentView).mas_offset(15);
        make.right.bottom.mas_equalTo(self.contentView).mas_offset(-15);
    }];
    
    [_topImgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.right.mas_equalTo(self.bgView);
        make.height.mas_equalTo(150);
    }];
    
    [_icon mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.bgView).mas_offset(20);
        make.centerY.mas_equalTo(self.topImgView.mas_bottom);
        make.width.height.mas_equalTo(70);
    }];
    
    [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.icon.mas_right).mas_offset(15);
        make.right.mas_equalTo(self.bgView);
        make.height.mas_equalTo(35);
        make.top.mas_equalTo(self.icon);
    }];

    [_msgLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.icon.mas_right).mas_offset(15);
        make.right.mas_equalTo(self.bgView);
        make.height.mas_equalTo(35);
        make.bottom.mas_equalTo(self.icon);
    }];

    [_downLoadBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.icon.mas_bottom).mas_offset(10);
        make.right.mas_equalTo(self.bgView).mas_offset(-20);
        make.width.mas_equalTo(60);
        make.height.mas_equalTo(40);
    }];

    [inLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.bgView).mas_offset(20);
        make.right.mas_equalTo(self.bgView).mas_offset(-20);
        make.top.mas_equalTo(self.downLoadBtn.mas_bottom).mas_offset(20);
        make.height.mas_equalTo(30);
    }];

    [self.introduceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.bgView).mas_offset(20);
        make.right.mas_equalTo(self.bgView).mas_offset(-20);
        make.top.mas_equalTo(inLabel.mas_bottom).mas_offset(10);
        make.height.mas_equalTo(80);
    }];

    [self.allIntroduceBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.introduceLabel.mas_bottom);
        make.bottom.mas_equalTo(self.bgView);
        make.width.mas_offset(150);
        make.centerX.mas_equalTo(self.bgView);
    }];

    UIButton *lastBtn = nil;
    for (int i = 0; i < 3; i++) {
        UIButton *btn = [UIButton buttonWithType:(UIButtonTypeCustom)];
        [btn setTitle:@"烧脑" forState:(UIControlStateNormal)];
        [self.bgView addSubview:btn];
        btn.frame = CGRectMake(0, 0, 40, 20);
        btn.layer.masksToBounds = YES;
        btn.layer.cornerRadius = 3;
        btn.enabled = NO;
        btn.backgroundColor = [UIColor lightGrayColor];
//        btn.layer.masksToBounds = YES;
//        btn.layer.cornerRadius = 10;
        [btn setTitleColor:[UIColor darkGrayColor] forState:(UIControlStateNormal)];
        [btn mas_makeConstraints:^(MASConstraintMaker *make) {
            if (lastBtn == nil) {
                make.left.mas_equalTo(self.bgView).mas_offset(20);
            }else{
                make.left.mas_equalTo(lastBtn.mas_right).mas_offset(10);
            }
            make.top.mas_equalTo(self.icon.mas_bottom).mas_offset(20);
            make.width.mas_equalTo(40);
            make.height.mas_equalTo(20);
        }];
        lastBtn = btn;
        [self.signArray addObject:btn];
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
