//
//  QCXDouYinViewController.m
//  VideoTest
//
//  Created by 乔春晓 on 2018/7/15.
//  Copyright © 2018年 乔春晓. All rights reserved.
//

#import "QCXDouYinViewController.h"
#import "VideoDataModel.h"
#import "QCXVideoView.h"

@interface QCXDouYinViewController()<UIScrollViewDelegate>

@property (nonatomic, strong) UIScrollView *scrollView;

@property (nonatomic, strong) QCXVideoView *firstPlayView;

@property (nonatomic, strong) QCXVideoView *secondPlayView;

@property (nonatomic, strong) QCXVideoView *thridPlayView;

@property (nonatomic, strong) NSArray<NSString *> *douyinVideoStrings;

@property (nonatomic, strong) NSMutableArray *dataArr;

@property(nonatomic, assign) NSUInteger currentVideoIndex;

@property(nonatomic, assign) CGFloat scrollViewOffsetYOnStartDrag;

@end

@implementation QCXDouYinViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self proportyData];
    [self setup];
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    self.scrollView.contentInset = UIEdgeInsetsZero;
    if (@available(iOS 11.0, *)) {
        self.scrollView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    }
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES];
    //    [self.navigationController.navigationBar setBackgroundImage:[UIImage new] forBarMetrics:UIBarMetricsDefault];
    //    //去掉导航栏底部的黑线
    //    self.navigationController.navigationBar.shadowImage = [UIImage new];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    self.scrollViewOffsetYOnStartDrag = -100;
    [self scrollViewDidEndScrolling];
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    [self.navigationController setNavigationBarHidden:NO];
    [self.secondPlayView.player stopPlay];
}


#pragma mark - UIScrollViewDelegate

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView
                  willDecelerate:(BOOL)decelerate {
    if (decelerate == NO) {
        [self scrollViewDidEndScrolling];
    }
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    [self scrollViewDidEndScrolling];
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    self.scrollViewOffsetYOnStartDrag = scrollView.contentOffset.y;
}


#pragma mark - JPVideoPlayerDelegate

- (BOOL)shouldShowBlackBackgroundBeforePlaybackStart {
    return YES;
}

#pragma mark - Private

- (void)scrollViewDidEndScrolling {
    if(self.scrollViewOffsetYOnStartDrag == self.scrollView.contentOffset.y){
        return;
    }
    
    CGSize referenceSize = UIScreen.mainScreen.bounds.size;
    [self.scrollView setContentOffset:CGPointMake(0, referenceSize.height) animated:NO];
    [self.secondPlayView.player stopPlay];
//    [self.secondImageView jp_playVideoMuteWithURL:[self fetchDouyinURL]
//                               bufferingIndicator:nil
//                                     progressView:[JPDouyinProgressView new]
//                                    configuration:^(UIView *view, JPVideoPlayerModel *playerModel) {
//                                        view.jp_muted = NO;
//                                    }];
    [self.secondPlayView.player startPlay:[self fetchDouyinURL]];
}

- (NSString *)fetchDouyinURL {
    if(self.currentVideoIndex == (self.dataArr.count - 1)){
        self.currentVideoIndex = 0;
    }
//    NSString *url = self.douyinVideoStrings[self.currentVideoIndex];
    NSString *url = self.dataArr[self.currentVideoIndex];
    self.currentVideoIndex++;
    return url;
}

- (NSArray<NSString *> *)douyinVideoStrings {
    if(!_douyinVideoStrings){
        _douyinVideoStrings = @[
                                @"http://www.w3school.com.cn/example/html5/mov_bbb.mp4",
                                @"https://www.w3schools.com/html/movie.mp4",
                                @"http://clips.vorwaerts-gmbh.de/big_buck_bunny.mp4",
                                @"https://media.w3.org/2010/05/sintel/trailer.mp4",
                                @"http://mvvideo2.meitudata.com/576bc2fc91ef22121.mp4",
                                @"http://mvvideo10.meitudata.com/5a92ee2fa975d9739_H264_3.mp4",
                                @"http://mvvideo11.meitudata.com/5a44d13c362a23002_H264_11_5.mp4",
                                @"http://mvvideo10.meitudata.com/572ff691113842657.mp4",
                                @"https://api.tuwan.com/apps/Video/play?key=aHR0cHM6Ly92LnFxLmNvbS9pZnJhbWUvcGxheWVyLmh0bWw%2FdmlkPXUwNjk3MmtqNWV6JnRpbnk9MCZhdXRvPTA%3D&aid=381374",
                                @"https://api.tuwan.com/apps/Video/play?key=aHR0cHM6Ly92LnFxLmNvbS9pZnJhbWUvcGxheWVyLmh0bWw%2FdmlkPWswNjk2enBud2xvJnRpbnk9MCZhdXRvPTA%3D&aid=381395",
                                ];
    }
    return _douyinVideoStrings;
}


