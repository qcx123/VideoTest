//
//  DKVideoView.m
//  VideoTest
//
//  Created by 乔春晓 on 2018/7/15.
//  Copyright © 2018年 乔春晓. All rights reserved.
//

#import "DKVideoView.h"
#import "UIColor+Extension.h"
#import <UIImageView+WebCache.h>

@interface DKVideoView ()<TXVodPlayListener>
/**
 playerView
 */
@property (nonatomic, strong) UIView *playerView;
/**
 控制view
 */
@property (nonatomic, strong) UIView *controlView;
/**
 暂停按钮
 */
@property (nonatomic, strong) UIImageView *playImgView;
/**
 头像
 */
@property (nonatomic, strong) UIButton *headerBtn;
/**
 分享按钮
 */
@property (nonatomic, strong) UIButton *shareBtn;
/**
 点赞按钮
 */
@property (nonatomic, strong) UIButton *likeBtn;
/**
 下载
 */
@property (nonatomic, strong) UIButton *downloadBtn;
/**
 @label
 */
@property (nonatomic, strong) UILabel *atLabel;
/**
 描述
 */
@property (nonatomic, strong) UILabel *descriptionLabel;
/**
 游戏底部半透明背景
 */
@property (nonatomic, strong) UIImageView *backView;
/**
 游戏icon
 */
@property (nonatomic, strong) UIImageView *gameIcon;
/**
 游戏名字
 */
@property (nonatomic, strong) UILabel *gameNameLabel;
/**
 游戏描述
 */
@property (nonatomic, strong) UILabel *gameDescriptionLabel;
@end

@implementation DKVideoView{
    
}

- (instancetype)initWithFrame:(CGRect)frame{
    if(self = [super initWithFrame:frame]){
        [self initPlayer];
        [self setupUI];
        [self layout];
    }
    return self;
}

- (void)initPlayer{
    if(!_player){
        _player = [[TXVodPlayer alloc] init];
        [_player setupVideoWidget:self.playerView insertIndex:0];
        _player.loop = YES;
        [_player setRenderMode:RENDER_MODE_FILL_EDGE];
        _player.vodDelegate = self;
    }
}

#pragma mark -lazy-

- (UIView *)playerView{
    if (!_playerView) {
        _playerView = [[UIView alloc] initWithFrame:self.bounds];
    }
    return _playerView;
}

- (UIView *)controlView{
    if (!_controlView) {
        _controlView = [[UIView alloc] initWithFrame:self.bounds];
        _controlView.backgroundColor = [UIColor clearColor];
        _controlView.userInteractionEnabled = YES;
        
        [self.controlView addSubview:self.progressView];
        [self.controlView addSubview:self.backView];
        [self.controlView addSubview:self.headerBtn];
        [self.controlView addSubview:self.shareBtn];
        [self.controlView addSubview:self.likeBtn];
        [self.controlView addSubview:self.atLabel];
        [self.controlView addSubview:self.descriptionLabel];
        [self.controlView addSubview:self.playImgView];
        
        self.playImgView.hidden = YES;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapAction:)];
        [_controlView addGestureRecognizer:tap];
    }
    return _controlView;
}

- (UIProgressView *)progressView{
    if (!_progressView) {
        _progressView = [[UIProgressView alloc] initWithProgressViewStyle:(UIProgressViewStyleBar)];
        _progressView.frame = CGRectMake(0, KScreenH - TabBar_HEIGHT, KScreenW, 0.1);
//        _progressView.progress = 0.5;
    }
    return _progressView;
}

- (UIButton *)headerBtn{
    if (!_headerBtn) {
        _headerBtn = [UIButton buttonWithType:(UIButtonTypeCustom)];
        [_headerBtn setImage:[UIImage imageNamed:@"btn_tx"] forState:(UIControlStateNormal)];
        [_headerBtn setBackgroundImage:[UIImage imageNamed:@"btn_bjy"] forState:(UIControlStateNormal)];
//        _headerBtn.frame = CGRectMake(0, 0, 50, 50);
//        [self setButtonContentCenter:_headerBtn];
    }
    return _headerBtn;
}

- (UIButton *)shareBtn{
    if (!_shareBtn) {
        _shareBtn = [UIButton buttonWithType:(UIButtonTypeCustom)];
        [_shareBtn setImage:[UIImage imageNamed:@"btn_zf"] forState:(UIControlStateNormal)];
        [_shareBtn setBackgroundImage:[UIImage imageNamed:@"btn_bjy"] forState:(UIControlStateNormal)];
        [_shareBtn setTitle:@"666" forState:(UIControlStateNormal)];
        _shareBtn.frame = CGRectMake(0, 0, 50, 50);
        _shareBtn.titleLabel.font = [UIFont systemFontOfSize:9];
        [self setButtonContentCenter:_shareBtn];
    }
    return _shareBtn;
}

