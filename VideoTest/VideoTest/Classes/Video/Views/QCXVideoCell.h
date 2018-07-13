//
//  QCXVideoCell.h
//  VideoTest
//
//  Created by 乔春晓 on 2018/7/13.
//  Copyright © 2018年 乔春晓. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <TXVodPlayer.h>

@protocol QCXVideoCellDelegate <NSObject>
- (void)openOrClose:(TXVodPlayer *)player;
@end

@interface QCXVideoCell : UICollectionViewCell
@property (nonatomic, strong) TXVodPlayer *player;
@property (nonatomic, weak) id<QCXVideoCellDelegate> delegate;
@property (nonatomic, assign) BOOL isPlaying;
@property (nonatomic, strong) NSString *urlStr;
@end
