//
//  DKProgramView.m
//  VideoTest
//
//  Created by 乔春晓 on 2018/7/24.
//  Copyright © 2018年 乔春晓. All rights reserved.
//

#import "DKProgramView.h"

@interface DKProgramView ()
/**
 进度View
 */
@property (nonatomic, strong) UIView *progressView;
/**
 loadingView
 */
@property (nonatomic, strong) UIView *loadingView;
/**
 volumeView
 */
@property (nonatomic, strong) UIView *volumeView;
/**
 timer
 */
@property (nonatomic, strong) NSTimer *timer;
@end

@implementation DKProgramView

- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [UIColor colorWithHexString:@"#333333"];
        _progressView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 0, frame.size.height)];
        _progressView.backgroundColor = [UIColor colorWithHexString:@"#ff4b83"];
        [self addSubview:_progressView];
        
        _loadingView = [[UIView alloc] initWithFrame:CGRectMake(KScreenW / 2.0, 0, 0, frame.size.height)];
        _loadingView.center = self.center;
        _loadingView.backgroundColor = [UIColor whiteColor];
        [self addSubview:_loadingView];
        
        _volumeView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 0, frame.size.height)];
        _volumeView.backgroundColor = [UIColor colorWithHexString:@"#337529"];
        [self addSubview:_volumeView];
    }
    return self;
}

- (void)drawRect:(CGRect)rect {
    
}

- (void)setProgress:(CGFloat)progress{
    _progress = progress;
    CGRect frame = _progressView.frame;
    frame.size.width = _progress * KScreenW;
    [UIView animateWithDuration:0.3 animations:^{
        self.progressView.frame = frame;
    }];
}

- (void)starLoading{
    _progressView.hidden = YES;
    _loadingView.hidden = NO;
    if (!_timer) {
        _timer = [NSTimer scheduledTimerWithTimeInterval:0.5 target:self selector:@selector(timerBegin) userInfo:nil repeats:YES];
    }
    _loadingView.frame = CGRectMake(KScreenW / 2.0, 0, 0, self.bounds.size.height);
    _loadingView.center = self.center;
}

- (void)stopLoading{
    _progressView.hidden = NO;
    _loadingView.hidden = YES;
    if (_timer) {
        [_timer invalidate];
        _timer = nil;
    }
    _loadingView.frame = CGRectMake(KScreenW / 2.0, 0, 0, self.bounds.size.height);
    _loadingView.center = self.center;
}

- (void)changeVolume:(CGFloat)volume {
    _progressView.hidden = YES;
    _loadingView.hidden = YES;
    _volumeView.hidden = NO;
    [UIView animateWithDuration:0.5 animations:^{
        self.volumeView.frame = CGRectMake(0, 0, volume * KScreenW, self.bounds.size.height);
    } completion:^(BOOL finished) {
        [self performSelector:@selector(hiddenVolumeView) withObject:nil afterDelay:1];
    }];
}

- (void)hiddenVolumeView{
    _progressView.hidden = NO;
    _loadingView.hidden = NO;
    _volumeView.hidden = YES;
}

- (void)timerBegin{
    [UIView animateWithDuration:0.4 animations:^{
        self.loadingView.center = self.center;
        self.loadingView.frame = CGRectMake(0, 0, KScreenW, self.bounds.size.height);
    } completion:^(BOOL finished) {
        self.loadingView.center = self.center;
        self.loadingView.frame = CGRectMake(KScreenW / 2.0, 0, 0, self.bounds.size.height);
    }];
}

@end
