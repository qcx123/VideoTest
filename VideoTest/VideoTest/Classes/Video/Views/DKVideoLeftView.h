//
//  DKVideoLeftView.h
//  VideoTest
//
//  Created by 乔春晓 on 2018/7/16.
//  Copyright © 2018年 乔春晓. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, DKTouchItem) {
    DKTouchItemUserInfo = 0,// 点击头像或者账号
    DKTouchItemMineAttention,// 我的关注
    DKTouchItemMineCollecttion,// 我的收藏
    DKTouchItemMineMsg,// 我的消息
    DKTouchItemAccountBound,// 账户绑定
    DKTouchItemOpinionBack,// 意见反馈
    DKTouchItemSetting,// 更多设置
    DKTouchItemQuit,// 退出
    DKTouchItemCoverView// 点击或者滑动coverView
};

@class DKVideoLeftView;

@protocol DKVideoLeftViewDelegate <NSObject>
- (void)touchLeftView:(DKVideoLeftView *)leftView byType:(DKTouchItem)type;
@end

@interface DKVideoLeftView : UIView
@property (nonatomic, weak) id<DKVideoLeftViewDelegate> delegate;
/**数据显示列表**/
@property (nonatomic, strong) UITableView *tableView;
/**蒙板**/
@property (nonatomic, strong) UIView *coverView;

/*初始化并传入数据 UserInfo里面含有两个数据----acount 和 icon*/
- (instancetype)initWithFrame:(CGRect)frame withUserInfo:(NSDictionary *)userInfo;
/*开启蒙版透明度动画*/
/**
 设置alpha值
 动画是时间 duration
 **/
- (void)startCoverViewOpacityWithAlpha:(CGFloat)alpha withDuration:(CGFloat)duration;
/*取消门板透明度动画*/
- (void)cancelCoverViewOpacity;
@end
