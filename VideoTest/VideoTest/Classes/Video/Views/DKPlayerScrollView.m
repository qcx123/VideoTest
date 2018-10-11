//
//  DKPlayerScrollView.m
//  DKVideoListPlay
//
//  Created by 乔春晓 on 2018/7/23.
//  Copyright © 2018年 乔春晓 All rights reserved.
//

#import "DKPlayerScrollView.h"
#import "VideoInfoModel.h"
#import "UIImageView+WebCache.h"

#define SCREEN_WIDTH [UIScreen mainScreen].bounds.size.width
#define SCREEN_HEIGHT [UIScreen mainScreen].bounds.size.height

@interface DKPlayerScrollView () <UIScrollViewDelegate>

@property (nonatomic, strong) NSMutableArray * lives;
@property (nonatomic, strong) VideoInfoModel *live;
@property (nonatomic, strong) UIImageView *upperImageView, *middleImageView, *downImageView;
@property (nonatomic, strong) VideoInfoModel *upperLive, *middleLive, *downLive;
@property (nonatomic, assign) NSInteger currentIndex, previousIndex;

@end

@implementation DKPlayerScrollView

- (NSMutableArray *)lives
{
  if (!_lives) {
    _lives = [NSMutableArray array];
  }
  return _lives;
}

- (instancetype)initWithFrame:(CGRect)frame
{
  self = [super initWithFrame:frame];
  if(self)
  {
    self.contentSize = CGSizeMake(0, frame.size.height * 3);
    self.contentOffset = CGPointMake(0, frame.size.height);
    self.pagingEnabled = YES;
    self.opaque = YES;
    self.backgroundColor = [UIColor clearColor];
    self.showsHorizontalScrollIndicator = NO;
    self.showsVerticalScrollIndicator = NO;
    if (@available(iOS 11.0, *)) {
      self.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    } else {
      // Fallback on earlier versions
    }
    self.delegate = self;
    
//    self.upperImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, frame.size.width, frame.size.height)];
//    self.middleImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, frame.size.height, frame.size.width, frame.size.height)];
//    self.downImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, frame.size.height*2, frame.size.width, frame.size.height)];
//    // add image views
//    [self addSubview:self.upperImageView];
//    [self addSubview:self.middleImageView];
//    [self addSubview:self.downImageView];
    
      
      self.upPerPlayer = [[DKVideoView alloc] initWithFrame:CGRectMake(0, SCREEN_HEIGHT * 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
      self.autoresizesSubviews = YES;
      [self addSubview:self.upPerPlayer];
    
      self.middlePlayer = [[DKVideoView alloc] initWithFrame:CGRectMake(0, SCREEN_HEIGHT * 1, SCREEN_WIDTH, SCREEN_HEIGHT)];
      self.autoresizesSubviews = YES;
      [self addSubview:self.middlePlayer];
    
      self.downPlayer = [[DKVideoView alloc] initWithFrame:CGRectMake(0, SCREEN_HEIGHT * 2, SCREEN_WIDTH, SCREEN_HEIGHT)];
      self.autoresizesSubviews = YES;
      [self addSubview:self.downPlayer];
  }
  return self;
}


- (void)updateForLives:(NSMutableArray *)livesArray withCurrentIndex:(NSInteger)index
{
  if (livesArray.count && [livesArray firstObject]) {
    [self.lives removeAllObjects];
    [self.lives addObjectsFromArray:livesArray];
    self.currentIndex = index;
    self.previousIndex = index;
    
    _upperLive = [[VideoInfoModel alloc] init];
    _middleLive = (VideoInfoModel *)_lives[_currentIndex];
    _downLive = [[VideoInfoModel alloc] init];
    
    if (_currentIndex == 0) {
      _upperLive = (VideoInfoModel *)[_lives lastObject];
    } else {
      _upperLive = (VideoInfoModel *)_lives[_currentIndex - 1];
    }
    if (_currentIndex == _lives.count - 1) {
      _downLive = (VideoInfoModel *)[_lives firstObject];
    } else {
      _downLive = (VideoInfoModel *)_lives[_currentIndex + 1];
    }
//      _middleLive.isAutoPlay = YES;
//    [self prepareForImageView:self.upperImageView withLive:_upperLive];
//    [self prepareForImageView:self.middleImageView withLive:_middleLive];
//    [self prepareForImageView:self.downImageView withLive:_downLive];
    
    
    [self prepareForVideo:self.upPerPlayer withLive:_upperLive];
    [self prepareForVideo:self.middlePlayer withLive:_middleLive];
    [self prepareForVideo:self.downPlayer withLive:_downLive];
  }
}

- (void) prepareForImageView: (UIImageView *)imageView withLive:(VideoInfoModel *)live
{
  [imageView sd_setImageWithURL:[NSURL URLWithString:live.coverImageAddress]];
//  [imageView downloadImage:live.coverImageAddress placeholder:@"default_room"];
}

- (void) prepareForVideo: (DKVideoView *)player withLive:(VideoInfoModel *)live
{

//    [player reset:false];
//    [player setUrl:[NSURL URLWithString:live.VideoAddress]];
//    [player setShouldAutoplay:false];
//    [player setBufferSizeMax:1];
//    [player setShouldLoop:YES];
//    player.view.backgroundColor = [UIColor clearColor];
//    [player prepareToPlay];
    
    player.url = live.VideoAddress;
//    player.isAutoPlay = live.isAutoPlay;
    [player.bgImgView sd_setImageWithURL:[NSURL URLWithString:live.coverImageAddress]];
}



- (void)switchPlayer:(UIScrollView*)scrollView
{
  CGFloat offset = scrollView.contentOffset.y;
  if (self.lives.count) {
    if (offset >= 2*self.frame.size.height)
    {
        if (_currentIndex == _lives.count - 3) {
            
        }else{
            // slides to the down player
            scrollView.contentOffset = CGPointMake(0, self.frame.size.height);
            _currentIndex++;
            //      self.upperImageView.image = self.middleImageView.image;
            //      self.middleImageView.image = self.downImageView.image;
            
            if (self.upPerPlayer.frame.origin.y == 0) {
                self.upPerPlayer.frame = CGRectMake(0, SCREEN_HEIGHT * 2, SCREEN_WIDTH, SCREEN_HEIGHT);
            }else{
                self.upPerPlayer.frame = CGRectMake(0, self.upPerPlayer.frame.origin.y - SCREEN_HEIGHT, SCREEN_WIDTH, SCREEN_HEIGHT);
            }
            
            if (self.middlePlayer.frame.origin.y == 0) {
                self.middlePlayer.frame = CGRectMake(0, SCREEN_HEIGHT * 2, SCREEN_WIDTH, SCREEN_HEIGHT);
            }else{
                self.middlePlayer.frame = CGRectMake(0, self.middlePlayer.frame.origin.y - SCREEN_HEIGHT, SCREEN_WIDTH, SCREEN_HEIGHT);
            }
            
            
            //        VideoInfoModel *model = self.lives[_currentIndex];
            //        model.isAutoPlay = NO;
            NSLog(@"_currentIndex = %ld",_currentIndex);
            if (_currentIndex == self.lives.count - 1)
            {
                _downLive = [self.lives firstObject];
            } else if (_currentIndex == self.lives.count)
            {
                _downLive = self.lives[1];
                _currentIndex = 0;
                
            } else
            {
                _downLive = self.lives[_currentIndex + 1];
            }
            _downLive.isAutoPlay = YES;
            //      [self prepareForImageView:self.downImageView withLive:_downLive];
            
            
            
            if (self.downPlayer.frame.origin.y == 0) {
                self.downPlayer.frame = CGRectMake(0, SCREEN_HEIGHT * 2, SCREEN_WIDTH, SCREEN_HEIGHT);
            }else{
                self.downPlayer.frame = CGRectMake(0, self.downPlayer.frame.origin.y - SCREEN_HEIGHT, SCREEN_WIDTH, SCREEN_HEIGHT);
            }
            
            if (self.upPerPlayer.frame.origin.y == SCREEN_HEIGHT * 2) {
                [self prepareForVideo:self.upPerPlayer withLive:_downLive];
            }
            if (self.middlePlayer.frame.origin.y == SCREEN_HEIGHT * 2) {
                [self prepareForVideo:self.middlePlayer withLive:_downLive];
            }
            if (self.downPlayer.frame.origin.y == SCREEN_HEIGHT * 2) {
                [self prepareForVideo:self.downPlayer withLive:_downLive];
            }
            
            
            
            if (_previousIndex == _currentIndex) {
                return;
            }
            if ([self.playerDelegate respondsToSelector:@selector(playerScrollView:currentPlayerIndex:)]) {
                [self.playerDelegate playerScrollView:self currentPlayerIndex:_currentIndex];
                _previousIndex = _currentIndex;
                NSLog(@"current index in delegate: %ld -%s",_currentIndex,__FUNCTION__);
            }
        }
        
      
    }
    else if (offset <= 0)
    {
        
        if (_currentIndex == 2) {
            
        }else{
            // slides to the upper player
            scrollView.contentOffset = CGPointMake(0, self.frame.size.height);
            _currentIndex--;
            self.downImageView.image = self.middleImageView.image;
            
            if (self.downPlayer.frame.origin.y == 2 * SCREEN_HEIGHT) {
                self.downPlayer.frame = CGRectMake(0, SCREEN_HEIGHT * 0, SCREEN_WIDTH, SCREEN_HEIGHT);
            }else{
                self.downPlayer.frame = CGRectMake(0, self.downPlayer.frame.origin.y + SCREEN_HEIGHT, SCREEN_WIDTH, SCREEN_HEIGHT);
            }
            
            self.middleImageView.image = self.upperImageView.image;
            
            
            if (self.middlePlayer.frame.origin.y == 2 * SCREEN_HEIGHT) {
                self.middlePlayer.frame = CGRectMake(0, SCREEN_HEIGHT * 0, SCREEN_WIDTH, SCREEN_HEIGHT);
            }else{
                self.middlePlayer.frame = CGRectMake(0, self.middlePlayer.frame.origin.y + SCREEN_HEIGHT, SCREEN_WIDTH, SCREEN_HEIGHT);
            }
            
            
            //      VideoInfoModel *model = self.lives[_currentIndex];
            //      model.isAutoPlay = NO;
            NSLog(@"_currentIndex = %ld",_currentIndex);
            if (_currentIndex == 0)
            {
                _upperLive = [self.lives lastObject];
                
            } else if (_currentIndex == -1)
            {
                _upperLive = self.lives[self.lives.count - 2];
                _currentIndex = self.lives.count-1;
                
            } else
            {
                _upperLive = self.lives[_currentIndex - 1];
            }
            _upperLive.isAutoPlay = YES;
            //      [self prepareForImageView:self.upperImageView withLive:_upperLive];
            
            if (self.upPerPlayer.frame.origin.y == 2 * SCREEN_HEIGHT) {
                self.upPerPlayer.frame = CGRectMake(0, SCREEN_HEIGHT * 0, SCREEN_WIDTH, SCREEN_HEIGHT);
            }else{
                self.upPerPlayer.frame = CGRectMake(0, self.upPerPlayer.frame.origin.y + SCREEN_HEIGHT, SCREEN_WIDTH, SCREEN_HEIGHT);
            }
            
            if (self.upPerPlayer.frame.origin.y == 0 ) {
                [self prepareForVideo:self.upPerPlayer withLive:_upperLive];
            }
            if (self.middlePlayer.frame.origin.y == 0 ) {
                [self prepareForVideo:self.middlePlayer withLive:_upperLive];
            }
            if (self.downPlayer.frame.origin.y == 0 ) {
                [self prepareForVideo:self.downPlayer withLive:_upperLive];
            }
            
            if (_previousIndex == _currentIndex) {
                return;
            }
            if ([self.playerDelegate respondsToSelector:@selector(playerScrollView:currentPlayerIndex:)]) {
                [self.playerDelegate playerScrollView:self currentPlayerIndex:_currentIndex];
                _previousIndex = _currentIndex;
                NSLog(@"current index in delegate: %ld -%s",_currentIndex,__FUNCTION__);
            }
        }
    }
      
  }
}

-(void)scrollViewDidScroll:(UIScrollView *)scrollView
{
   [self switchPlayer:scrollView];
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    // 停止类型1、停止类型2
    BOOL scrollToScrollStop = !scrollView.tracking && !scrollView.dragging && !scrollView.decelerating;
    if (scrollToScrollStop) {
        [self scrollViewDidEndScroll];
    }
}

#pragma mark - scrollView 滚动停止
- (void)scrollViewDidEndScroll {
    NSLog(@"停止滚动了！！！");
    DKVideoView *player = nil;
    CGFloat contentOfSetY = self.contentOffset.y;
    if (_upPerPlayer.y == contentOfSetY) {
        player = _upPerPlayer;
    }else if(_middlePlayer.y == contentOfSetY){
        player = _middlePlayer;
    }else if(_downPlayer.y == contentOfSetY){
        player = _downPlayer;
    }
    [[NSNotificationCenter defaultCenter] postNotificationName:MPMoviePlayerFirstVideoFrameRenderedNotification object:player];
    [[NSNotificationCenter defaultCenter] postNotificationName:MPMediaPlaybackIsPreparedToPlayDidChangeNotification object:player];
    
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