#pragma mark - Setup

- (void)setup {
    self.view.backgroundColor = [UIColor whiteColor];
    CGSize referenceSize = UIScreen.mainScreen.bounds.size;
    self.currentVideoIndex = 0;
    
    self.scrollView = ({
        UIScrollView *scrollView = [UIScrollView new];
        scrollView.backgroundColor = [UIColor blackColor];
        [self.view addSubview:scrollView];
        scrollView.frame = self.view.bounds;
        scrollView.contentSize = CGSizeMake(referenceSize.width, referenceSize.height * 3);
        scrollView.pagingEnabled = YES;
        scrollView.delegate = self;
        
        scrollView;
    });
    
    self.firstPlayView = ({
        QCXVideoView *videoView = [[QCXVideoView alloc] initWithFrame:CGRectMake(0, 0, referenceSize.width, referenceSize.height)];
        [self.scrollView addSubview:videoView];
//        imageView.image = [UIImage imageNamed:@"placeholder1"];
        
        videoView;
    });
    
    self.secondPlayView = ({
        QCXVideoView *videoView = [[QCXVideoView alloc] initWithFrame:CGRectMake(0, referenceSize.height, referenceSize.width, referenceSize.height)];
        [self.scrollView addSubview:videoView];
        //        imageView.image = [UIImage imageNamed:@"placeholder1"];
//        imageView.jp_videoPlayerDelegate = self;
        videoView;
    });
    
    self.thridPlayView = ({
        QCXVideoView *videoView = [[QCXVideoView alloc] initWithFrame:CGRectMake(0, referenceSize.height * 2, referenceSize.width, referenceSize.height)];
        [self.scrollView addSubview:videoView];
        //        imageView.image = [UIImage imageNamed:@"placeholder1"];
        videoView;
    });
}

