//
//  DKDouYinViewController.m
//  VideoTest
//
//  Created by 乔春晓 on 2018/7/15.
//  Copyright © 2018年 乔春晓. All rights reserved.
//

#import "DKDouYinViewController.h"
#import "DKViewController.h"
#import "DKViaWWANViewController.h"
#import "DKVideoLeftView.h"
#import "UIImage+DKImage.h"
#import "UIViewController+InteractivePushGesture.h"
#import "DKVideoView.h"

typedef enum {
    ScrolDirection_NO,   // 当前
    ScrolDirection_UP,   // 上滑
    ScrolDirection_Down  // 下滑
}ScrolDirection;

@interface DKDouYinViewController ()<UIViewControllerInteractivePushGestureDelegate,DKVideoLeftViewDelegate,UIScrollViewDelegate>
@property (nonatomic, strong) UISwipeGestureRecognizer *leftSwipeGestureRecognizer;

@property (nonatomic, strong) UISwipeGestureRecognizer *rightSwipeGestureRecognizer;
/**
 左视图
 */
@property (nonatomic, strong) DKVideoLeftView *leftView;
/**
 导航栏
 */
@property (nonatomic, strong) UIView *naviView;

@property (nonatomic, strong) UIScrollView *scrollView;

@property (nonatomic, strong) DKVideoView *firstPlayView;

@property (nonatomic, strong) DKVideoView *secondPlayView;

@property (nonatomic, strong) DKVideoView *thridPlayView;

@property (nonatomic, strong) UIImageView *noNetView;

@property (nonatomic, strong) UIImageView *bgView;

@property (nonatomic, strong) NSArray<NSString *> *douyinVideoStrings;

@property (nonatomic, strong) NSMutableArray *dataArr;

@property(nonatomic, assign) NSUInteger currentVideoIndex;

@property (nonatomic, strong) NSString *currentUrl;

@property(nonatomic, assign) CGFloat scrollViewOffsetYOnStartDrag;

@property (nonatomic, assign) BOOL isFirstStart;
@end

@implementation DKDouYinViewController{
    ScrolDirection scrolDirection;
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES];
    self.tabBarController.tabBar.backgroundImage = [UIImage imageWithColor:[UIColor colorWithWhite:0 alpha:0.3] size:CGSizeMake(KScreenW,TabBar_HEIGHT)];
    [self.tabBarController.tabBar setShadowImage:[UIImage imageWithColor:[UIColor clearColor] size:CGSizeMake(KScreenW,0.5)]];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    self.scrollViewOffsetYOnStartDrag = -100;
    if (_currentUrl) {
        [self.secondPlayView startPlay:_currentUrl];
    }
    [self scrollViewDidEndScrolling];
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [self.navigationController setNavigationBarHidden:NO];
    //    [self.tabBarController.tabBar setShadowImage:[UIImage imageWithColor:[UIColor clearColor] size:CGSizeMake(KScreenW,0.5)]];
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    [self.navigationController setNavigationBarHidden:NO];
    [self.secondPlayView.player stopPlay];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor redColor];
    [self proportyData];
    [self bgView];
    [self setupVideo];
    [self setUpLeftMenuView];
    [self notReachableView];
    self.noNetView.hidden = YES;
    [self.view addSubview:self.naviView];
    self.interactivePushGestureEnabled = YES;
    self.interactivePushGestureDelegate = self;
    
    [self addObserver];
    
}

- (void)addObserver{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reachabilityStatusViaWWAN:) name:@"netWorkChangeEventNotification" object:nil];
}

- (void)removeObserver{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"netWorkChangeEventNotification" object:nil];
}

- (void)dealloc{
    [self removeObserver];
}

