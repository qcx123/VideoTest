//
//  DKScrollView.h
//  VideoTest
//
//  Created by 乔春晓 on 2018/7/25.
//  Copyright © 2018年 乔春晓. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <TXVodPlayer.h>
#import "DKVideoView.h"

@protocol DKScrollViewDelegate;

@interface DKScrollView : UIScrollView

@property (nonatomic, weak) id<DKScrollViewDelegate> playerDelegate;
@property (nonatomic, assign) NSInteger index;

@property (nonatomic, strong) DKVideoView *upPerPlayer, *middlePlayer, *downPlayer;

- (instancetype)initWithFrame:(CGRect)frame;

- (void)updateForLives:(NSMutableArray *)livesArray withCurrentIndex:(NSInteger) index;

@end


@protocol DKScrollViewDelegate <NSObject>

- (void)playerScrollView:(DKScrollView *)playerScrollView currentPlayerIndex:(NSInteger)index;

@end