- (UIButton *)likeBtn{
    if (!_likeBtn) {
        _likeBtn = [UIButton buttonWithType:(UIButtonTypeCustom)];
        [_likeBtn setImage:[UIImage imageNamed:@"btn_dianz"] forState:(UIControlStateNormal)];
        [_likeBtn setBackgroundImage:[UIImage imageNamed:@"btn_bjy"] forState:(UIControlStateNormal)];
        [_likeBtn setTitle:@"666" forState:(UIControlStateNormal)];
        _likeBtn.frame = CGRectMake(0, 0, 50, 50);
        _likeBtn.titleLabel.font = [UIFont systemFontOfSize:8];
        [self setButtonContentCenter:_likeBtn];
    }
    return _likeBtn;
}

- (UIButton *)downloadBtn{
    if (!_downloadBtn) {
        _downloadBtn = [UIButton buttonWithType:(UIButtonTypeCustom)];
        [_downloadBtn setImage:[UIImage imageNamed:@"btn_xz"] forState:(UIControlStateNormal)];
    }
    return _downloadBtn;
}

- (UILabel *)atLabel{
    if (!_atLabel) {
        _atLabel = [[UILabel alloc] init];
        _atLabel.textColor = [UIColor colorWithHexString:@"#ffffff"];
        _atLabel.font = [UIFont systemFontOfSize:16];
        _atLabel.text = @"@春晓";
    }
    return _atLabel;
}

- (UILabel *)descriptionLabel{
    if (!_descriptionLabel) {
        _descriptionLabel = [[UILabel alloc] init];
        _descriptionLabel.textColor = [UIColor colorWithHexString:@"#ffffff"];
        _descriptionLabel.font = [UIFont systemFontOfSize:11];
        _descriptionLabel.numberOfLines = 0;
        _descriptionLabel.text = @"\"这里有好多鱼啊\n\"不，这里只有一条鱼，其他都是木头\"";
    }
    return _descriptionLabel;
}

- (UIImageView *)bgImgView{
    if (!_bgImgView) {
        _bgImgView = [[UIImageView alloc] init];
//        [_bgImgView sd_setImageWithURL:[NSURL URLWithString:@"http://p3.pstatp.com/large/3a340011ef33f75dd8aa.jpg"]];
//        [_bgImgView sd_setImageWithURL:[NSURL URLWithString:@"http://p3.pstatp.com/large/3a340011ef33f75dd8aa.jpg"] placeholderImage:[UIImage imageNamed:@"bg_noNet"]];
    }
    return _bgImgView;
}

- (UIImageView *)backView{
    if (!_backView) {
        _backView = [[UIImageView alloc] init];
        _backView.image = [UIImage imageNamed:@"bj_tmk"];
        [_backView addSubview:self.gameIcon];
        [_backView addSubview:self.gameNameLabel];
        [_backView addSubview:self.gameDescriptionLabel];
        [_backView addSubview:self.downloadBtn];
    }
    return _backView;
}

- (UIImageView *)gameIcon{
    if (!_gameIcon) {
        _gameIcon = [[UIImageView alloc] init];
        _gameIcon.image = [UIImage imageNamed:@"btn_tx"];
    }
    return _gameIcon;
}

- (UILabel *)gameNameLabel{
    if (!_gameNameLabel) {
        _gameNameLabel = [[UILabel alloc] init];
        _gameNameLabel.text = @"游戏名字";
        _gameNameLabel.textColor = [UIColor colorWithHexString:@"#ffffff"];
        _gameNameLabel.font = [UIFont systemFontOfSize:18];
    }
    return _gameNameLabel;
}

- (UILabel *)gameDescriptionLabel{
    if (!_gameDescriptionLabel) {
        _gameDescriptionLabel = [[UILabel alloc] init];
        _gameDescriptionLabel.text = @"游戏描述";
        _gameDescriptionLabel.textColor = [UIColor colorWithWhite:1 alpha:0.5];
        _gameDescriptionLabel.font = [UIFont systemFontOfSize:11];
    }
    return _gameDescriptionLabel;
}

- (UIImageView *)playImgView{
    if (!_playImgView) {
        _playImgView = [[UIImageView alloc] init];
        _playImgView.image = [UIImage imageNamed:@"icon_zt"];
    }
    return _playImgView;
}

- (void)setIsAutoPlay:(BOOL)isAutoPlay{
    _isAutoPlay = isAutoPlay;
    _player.isAutoPlay = _isAutoPlay;
}

#pragma mark -setup-

- (void)setupUI{
    [self addSubview:self.bgImgView];
    [self addSubview:self.playerView];
    [self addSubview:self.controlView];
    [self layout];
}