#pragma mark -左抽屉-
- (void)setUpLeftMenuView{
    //获取到的个人信息
    NSString *account = @"test";
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    dic[@"account"] = account;
    dic[@"icon"] = @"left_setting";
    
    if (!_leftView) {
        _leftView = [[DKVideoLeftView alloc] initWithFrame:CGRectZero];
        [UIApplication sharedApplication].keyWindow.backgroundColor = [UIColor clearColor];
        
        [[UIApplication sharedApplication].keyWindow addSubview:_leftView];
        _leftView.delegate = self;
        _leftView.hidden = YES;
        [_leftView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.top.mas_equalTo(0);
            make.left.mas_equalTo(-KScreenW);
            make.width.mas_equalTo(KScreenW);
        }];
    }
}

//收回左侧侧边栏
- (void)hideLeftMenuView{
    [self.leftView cancelCoverViewOpacity];
    [UIView animateWithDuration:0.35 animations:^{
        [self.leftView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(-KScreenW);
        }];
        
        [[UIApplication sharedApplication].keyWindow layoutIfNeeded];
        
    }completion:^(BOOL finished) {
        self.leftView.hidden = YES;
    }];
}

#pragma mark - DKVideoLeftViewDelegate
- (void)touchLeftView:(DKVideoLeftView *)leftView byType:(DKTouchItem)type{
    
    [self hideLeftMenuView];
    
    UIViewController *vc = nil;
    
    switch (type) {
        case DKTouchItemUserInfo:
        {
            
        }
            break;
        case DKTouchItemMineAttention:
        {
            
        }
            break;
        case DKTouchItemMineCollecttion:
        {
            
        }
            break;
        case DKTouchItemMineMsg:
        {
            
        }
            break;
        case DKTouchItemAccountBound:
        {
            
        }
            break;
        case DKTouchItemOpinionBack:
        {
            
        }
            break;
        case DKTouchItemSetting:
        {
            
        }
            break;
        case DKTouchItemQuit:
        {
            
            
        }
            break;
            
        default:
            break;
    }
    
    if (vc == nil) {
        return;
    }
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark - <UIViewControllerInteractivePushGestureDelegate>

- (UIViewController *)destinationViewControllerFromViewController:(UIViewController *)fromViewController {
    DKViewController *vc = [[DKViewController alloc] init];
    vc.view.backgroundColor = [UIColor colorWithRed:arc4random_uniform(256)/255.0 green:arc4random_uniform(256)/255.0 blue:arc4random_uniform(256)/255.0 alpha:1.0];
    return vc;
}

#pragma mark -lazy-

- (UIView *)naviView{
//    if (!_naviView) {
//        _naviView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, KScreenW, 64)];
//        _naviView.backgroundColor = [UIColor clearColor];
//
//        UIButton *leftBtn = [UIButton buttonWithType:(UIButtonTypeCustom)];
//        [leftBtn setImage:[UIImage imageNamed:@"btn_cbl"] forState:(UIControlStateNormal)];
//        [_naviView addSubview:leftBtn];
//        [leftBtn addTarget:self action:@selector(leftBtnAction:) forControlEvents:(UIControlEventTouchUpInside)];
//        leftBtn.frame = CGRectMake(15, 44, 60, 20);
//
//        UIButton *rightBtn = [UIButton buttonWithType:(UIButtonTypeCustom)];
//        [rightBtn setImage:[UIImage imageNamed:@"btn_phb"] forState:(UIControlStateNormal)];
//        [_naviView addSubview:rightBtn];
//        [rightBtn addTarget:self action:@selector(rightBtnAction:) forControlEvents:(UIControlEventTouchUpInside)];
//        rightBtn.frame = CGRectMake(KScreenW - 15 - 60, 44, 60, 20);
//    }
    return nil;
}

#pragma mark -按钮点击事件-
- (void)leftBtnAction:(UIButton *)btn {
    [super leftBtnAction:btn];
    self.leftView.hidden = NO;
    [UIView animateWithDuration:0.35 animations:^{
        [self.leftView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(0);
        }];
        [[UIApplication sharedApplication].keyWindow layoutIfNeeded];
    } completion:^(BOOL finished) {
    }];
    
    //设置颜色渐变动画
    [self.leftView startCoverViewOpacityWithAlpha:0.5 withDuration:0.35];
}

