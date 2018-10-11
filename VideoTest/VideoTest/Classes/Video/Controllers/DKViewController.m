//
//  DKViewController.m
//  VideoTest
//
//  Created by 乔春晓 on 2018/7/16.
//  Copyright © 2018年 乔春晓. All rights reserved.
//

#import "DKViewController.h"
#import "DKViaWWANViewController.h"
#import "DKSecondViewController.h"

#import "DKPlayerScrollView.h"
#import "DKScrollView.h"
#import "DKVideoLeftView.h"

#import "VideoDataModel.h"

#import <TXVodPlayer.h>
#import <MJRefresh.h>

#import "UIImage+DKImage.h"
#import "UIColor+Extension.h"
#import "UIViewController+InteractivePushGesture.h"

#define SCREEN_WIDTH [UIScreen mainScreen].bounds.size.width
#define SCREEN_HEIGHT [UIScreen mainScreen].bounds.size.height

@interface DKViewController ()<DKScrollViewDelegate,DKPlayerScrollViewDelegate,UIViewControllerInteractivePushGestureDelegate,DKVideoLeftViewDelegate>
@property (nonatomic, strong) UISwipeGestureRecognizer *leftSwipeGestureRecognizer;
@property (nonatomic , strong) UISwipeGestureRecognizer *rightSwipeGestureRecognizer;
@property (nonatomic , strong) DKVideoLeftView *leftView;
@property (nonatomic , strong) DKVideoView* player;
@property (nonatomic , strong) DKScrollView* playerScrollView;
//@property (nonatomic , strong) DKPlayerScrollView* playerScrollView;
@property (nonatomic, strong) UIImageView *noNetView;
@property (nonatomic, strong) UIImageView *bgView;
@end

@implementation DKViewController

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    if (_player) {
        [_player resume];
    }else{
//        self.playerScrollView.middlePlayer.isAutoPlay = YES;
        _player = self.playerScrollView.middlePlayer;
        [self.playerScrollView.middlePlayer play];
    }
    
    self.tabBarController.tabBar.backgroundImage = [UIImage imageWithColor:[UIColor colorWithWhite:0 alpha:0.3] size:CGSizeMake(KScreenW,TabBar_HEIGHT)];
    [self.tabBarController.tabBar setShadowImage:[UIImage imageWithColor:[UIColor clearColor] size:CGSizeMake(KScreenW,0.5)]];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    if (_player) {
        [_player pause];
    }else{
        [self.playerScrollView.middlePlayer pause];
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor greenColor];
    [self setNavigation];
    [self notReachableView];
    [self bgView];
    [self initUI];
    [self initPlayer];
    [self proportyData];
    [self setUpLeftMenuView];
    self.noNetView.hidden = YES;
    [self.view addSubview:self.naviView];
    self.interactivePushGestureEnabled = YES;
    self.interactivePushGestureDelegate = self;
    
    [self addObserver];
    
    self.playerScrollView.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(headRefresh)];
    
    self.playerScrollView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(footerRefresh)];
}

- (void)proportyData{
    NSMutableArray* tempAry = [NSMutableArray array];
    NSMutableArray* mutableAry = [NSMutableArray array];
    self.dataList = [NSMutableArray array];
    
    NSString *str = @"";
    __block NSString *blockStr = str;
    [VideoDataModel getHomePageVideoDataWithBlock:^(NSArray *dateAry, NSError *error) {
        [tempAry addObjectsFromArray:dateAry];
        NSLog(@"-----------------------");
        for (VideoDataModel* model in tempAry) {
            VideoInfoModel * item = [[VideoInfoModel alloc] init];
            //    item = live;
            item.VideoAddress = model.video_url;
            NSLog(@"%@",item.VideoAddress);
            item.coverImageAddress = model.cover_url;
            [mutableAry addObject:item];
            //        [str stringByAppendingString:[NSString stringWithFormat:@"%@,",item.VideoAddress]];
            //        str = [NSString stringWithFormat:@"@\"%@\",@\"%@\"",str,item.VideoAddress];
            blockStr = [NSString stringWithFormat:@"@\"%@\",@\"%@\"",blockStr,item.VideoAddress];
        }
        NSLog(@"%@",blockStr);
        NSLog(@"-----------------------");
        [self.dataList addObjectsFromArray:mutableAry];
        
        [self.playerScrollView updateForLives:self.dataList withCurrentIndex:self.index];
    }];
}

#pragma mark - 下拉刷新

