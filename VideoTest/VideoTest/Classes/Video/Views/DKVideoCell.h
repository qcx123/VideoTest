//
//  DKVideoCell.h
//  VideoTest
//
//  Created by 乔春晓 on 2018/7/16.
//  Copyright © 2018年 乔春晓. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <TXVodPlayer.h>
#import "VideoInfoModel.h"
#import "DKProgramView.h"

@protocol DKVideoCellDelegate <NSObject>
- (void)netSign;
- (void)playStateChange:(NSInteger)state;
- (void)shareVideo:(VideoInfoModel *)model;// 分享
- (void)likeVideo:(VideoInfoModel *)model; // 点赞
- (void)downLoadVideo:(VideoInfoModel *)model;// 下载
@end

@interface DKVideoCell : UICollectionViewCell
@property (nonatomic, strong) TXVodPlayer *player;
@property (nonatomic, weak) id<DKVideoCellDelegate> delegate;
@property (nonatomic, assign) BOOL isPlaying;
@property (nonatomic, strong) VideoInfoModel *model;
/**
 是否预加载
 */
@property (nonatomic, assign) BOOL isAutoPlay;
/**
 背景图
 */
@property (nonatomic, strong) UIImageView *bgImgView;
/**
 进度条
 */
@property (nonatomic, strong) DKProgramView *progressView;

- (int)startPlay:(NSString *)url;

- (int)play;

/* stopPlay 停止播放音视频流
 * 返回: 0 = OK
 */
- (int)stopPlay;

/* isPlaying 是否正在播放
 * 返回： YES 拉流中，NO 没有拉流
 */
- (bool)isPlaying;

/* pause 暂停播放
 *
 */
- (void)pause;

/* resume 继续播放
 *
 */
- (void)resume;
@end