- (void)proportyData{
        _dataArr = @[@"https://api.huoshan.com/hotsoon/item/video/_playback/?video_id=bea0903abb954f58ac0e17c21226a3c3&line=0&app_id=1115&watermark=1",@"https://api.huoshan.com/hotsoon/item/video/_playback/?video_id=e3da4d9917364f2b8f5826487563d763&line=0&app_id=1115&watermark=1",@"https://api.huoshan.com/hotsoon/item/video/_playback/?video_id=e486dc4931d041c1b5405e9fcb35e0ac&line=0&app_id=1115&watermark=1",@"https://api.huoshan.com/hotsoon/item/video/_playback/?video_id=f56df03dea804541a9fcd4d1cc26eefd&line=0&app_id=1115&watermark=1",@"https://api.huoshan.com/hotsoon/item/video/_playback/?video_id=15105c5f27db4c789b8ba43c3e5056c4&line=0&app_id=1115&watermark=1",@"https://api.huoshan.com/hotsoon/item/video/_playback/?video_id=dcb9b966feaf44b9bbb182ed6ec18905&line=0&app_id=1115&watermark=1",@"https://api.huoshan.com/hotsoon/item/video/_playback/?video_id=b05b22407e0c4ecfa9b9d9d61b3cde8d&line=0&app_id=1115&watermark=1",@"https://api.huoshan.com/hotsoon/item/video/_playback/?video_id=3addc2c120c64055b4d8d5aa02ed0358&line=0&app_id=1115&watermark=1",@"https://api.huoshan.com/hotsoon/item/video/_playback/?video_id=0023998b5c434594a341aa14ca246e78&line=0&app_id=1115&watermark=1",@"https://api.huoshan.com/hotsoon/item/video/_playback/?video_id=89a4c97611cb4e968ee527064910f8f5&line=0&app_id=1115&watermark=1",@"https://api.huoshan.com/hotsoon/item/video/_playback/?video_id=a3480c04fb474d8abe67b92ba3092385&line=0&app_id=1115&watermark=1",@"https://api.huoshan.com/hotsoon/item/video/_playback/?video_id=a32e93a6db1946b1923dab80426cf408&line=0&app_id=1115&watermark=1",@"https://api.huoshan.com/hotsoon/item/video/_playback/?video_id=4066031765e64444aec56555c7916c88&line=0&app_id=1115&watermark=1",@"https://api.huoshan.com/hotsoon/item/video/_playback/?video_id=de5fb0f7a58c474f99b0e36f14ab4f5e&line=0&app_id=1115&watermark=1",@"https://api.huoshan.com/hotsoon/item/video/_playback/?video_id=f74e414de26c4c3ab496e145e2133e4e&line=0&app_id=1115&watermark=1",@"https://api.huoshan.com/hotsoon/item/video/_playback/?video_id=e46a3badde1c4c45bdbd955f8cc3d4a0&line=0&app_id=1115&watermark=1",@"https://api.huoshan.com/hotsoon/item/video/_playback/?video_id=05cea72731f048dbb88e330a36ec5d7b&line=0&app_id=1115&watermark=1",@"https://api.huoshan.com/hotsoon/item/video/_playback/?video_id=287a0f388ff94132a0378590ce2ea10a&line=0&app_id=1115&watermark=1",@"https://api.huoshan.com/hotsoon/item/video/_playback/?video_id=ca29113defee42629100e25bae76f0cb&line=0&app_id=1115&watermark=1",@"https://api.huoshan.com/hotsoon/item/video/_playback/?video_id=47e79e358ccb4c068e17ff428589b890&line=0&app_id=1115&watermark=1",@"https://api.huoshan.com/hotsoon/item/video/_playback/?video_id=f8f3e8f939c74180ac58a07ae1c3db67&line=0&app_id=1115&watermark=1",@"https://api.huoshan.com/hotsoon/item/video/_playback/?video_id=94ecd0c72cc44a53ba10903430e725b7&line=0&app_id=1115&watermark=1",@"https://api.huoshan.com/hotsoon/item/video/_playback/?video_id=2f95ed89e7674f45a8c1dd42b1d7dca7&line=0&app_id=1115&watermark=1",@"https://api.huoshan.com/hotsoon/item/video/_playback/?video_id=02659682c15a48ccaa804f8529c77403&line=0&app_id=1115&watermark=1",@"https://api.huoshan.com/hotsoon/item/video/_playback/?video_id=9c847635c5c7448e87276e0af4b84312&line=0&app_id=1115&watermark=1",@"https://api.huoshan.com/hotsoon/item/video/_playback/?video_id=93836edd53674014b27e1635beeffcef&line=0&app_id=1115&watermark=1",@"https://api.huoshan.com/hotsoon/item/video/_playback/?video_id=31e409d479b246f38f3d78ad6db6a101&line=0&app_id=1115&watermark=1",@"https://api.huoshan.com/hotsoon/item/video/_playback/?video_id=38f8410535a64da7b4a478432aa8abc8&line=0&app_id=1115&watermark=1",@"https://api.huoshan.com/hotsoon/item/video/_playback/?video_id=6b5148345c2d48ce8567a17dbf2f45ca&line=0&app_id=1115&watermark=1",@"https://api.huoshan.com/hotsoon/item/video/_playback/?video_id=41267809310d4501ba7cf451291063de&line=0&app_id=1115&watermark=1",@"https://api.huoshan.com/hotsoon/item/video/_playback/?video_id=62847ccc4a4f489191f3cf33b1dc67ba&line=0&app_id=1115&watermark=1",@"https://api.huoshan.com/hotsoon/item/video/_playback/?video_id=6dbed011226d4f0684e94d498b9b8225&line=0&app_id=1115&watermark=1",@"https://api.huoshan.com/hotsoon/item/video/_playback/?video_id=fb79ed4429da4d9e8b092df7c5583961&line=0&app_id=1115&watermark=1",@"https://api.huoshan.com/hotsoon/item/video/_playback/?video_id=d577e3909d6747c88d302f99821bb07e&line=0&app_id=1115&watermark=1",@"https://api.huoshan.com/hotsoon/item/video/_playback/?video_id=6cc1e35d135c4435872d40a9c7042d92&line=0&app_id=1115&watermark=1",@"https://api.huoshan.com/hotsoon/item/video/_playback/?video_id=4bdc8186c3c54c77b84b06fed8b6c60b&line=0&app_id=1115&watermark=1",@"https://api.huoshan.com/hotsoon/item/video/_playback/?video_id=2ceb37d4f33b4df0b65dd870f213f39c&line=0&app_id=1115&watermark=1",@"https://api.huoshan.com/hotsoon/item/video/_playback/?video_id=819a2fdc8694479cada31f48c9f282a2&line=0&app_id=1115&watermark=1",@"https://api.huoshan.com/hotsoon/item/video/_playback/?video_id=0cdfe30b18ae4859ba6935474006ce38&line=0&app_id=1115&watermark=1",@"https://api.huoshan.com/hotsoon/item/video/_playback/?video_id=cc2cdbc32b3c4c3985785328a8d6c718&line=0&app_id=1115&watermark=1"].mutableCopy;
    
//    NSMutableArray* tempAry = [NSMutableArray array];
//    NSMutableArray* mutableAry = [NSMutableArray array];
//    _dataArr = [NSMutableArray array];
//    [VideoDataModel getHomePageVideoDataWithBlock:^(NSArray *dateAry, NSError *error) {
//        [tempAry addObjectsFromArray:dateAry];
//        for (VideoDataModel* model in tempAry) {
//            [mutableAry addObject:model];
//        }
//        [self.dataArr addObjectsFromArray:mutableAry];
//    }];
    
}

@end
