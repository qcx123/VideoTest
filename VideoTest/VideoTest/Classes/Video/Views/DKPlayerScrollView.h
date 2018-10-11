//
//  DKPlayerScrollView.h
//  DKVideoListPlay
//
//  Created by 乔春晓 on 2018/7/23.
//  Copyright © 2018年 乔春晓 All rights reserved.
//

#import <UIKit/UIKit.h>
#import <TXVodPlayer.h>
#import "DKVideoView.h"

@protocol DKPlayerScrollViewDelegate;

@interface DKPlayerScrollView : UIScrollView

@property (nonatomic, weak) id<DKPlayerScrollViewDelegate> playerDelegate;
@property (nonatomic, assign) NSInteger index;

@property (nonatomic, strong) DKVideoView *upPerPlayer, *middlePlayer, *downPlayer;

- (instancetype)initWithFrame:(CGRect)frame;

- (void)updateForLives:(NSMutableArray *)livesArray withCurrentIndex:(NSInteger) index;

@end


@protocol DKPlayerScrollViewDelegate <NSObject>

- (void)playerScrollView:(DKPlayerScrollView *)playerScrollView currentPlayerIndex:(NSInteger)index;

@end