- (void)rightBtnAction:(UIButton *)btn {
    NSLog(@"右按钮点击事件");
}

#pragma mark -视频控制-
#pragma mark - UIScrollViewDelegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    if (scrollView.contentOffset.y < self.scrollViewOffsetYOnStartDrag ){
        //向上
        NSLog(@"上滑");
        scrolDirection = ScrolDirection_UP;
    } else if (scrollView.contentOffset.y > self.scrollViewOffsetYOnStartDrag ){
        //向下
        NSLog(@"下滑");
        scrolDirection = ScrolDirection_Down;
    }
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView
                  willDecelerate:(BOOL)decelerate {
    if (decelerate == NO) {
        [self scrollViewDidEndScrolling];
    }
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    [self scrollViewDidEndScrolling];
    // 停止类型1、停止类型2
    BOOL scrollToScrollStop = !scrollView.tracking && !scrollView.dragging && !scrollView.decelerating;
    if (scrollToScrollStop) {
        [self scrollViewDidEndScroll];
    }
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    self.scrollViewOffsetYOnStartDrag = scrollView.contentOffset.y;
}

//- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
//    if (!decelerate) {
//        // 停止类型3
//        BOOL dragToDragStop = scrollView.tracking && !scrollView.dragging && !scrollView.decelerating;
//        if (dragToDragStop) {
//            [self scrollViewDidEndScroll];
//        }
//    }
//}

#pragma mark - scrollView 滚动停止
- (void)scrollViewDidEndScroll {
    NSLog(@"停止滚动了！！！");
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
    [self.secondPlayView startPlay:[self fetchDouyinURLWithDirection:scrolDirection]];
}

- (NSString *)fetchDouyinURLWithDirection:(ScrolDirection)direction {
    NSString *url;
    switch (direction) {
        case ScrolDirection_NO:
            url = self.dataArr[self.currentVideoIndex];
            break;
        case ScrolDirection_UP:
            if(self.currentVideoIndex == 0){
                self.currentVideoIndex = self.dataArr.count;
            }
            url = self.dataArr[self.currentVideoIndex];
            self.currentVideoIndex--;
            break;
        case ScrolDirection_Down:
            if(self.currentVideoIndex == (self.dataArr.count - 1)){
                self.currentVideoIndex = 0;
            }
            url = self.dataArr[self.currentVideoIndex];
            self.currentVideoIndex++;
            break;
        default:
            break;
    }
    _currentUrl = url;
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

- (void)setupVideo {
    self.currentVideoIndex = 0;
    self.scrollView = ({
        UIScrollView *scrollView = [UIScrollView new];
        scrollView.backgroundColor = [UIColor clearColor];
        [self.view addSubview:scrollView];
        scrollView.frame = self.view.bounds;
        scrollView.contentSize = CGSizeMake(KScreenW, KScreenH * 3);
        scrollView.pagingEnabled = YES;
        scrollView.delegate = self;
        
        scrollView;
    });
    
    self.firstPlayView = ({
        DKVideoView *videoView = [[DKVideoView alloc] initWithFrame:CGRectMake(0, 0, KScreenW, KScreenH)];
        [self.scrollView addSubview:videoView];
        //        imageView.image = [UIImage imageNamed:@"placeholder1"];
        
        videoView;
    });
    
    self.secondPlayView = ({
        DKVideoView *videoView = [[DKVideoView alloc] initWithFrame:CGRectMake(0, KScreenH, KScreenW, KScreenH)];
        [self.scrollView addSubview:videoView];
        //        imageView.image = [UIImage imageNamed:@"placeholder1"];
        //        imageView.jp_videoPlayerDelegate = self;
        videoView;
    });
    
    self.thridPlayView = ({
        DKVideoView *videoView = [[DKVideoView alloc] initWithFrame:CGRectMake(0, KScreenH * 2, KScreenW, KScreenH)];
        [self.scrollView addSubview:videoView];
        //        imageView.image = [UIImage imageNamed:@"placeholder1"];
        videoView;
    });
}

- (void)notReachableView{
    if (!_noNetView) {
        _noNetView = [[UIImageView alloc] init];
        _noNetView.image = [UIImage imageNamed:@"bg_noNet"];
        _noNetView.userInteractionEnabled = YES;
        [self.view addSubview:_noNetView];
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapAction:)];
        [_noNetView addGestureRecognizer:tap];
        UIImageView *imgView = [[UIImageView alloc] init];
        imgView.image = [UIImage imageNamed:@"icon_wlgz"];
        imgView.contentMode = UIViewContentModeScaleAspectFit;
        [_noNetView addSubview:imgView];
        UILabel *label = [[UILabel alloc] init];
        label.text = @"网络错误，点击重新加载";
        label.font = [UIFont systemFontOfSize:PXTOPT(28)];
        label.textColor = [UIColor colorWithHexString:@"#999999"];
        label.textAlignment = NSTextAlignmentCenter;
        [_noNetView addSubview:label];
        
        [_noNetView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.top.bottom.mas_equalTo(self.view);
        }];
        
        [imgView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.mas_equalTo(self.noNetView);
            make.centerY.mas_equalTo(self.noNetView).mas_offset(-50);
            make.height.mas_equalTo(PXTOPT(144));
            make.width.mas_equalTo(PXTOPT(182));
        }];
        
        [label mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.mas_equalTo(self.noNetView);
            make.top.mas_equalTo(imgView.mas_bottom).mas_equalTo(20);
            make.height.mas_equalTo(PXTOPT(30));
        }];
    }
}

