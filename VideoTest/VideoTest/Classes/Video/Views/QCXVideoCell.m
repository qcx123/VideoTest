//
//  QCXVideoCell.m
//  VideoTest
//
//  Created by 乔春晓 on 2018/7/13.
//  Copyright © 2018年 乔春晓. All rights reserved.
//

#import "QCXVideoCell.h"

@interface QCXVideoCell ()

@property (nonatomic, strong) UIView *playerView;
@property (nonatomic, strong) UIView *controlView;
@end

@implementation QCXVideoCell

- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        [self.contentView addSubview:self.playerView];
        [self.contentView addSubview:self.controlView];
        [self layout];
        _player = [[TXVodPlayer alloc] init];
        [_player setupVideoWidget:self.playerView insertIndex:0];
        _player.loop = YES;
//        NSString* url = @"https://api.huoshan.com/hotsoon/item/video/_playback/?video_id=bea0903abb954f58ac0e17c21226a3c3&line=0&app_id=1115&watermark=1";
//        [_player startPlay:url ];
//        _isPlaying = YES;
    }
    return self;
}

- (void)layout{
    [self.playerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.contentView);
        make.bottom.mas_equalTo(self.contentView);
        make.left.mas_equalTo(self.contentView);
        make.right.mas_equalTo(self.contentView);
    }];
    
    [self.controlView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.contentView).offset(20);
        make.bottom.mas_equalTo(self.contentView).offset(-20);
        make.left.mas_equalTo(self.contentView).offset(20);
        make.right.mas_equalTo(self.contentView).offset(-20);
    }];
}

- (UIView *)playerView{
    if (!_playerView) {
        _playerView = [[UIView alloc] init];
    }
    return _playerView;
}

- (UIView *)controlView{
    if (!_controlView) {
        _controlView = [[UIView alloc] init];
        _controlView.backgroundColor = [UIColor clearColor];
//        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapAction)];
//        [_controlView addGestureRecognizer:tap];
    }
    return _controlView;
}

- (void)setUrlStr:(NSString *)urlStr{
    if (_urlStr != urlStr) {
        [_player stopPlay];
        _urlStr = urlStr;
        // 调整进度
        [_player seek:0.0];
        [_player startPlay:urlStr];
//        [_player resume];
    }
    [_player resume];
}

- (void)tapAction{
    
    if (_delegate && [_delegate respondsToSelector:@selector(openOrClose:)]) {
        [_delegate openOrClose:_player];
    }
}

@end
