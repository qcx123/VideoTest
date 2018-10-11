//
//  DKVideoLeftView.m
//  VideoTest
//
//  Created by 乔春晓 on 2018/7/16.
//  Copyright © 2018年 乔春晓. All rights reserved.
//

#import "DKVideoLeftView.h"
#import "UIColor+Extension.h"

#define marginLeft 32.0f
#define TableViewMarginRightWidth 120.0f
#define RGBA(r,g,b,a) [UIColor colorWithRed:r/255.0f green:g/255.0f blue:b/255.0f alpha:a]
#define UIColorRGB(rgb) ([[UIColor alloc] initWithRed:(((rgb >> 16) & 0xff) / 255.0f) green:(((rgb >> 8) & 0xff) / 255.0f) blue:(((rgb) & 0xff) / 255.0f) alpha:1.0f])
#define LeftViewTextColor RGBA(170, 170, 170, 1)
#define NavColor UIColorRGB(0x191b27)
#define leftLeftBackColor NavColor
#define ScreenHeight [UIScreen mainScreen].bounds.size.height
#define ScreenWidth [UIScreen mainScreen].bounds.size.width

@interface DKVideoLeftView()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, strong) UIImageView *icon;
@property (nonatomic, strong) UILabel *accountLabel;

@end

@implementation DKVideoLeftView

- (instancetype)initWithFrame:(CGRect)frame{
    if ([super initWithFrame:frame]) {
        [self setUpUI];
    }
    return self;
}

#pragma mark -  设置界面
- (void)setUpUI{
    self.backgroundColor = [UIColor clearColor];
    [self coverView];
    [self tableView];
}

#pragma mark - 内部方法

- (UIView *)coverView{
    if (!_coverView) {
        _coverView = [[UIView alloc] initWithFrame:CGRectZero];
        [self addSubview:_coverView];
        _coverView.backgroundColor = [UIColor blackColor];
        _coverView.alpha = 0;
        
        [_coverView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(self.tableView.mas_right);
            make.top.bottom.mas_equalTo(0);
            make.width.mas_equalTo(TableViewMarginRightWidth + ScreenWidth);
        }];
        
        _coverView.userInteractionEnabled = YES;
        
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(clickCover:)];
        [_coverView addGestureRecognizer:tap];
        
        UISwipeGestureRecognizer *swipe = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(swipeCover:)];
        swipe.direction = UISwipeGestureRecognizerDirectionLeft;
        [_coverView addGestureRecognizer:swipe];
        
    }
    return _coverView;
}

- (UITableView *)tableView{
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectZero];
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.tableFooterView = [[UIView alloc] init];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.rowHeight = 66.0f;
        _tableView.bounces = NO;
        
        _tableView.backgroundColor = [UIColor colorWithHexString:@"#f2f2f2"];
        [self addSubview:_tableView];
        _tableView.frame = CGRectMake(0, 0, 200, ScreenHeight);
        
        UIView *headView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, _tableView.frame.size.width, 147)];
        headView.backgroundColor = [UIColor colorWithHexString:@"ffffff"];
        [self setUpHeadView:headView];
        headView.userInteractionEnabled = YES;
        _tableView.tableHeaderView = headView;
        
        UITapGestureRecognizer *icoTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapIcon:)];
        [headView addGestureRecognizer:icoTap];
    }
    return _tableView;
}

- (void)setUpHeadView:(UIView *)supView{
    //头像
    self.icon = [[UIImageView alloc] initWithFrame:CGRectZero];
    self.icon.userInteractionEnabled = YES;
    
    [supView addSubview:self.icon];
    /*在这里使用masonry控制，会爆出约束冲突，但是不影响使用，所以就不管了*/
    [self.icon mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(33);
        make.centerX.mas_equalTo(supView);
        make.width.height.mas_equalTo(64);
    }];
    self.icon.image = [UIImage imageNamed:@"btn_tx"];
    
    //账号
    self.accountLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    [supView addSubview:self.accountLabel];
    self.accountLabel.textColor = [UIColor colorWithHexString:@"#333333"];
    self.accountLabel.font = [UIFont systemFontOfSize:18];
    self.accountLabel.text = @"test";
    
    /*在这里使用masonry控制，会爆出约束冲突，但是不影响使用，所以就不管了*/
    [self.accountLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self.icon.mas_centerX);
        make.top.equalTo(self.icon.mas_bottom).mas_equalTo(0);
        make.height.mas_equalTo(30);
    }];
}


