//
//  DKVideoView.h
//  VideoTest
//
//  Created by 乔春晓 on 2018/7/15.
//  Copyright © 2018年 乔春晓. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <TXVodPlayer.h>

@interface DKVideoView : UIView
/**
 播放器
 */
@property (nonatomic, strong) TXVodPlayer *player;
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
@property (nonatomic, strong) UIProgressView *progressView;
/**
 url
 */
@property (nonatomic, strong) NSString *url;

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
