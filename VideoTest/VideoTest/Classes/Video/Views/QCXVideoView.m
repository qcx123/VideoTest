//
//  QCXVideoView.m
//  VideoTest
//
//  Created by 乔春晓 on 2018/7/15.
//  Copyright © 2018年 乔春晓. All rights reserved.
//

#import "QCXVideoView.h"

@implementation QCXVideoView

- (instancetype)initWithFrame:(CGRect)frame{
    if(self = [super initWithFrame:frame]){
        [self initPlayer];
    }
    return self;
}

- (void)initPlayer{
    if(!_player){
        _player = [[TXVodPlayer alloc] init];
        [_player setupVideoWidget:self insertIndex:0];
        _player.loop = YES;
    }
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