- (void)tapAction:(UITapGestureRecognizer *)tap{
    NSLog(@"重新加载");
}

#pragma mark -网络状态-

- (void)reachabilityStatusViaWWAN:(NSNotification *)noti{// 流量的提示
    int networkState = [[noti object] intValue];
    switch (networkState) {
        case -1:
            //未知网络状态
            self.scrollView.hidden = NO;
            self.noNetView.hidden = YES;
            break;
            
        case 0:
            //没有网络
            self.scrollView.hidden = YES;
            self.noNetView.hidden = NO;
            break;
            
        case 1:
            //3G或者4G，反正用的是流量
            self.scrollView.hidden = NO;
            self.noNetView.hidden = YES;
            [self ViaWWAN];
            break;
            
        case 2:
            //WIFI网络
            self.scrollView.hidden = NO;
            self.noNetView.hidden = YES;
            break;
            
        default:
            break;
    }
}

- (void)ViaWWAN{
    [self.secondPlayView.player pause];
    DKViaWWANViewController *vc = [[DKViaWWANViewController alloc] initWith:^(PlayState state) {
        if (state == PlayState_play) {
            NSLog(@"继续播放");
            [self.secondPlayView.player resume];
        }else{
            NSLog(@"暂停播放");
            [self.secondPlayView.player pause];
        }
    }];
    //    vc.model = cell.model;
    //把当前控制器作为背景
    self.definesPresentationContext = YES;
    
    //设置模态视图弹出样式
    vc.modalPresentationStyle = UIModalPresentationOverFullScreen;
    //创建动画
    CATransition * transition = [CATransition animation];
    
    //设置动画类型（这个是字符串，可以搜索一些更好看的类型）
    transition.type = @"moveOut";
    
    //动画出现类型
    transition.subtype = @"fromCenter";
    
    //动画时间
    transition.duration = 0.3;
    
    //移除当前window的layer层的动画
    [self.view.window.layer removeAllAnimations];
    
    //将定制好的动画添加到当前控制器window的layer层
    [self.view.window.layer addAnimation:transition forKey:nil];
    
    [self presentViewController:vc animated:NO completion:nil];
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

- (UIImageView *)bgView{
    if (!_bgView) {
        _bgView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"bg_noNet"]];
        [self.view addSubview:_bgView];
        [_bgView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.top.bottom.mas_equalTo(self.view);
        }];
    }
    return _bgView;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

@end
