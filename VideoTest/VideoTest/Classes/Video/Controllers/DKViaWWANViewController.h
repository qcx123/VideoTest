//
//  DKViaWWANViewController.h
//  VideoTest
//
//  Created by 乔春晓 on 2018/7/17.
//  Copyright © 2018年 乔春晓. All rights reserved.
//

#import "DKBaseViewController.h"

typedef enum {
    PlayState_Pause,// 暂停播放
    PlayState_play  // 继续播放
}PlayState;

typedef void(^PlayStateBlock)(PlayState state);

@interface DKViaWWANViewController : DKBaseViewController
/**
 block
 */
@property (nonatomic, copy) PlayStateBlock block;

- (instancetype)initWith:(PlayStateBlock)block;
@end