- (void)headRefresh{
    [self performSelector:@selector(waiting) withObject:nil afterDelay:5.0];
}

#pragma mark - 上拉加载

- (void)footerRefresh{
    [self performSelector:@selector(waiting) withObject:nil afterDelay:5.0];
}

- (void)waiting{
    [self.playerScrollView.mj_header endRefreshing];
    [self.playerScrollView.mj_footer endRefreshing];
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

-(void) initUI
{
    [self.playerScrollView updateForLives:self.dataList withCurrentIndex:self.index];
    self.playerScrollView.playerDelegate = self;
    [self.view addSubview:self.playerScrollView];
}

-(void) initPlayer
{
    [[NSNotificationCenter defaultCenter]addObserver:self
                                            selector:@selector(handlePlayerNotify:)
                                                name:(MPMoviePlayerFirstVideoFrameRenderedNotification)
                                              object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self
                                            selector:@selector(handlePlayerPreparedToPlayNotify:)
                                                name:(MPMediaPlaybackIsPreparedToPlayDidChangeNotification)
                                              object:nil];
    
    
    
    //  MPMoviePlayerFirstVideoFrameRenderedNotification
}
-(void)handlePlayerPreparedToPlayNotify:(NSNotification*)notify{
    
    DKVideoView* cor = notify.object;
    NSLog(@"handlePlayerPreparedToPlayNotify %ld  and y==%lf ",(long)cor.tag ,cor.frame.origin.y  );
    
    switch (cor.tag) {
        case 10001:
        {
            if (self.playerScrollView.upPerPlayer.frame.origin.y == SCREEN_HEIGHT) {
                [self.playerScrollView.upPerPlayer resume];
                
            }
        }
            break;
        case 10002:
        {
            if (self.playerScrollView.middlePlayer.frame.origin.y == SCREEN_HEIGHT) {
                [self.playerScrollView.middlePlayer resume];
            }
        }
            break;
        case 10003:
        {
            {
                if (self.playerScrollView.downPlayer.frame.origin.y == SCREEN_HEIGHT) {
                    [self.playerScrollView.downPlayer resume];
                }
            }
        }
            break;
            
        default:
            break;
    }
    
}

-(void)handlePlayerNotify:(NSNotification*)notify{
    
    DKVideoView* cor = notify.object;
    _player = cor;
    NSLog(@"handlePlayerNotify  and y==%lf ",cor.frame.origin.y );
    switch (cor.tag) {
        case 10001:
        {
            if (self.playerScrollView.upPerPlayer.frame.origin.y == SCREEN_HEIGHT) {
                [self.playerScrollView.upPerPlayer setHidden:false];
            }
        }
            break;
        case 10002:
        {
            if (self.playerScrollView.middlePlayer.frame.origin.y == SCREEN_HEIGHT) {
                [self.playerScrollView.middlePlayer setHidden:false];
            }
        }
            break;
        case 10003:
        {
            {
                if (self.playerScrollView.downPlayer.frame.origin.y == SCREEN_HEIGHT) {
                    [self.playerScrollView.downPlayer setHidden:false];
                }
            }
        }
            break;
            
        default:
            break;
    }
}


- (void)reloadPlayerWithLive:(VideoInfoModel *)live
{
    
    
    //  [self.player reset:false];
    //  [self.player.view setHidden:true];
    //  [self.player setUrl:[NSURL URLWithString:live.VideoAddress]];
    //  [self.player setShouldAutoplay:YES];
    //  [self.player setBufferSizeMax:1];
    //  [self.player setShouldLoop:YES];
    //  self.player.view.backgroundColor = [UIColor clearColor];
    //  [self.player prepareToPlay];
    
}


#pragma mark DYPlayerScrollViewDelegate

- (void)playerScrollView:(DKScrollView *)playerScrollView currentPlayerIndex:(NSInteger)index
{
    NSLog(@"current index from delegate:%ld  %s",(long)index,__FUNCTION__);
    if (self.index == index) {
        return;
    } else {
        [self reloadPlayerWithLive:self.dataList[index]];
        
        if (playerScrollView.upPerPlayer.y == SCREEN_HEIGHT) {
            //      [playerScrollView.upPerPlayer prepareToPlay];
            
//            [playerScrollView.upPerPlayer setHidden:true];
//            if ([playerScrollView.upPerPlayer isPreparedToPlay]) {
//                if (playerScrollView.upPerPlayer.currentPlaybackTime >  0.1) {
//                    [playerScrollView.upPerPlayer setHidden:false];
//                }
//                [playerScrollView.upPerPlayer play];
//            }
            [playerScrollView.upPerPlayer setHidden:false];
            [playerScrollView.upPerPlayer play];
            
            [playerScrollView.middlePlayer stopPlay];
            [playerScrollView.downPlayer stopPlay];
//            [playerScrollView.downPlayer setHidden:true];
//            [playerScrollView.middlePlayer setHidden:true];
        }
        
        if (playerScrollView.middlePlayer.frame.origin.y == SCREEN_HEIGHT) {
//            [playerScrollView.middlePlayer setHidden:true];
//            if ([playerScrollView.middlePlayer isPreparedToPlay]) {
//                if (playerScrollView.middlePlayer.currentPlaybackTime >  0.1) {
//                    [playerScrollView.middlePlayer setHidden:false];
//                }
//                [playerScrollView.middlePlayer play];
//            }
            [playerScrollView.middlePlayer setHidden:false];
            [playerScrollView.middlePlayer play];
            
            [playerScrollView.upPerPlayer stopPlay];
            [playerScrollView.downPlayer stopPlay];
//            [playerScrollView.downPlayer setHidden:true];
//            [playerScrollView.upPerPlayer setHidden:true];
        }
        
        if (playerScrollView.downPlayer.frame.origin.y == SCREEN_HEIGHT) {
//            [playerScrollView.downPlayer setHidden:true];
//            if ([playerScrollView.downPlayer isPreparedToPlay]) {
//                if (playerScrollView.downPlayer.currentPlaybackTime >  0.1) {
//                    [playerScrollView.downPlayer setHidden:false];
//                }
//                [playerScrollView.downPlayer play];
//            }
            [playerScrollView.downPlayer setHidden:false];
            [playerScrollView.downPlayer play];
            
            [playerScrollView.upPerPlayer stopPlay];
            [playerScrollView.middlePlayer stopPlay];
            
//            [playerScrollView.upPerPlayer setHidden:true];
//            [playerScrollView.middlePlayer setHidden:true];
        }
        
        self.index = index;
    }
    
}

#pragma mark -lazy-

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

- (DKScrollView *)playerScrollView
{
    if (!_playerScrollView) {
        _playerScrollView = [[DKScrollView alloc] initWithFrame:self.view.frame];
        _playerScrollView.playerDelegate = self;
        _playerScrollView.index = self.index;
    }
    return _playerScrollView;
}

- (void)setNavigation{
    [self.leftBtn setImage:[UIImage imageNamed:@"btn_cbl"] forState:(UIControlStateNormal)];
    [self.leftBtn setTitle:@"" forState:(UIControlStateNormal)];
    self.leftBtn.frame = CGRectMake(15, 44, 60, 20);
    [self.rightBtn setImage:[UIImage imageNamed:@"btn_phb"] forState:(UIControlStateNormal)];
    [self.rightBtn setTitle:@"" forState:(UIControlStateNormal)];
    self.rightBtn.frame = CGRectMake(KScreenW - 15 - 60, 44, 60, 20);
    self.titleLabel.text = @"";
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
    DKSecondViewController *vc = [[DKSecondViewController alloc] init];
    vc.view.backgroundColor = [UIColor colorWithRed:arc4random_uniform(256)/255.0 green:arc4random_uniform(256)/255.0 blue:arc4random_uniform(256)/255.0 alpha:1.0];
    return vc;
}

#pragma mark -无网络界面-

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
            self.playerScrollView.hidden = NO;
            self.noNetView.hidden = YES;
            break;
            
        case 0:
            //没有网络
            self.playerScrollView.hidden = YES;
            self.noNetView.hidden = NO;
            if ([self.player isPlaying]) {
                [self.player pause];
            }
            break;
            
        case 1:
            //3G或者4G，反正用的是流量
            self.playerScrollView.hidden = NO;
            self.noNetView.hidden = YES;
            [self ViaWWAN];
            break;
            
        case 2:
            //WIFI网络
            self.playerScrollView.hidden = NO;
            self.noNetView.hidden = YES;
            if (self.isViewLoaded && self.view.window) {
                NSLog(@"屏幕上");
                [_player resume];
            }
            break;
            
        default:
            break;
    }
}

- (void)ViaWWAN{
    [self.player pause];
    DKViaWWANViewController *vc = [[DKViaWWANViewController alloc] initWith:^(PlayState state) {
        if (state == PlayState_play) {
            NSLog(@"继续播放");
            [self.player resume];
        }else{
            NSLog(@"暂停播放");
            [self.player pause];
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