- (void)layout{
    [self.bgImgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.bottom.mas_equalTo(self);
    }];
    
    [self.playerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.bottom.mas_equalTo(self);
    }];
    
    [self.playImgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.mas_equalTo(self.controlView);
        make.width.height.mas_equalTo(70);
    }];
    
    [self.backView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.controlView).offset(10);
        make.right.mas_equalTo(self.controlView).offset(-10);
        make.bottom.equalTo(self.controlView).mas_equalTo(-80);
        make.height.mas_equalTo(55);
    }];
    
    [self.likeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(self.controlView).offset(-10);
        make.bottom.equalTo(self.backView.mas_top).mas_equalTo(-15);
        make.width.height.mas_equalTo(50);
    }];
    
    [self.shareBtn  mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(self.controlView).offset(-10);
        make.bottom.equalTo(self.likeBtn.mas_top).mas_equalTo(-10);
        make.width.height.mas_equalTo(50);
    }];
    
    [self.headerBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(self.controlView).offset(-10);
        make.bottom.equalTo(self.shareBtn.mas_top).mas_equalTo(-10);
        make.width.height.mas_equalTo(50);
    }];
    
    [self.descriptionLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.controlView).offset(10);
        make.bottom.equalTo(self.backView.mas_top).mas_equalTo(-12.5f);
        make.right.mas_equalTo(self.controlView).offset(10);
        make.height.mas_equalTo(45);
    }];
    
    [self.atLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.controlView).offset(10);
        make.bottom.equalTo(self.descriptionLabel.mas_top).mas_equalTo(-8);
        make.right.mas_equalTo(self.controlView).offset(10);
        make.height.mas_equalTo(15);
    }];
    
    [self.gameIcon mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.backView).offset(10);
        make.centerY.mas_equalTo(self.backView);
        make.width.height.mas_equalTo(35);
    }];
    
    [self.gameIcon mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.backView).offset(10);
        make.centerY.mas_equalTo(self.backView);
        make.width.height.mas_equalTo(35);
    }];
    
    [self.gameNameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.gameIcon.mas_right).mas_equalTo(10);
        make.top.mas_equalTo(self.gameIcon);
        make.height.mas_equalTo(20);
        make.right.mas_equalTo(self.backView).mas_offset(-10);
    }];
    
    [self.gameDescriptionLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.gameIcon.mas_right).mas_equalTo(10);
        make.top.equalTo(self.gameNameLabel.mas_bottom).mas_equalTo(2);
        make.height.mas_equalTo(13);
        make.right.mas_equalTo(self.backView).mas_offset(-10);
    }];
    
    [self.downloadBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(self.backView).offset(-10);
        make.centerY.mas_equalTo(self.backView);
        make.width.height.mas_equalTo(33);
    }];
}

#pragma mark -tap-

- (void)tapAction:(UITapGestureRecognizer *)tap {
    if ([_player isPlaying]) {
        [_player pause];
        self.playImgView.hidden = NO;
    }else{
        [_player resume];
        self.playImgView.hidden = YES;
    }
}

#pragma mark -启动播放-

- (int)startPlay:(NSString *)url{
    self.playImgView.hidden = YES;
    return [self.player startPlay:url];
}

- (int)play{
    self.playImgView.hidden = YES;
    if (_url) {
        return [self.player startPlay:_url];
    }else{
        NSLog(@"url为空");
        return 0;
    }
}

/* stopPlay 停止播放音视频流
 * 返回: 0 = OK
 */
- (int)stopPlay{
    self.playImgView.hidden = YES;
//    [_bgImgView sd_setImageWithURL:[NSURL URLWithString:@""] placeholderImage:[UIImage imageNamed:@"bg_noNet"]];
    self.progressView.progress = 0.0;
    return [_player stopPlay];
}

/* isPlaying 是否正在播放
 * 返回： YES 拉流中，NO 没有拉流
 */
- (bool)isPlaying{
    return [_player isPlaying];
}

/* pause 暂停播放
 *
 */
- (void)pause{
    [_player pause];
}

/* resume 继续播放
 *
 */
- (void)resume{
    [_player resume];
}

#pragma mark -跟踪进度-
-(void) onPlayEvent:(TXVodPlayer *)player event:(int)EvtID withParam:(NSDictionary*)param {
    if (EvtID == PLAY_EVT_PLAY_PROGRESS) {
        // 加载进度, 单位是秒, 小数部分为毫秒
        //        float playable = [param[EVT_PLAYABLE_DURATION] floatValue];
        //        [_loadProgressBar setValue:playable];
        
        // 播放进度, 单位是秒, 小数部分为毫秒
        float progress = [param[EVT_PLAY_PROGRESS] floatValue];
        //        [_seekProgressBar setValue:progress];
        
        // 视频总长, 单位是秒, 小数部分为毫秒
        float duration = [param[EVT_PLAY_DURATION] floatValue];
        // 可以用于设置时长显示等等
        _progressView.progress = progress / duration;
        NSLog(@"%lf",progress / duration);
    }
}

// 设置按钮和图片垂直居中
-(void)setButtonContentCenter:(UIButton *) btn{
    CGSize imgViewSize,titleSize,btnSize;
    UIEdgeInsets imageViewEdge,titleEdge;
    CGFloat heightSpace = 10.0f;
    //设置按钮内边距
    imgViewSize = btn.imageView.bounds.size;
    titleSize = btn.titleLabel.bounds.size;
    btnSize = btn.bounds.size;
    imageViewEdge = UIEdgeInsetsMake(heightSpace,0.0, btnSize.height -imgViewSize.height - heightSpace, - titleSize.width);
    [btn setImageEdgeInsets:imageViewEdge];
    titleEdge = UIEdgeInsetsMake(imgViewSize.height +heightSpace, - imgViewSize.width, 0.0, 0.0);
    [btn setTitleEdgeInsets:titleEdge];
}

@end