#pragma mark - UITableViewDelegate,UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return section == 0 ? 3 : 4;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"XWSLeftViewCell"];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"XWSLeftViewCell"];
        
        //设置图片
        UIImageView *headImageView = [[UIImageView alloc] initWithFrame:CGRectZero];
        headImageView.tag = indexPath.row + 100;
        [cell.contentView addSubview:headImageView];
        [headImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(26);
            make.centerY.mas_equalTo(cell.mas_centerY);
            make.width.height.mas_equalTo(19);
        }];
        
        //设置标题
        UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        [cell.contentView addSubview:titleLabel];
        titleLabel.tag = indexPath.row + 200;
        titleLabel.font = [UIFont systemFontOfSize:16];
        titleLabel.textColor = [UIColor colorWithHexString:@"#000000"];
        /*在这里使用masonry控制，会爆出约束冲突，但是不影响使用，所以就不管了*/
        [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.mas_equalTo(headImageView.mas_centerY);
            make.left.mas_equalTo(headImageView.mas_right).mas_equalTo(10);
        }];
        
        cell.backgroundColor = [UIColor colorWithHexString:@"#f2f2f2"];
    }
    
    UIImageView *iconImageView = (UIImageView *)[cell.contentView viewWithTag:indexPath.row + 100];
    
    UILabel *titleLab = (UILabel *)[cell.contentView viewWithTag:indexPath.row + 200];
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    if (indexPath.section == 0) {
        switch (indexPath.row) {
            case 0:
                iconImageView.image = [UIImage imageNamed:@"icon_wdgz"];
                titleLab.text = @"我的关注";
                break;
            case 1:
                iconImageView.image = [UIImage imageNamed:@"icon_sc"];
                titleLab.text = @"我的收藏";
                break;
            case 2:
                iconImageView.image = [UIImage imageNamed:@"icon_xx"];
                titleLab.text = @"我的消息";
                break;
                
            default:
                break;
        }
    }else{
        switch (indexPath.row) {
            case 0:
                iconImageView.image = [UIImage imageNamed:@"icon_bd"];
                titleLab.text = @"账户绑定";
                break;
            case 1:
                iconImageView.image = [UIImage imageNamed:@"icon_fk"];
                titleLab.text = @"意见反馈";
                break;
            case 2:
                iconImageView.image = [UIImage imageNamed:@"icon_sz"];
                titleLab.text = @"更多设置";
                break;
            case 3:
                iconImageView.image = [UIImage imageNamed:@"icon_tc"];
                titleLab.text = @"退出登录";
                break;
                
            default:
                break;
        }
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    DKTouchItem item = DKTouchItemUserInfo;
    if (indexPath.section == 0) {
        switch (indexPath.row) {
            case 0:
                item = DKTouchItemMineAttention;
                break;
            case 1:
                item = DKTouchItemMineCollecttion;
                break;
            case 2:
                item = DKTouchItemMineMsg;
                break;
                
            default:
                break;
        }
    }else{
        switch (indexPath.row) {
            case 0:
                item = DKTouchItemAccountBound;
                break;
            case 1:
                item = DKTouchItemOpinionBack;
                break;
            case 2:
                item = DKTouchItemSetting;
                break;
            case 3:
                item = DKTouchItemQuit;
                break;
                
            default:
                break;
        }
    }
    
    if ([self.delegate respondsToSelector:@selector(touchLeftView:byType:)]) {
        [self.delegate touchLeftView:self byType:item];
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return section == 0 ? 0 : 40;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, tableView.width, 40)];
    UIView *lineView = [[UIView alloc] init];
    lineView.backgroundColor = [UIColor lightGrayColor];
    [headerView addSubview:lineView];
    
    [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(headerView).mas_offset(26);
        make.top.mas_equalTo(headerView).mas_offset(17);
        make.right.mas_equalTo(headerView);
        make.height.mas_equalTo(0.5);
    }];
    return headerView;
}

#pragma mark - 手势操作
//点击蒙版
- (void)clickCover:(UITapGestureRecognizer *)tap{
    if ([self.delegate respondsToSelector:@selector(touchLeftView:byType:)]) {
        [self.delegate touchLeftView:self byType:DKTouchItemCoverView];
    }
}
//向左滑动蒙版
- (void)swipeCover:(UISwipeGestureRecognizer *)tap{
    if ([self.delegate respondsToSelector:@selector(touchLeftView:byType:)]) {
        [self.delegate touchLeftView:self byType:DKTouchItemCoverView];
    }
}

//点击头像或者账号
- (void)tapIcon:(UITapGestureRecognizer *)tap{
    if ([self.delegate respondsToSelector:@selector(touchLeftView:byType:)]) {
        [self.delegate touchLeftView:self byType:DKTouchItemUserInfo];
    }
}

#pragma mark - 动画
- (void)startCoverViewOpacityWithAlpha:(CGFloat)alpha withDuration:(CGFloat)duration{
    CABasicAnimation *opacityAnimation = [CABasicAnimation animationWithKeyPath:@"opacity"];
    opacityAnimation.fromValue = [NSNumber numberWithFloat:0];
    opacityAnimation.toValue = [NSNumber numberWithFloat:alpha];
    opacityAnimation.duration = duration;
    opacityAnimation.removedOnCompletion = NO;
    opacityAnimation.fillMode = kCAFillModeForwards;
    [_coverView.layer addAnimation:opacityAnimation forKey:@"opacity"];
    _coverView.alpha = alpha;
}

- (void)cancelCoverViewOpacity{
    [_coverView.layer removeAllAnimations];
    _coverView.alpha = 0;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
