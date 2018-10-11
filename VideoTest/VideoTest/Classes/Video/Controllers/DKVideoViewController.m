//
//  DKVideoViewController.m
//  VideoTest
//
//  Created by 乔春晓 on 2018/7/13.
//  Copyright © 2018年 乔春晓. All rights reserved.
//

#import "DKVideoViewController.h"
#import "DKViaWWANViewController.h"
#import "DKGameMainViewController.h"

#import "DKVideoCell.h"
#import "DKVideoLeftView.h"

#import "VideoDataModel.h"
#import "VideoInfoModel.h"

#import <MJRefresh.h>
#import "UIImage+DKImage.h"
#import "UIColor+Extension.h"
#import "UIViewController+InteractivePushGesture.h"
#import <TXVodDownloadManager.h>
#import <MediaPlayer/MediaPlayer.h>
#import <AVFoundation/AVFoundation.h>

typedef enum {// 播放状态
    PlayerState_Init, // 初始化
    PlayerState_Play, // 播放
    PlayerState_Pause,// 暂停
    PlayerState_Stop  // 结束
}PlayerState;

@interface DKVideoViewController ()<UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout,UIViewControllerInteractivePushGestureDelegate,DKVideoLeftViewDelegate,DKVideoCellDelegate,UIGestureRecognizerDelegate>
@property (nonatomic, strong) MPVolumeView *mpVolumeView;
@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, strong) NSMutableArray *dataArr;
@property (nonatomic, strong) DKVideoCell *currentCell;
@property (nonatomic, strong) DKVideoCell *lastCell;
@property (nonatomic, strong) DKVideoLeftView *leftView;
@property (nonatomic, strong) UIImageView *noNetView;
@property (nonatomic, strong) UIImageView *bgView;
@property (nonatomic, strong) NSArray *visibleCellsArray;
@property (nonatomic, assign) PlayerState playerState;
@end

static NSString *cellId = @"cellId";

@implementation DKVideoViewController

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.tabBarController.tabBar.backgroundImage = [UIImage imageWithColor:[UIColor colorWithWhite:0 alpha:0.3] size:CGSizeMake(KScreenW,TabBar_HEIGHT)];
    [self.tabBarController.tabBar setShadowImage:[UIImage imageWithColor:[UIColor clearColor] size:CGSizeMake(KScreenW,0.5)]];
    if (_currentCell && _playerState == PlayerState_Play) {
        [_currentCell resume];
    }
    //注册程序进入前台通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector (enterForeground) name: UIApplicationWillEnterForegroundNotification object:nil];
    //注册程序进入后台通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector (enterBackground) name: UIApplicationDidEnterBackgroundNotification object:nil];
}

- (void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
    [_currentCell pause];
    //解除程序进入前台通知
    [[NSNotificationCenter defaultCenter] removeObserver:self name: UIApplicationWillEnterForegroundNotification object:nil];
    //解除程序进入后台通知
    [[NSNotificationCenter defaultCenter] removeObserver:self name: UIApplicationDidEnterBackgroundNotification object:nil];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    [self proportyData];
    [self initUI];
    self.interactivePushGestureEnabled = YES;
    self.interactivePushGestureDelegate = self;
    [self addObserver];
}

#pragma mark -UICollectionView-

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return _dataArr.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    DKVideoCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:cellId forIndexPath:indexPath];
    CGFloat r = arc4random() % 255 / 255.0;
    CGFloat g = arc4random() % 255 / 255.0;
    CGFloat b = arc4random() % 255 / 255.0;
    cell.contentView.backgroundColor = [UIColor colorWithRed:r green:g blue:b alpha:1];
    cell.delegate = self;
    _playerState = PlayerState_Init;
    VideoInfoModel *model = _dataArr[indexPath.item];
    cell.model = model;
    if (!_currentCell) {
        _currentCell = cell;
        [cell play];
        _playerState = PlayerState_Play;
    }
    return cell;
}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    DKVideoCell * cell = (DKVideoCell *)[collectionView cellForItemAtIndexPath:indexPath];
    if ([cell isPlaying]) {
        [cell pause];
        _playerState = PlayerState_Pause;
    }else{
        [cell resume];
        _playerState = PlayerState_Play;
    }
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    if ([_collectionView visibleCells].count > 1) {
        _visibleCellsArray = [_collectionView visibleCells];
    }
//    NSLog(@"%@",_visibleCellsArray);
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    // 停止类型1、停止类型2
    BOOL scrollToScrollStop = !scrollView.tracking && !scrollView.dragging && !scrollView.decelerating;
    if (scrollToScrollStop) {
        [self scrollViewDidEndScroll:scrollView];
    }
}

#pragma mark - scrollView 滚动停止
- (void)scrollViewDidEndScroll:(UIScrollView *)scrollView {
    NSLog(@"停止滚动了！！！");
    for (DKVideoCell *cell in _visibleCellsArray) {
        CGRect rect = [_collectionView convertRect:cell.frame toView:self.view];
        if (rect.origin.y == 0) {
            if ([cell isPlaying]) {
                NSLog(@"正在播放");
            }else{
                if (cell.progressView.progress == 0.0) {
                    [cell play];
                    NSLog(@"开始播放");
                }else{
                    [cell resume];
                    NSLog(@"继续播放");
                }
            }
            _currentCell = cell;
            [cell.progressView starLoading];
        }else{
            [cell stopPlay];
            cell.progressView.progress = 0.0;
            _lastCell = cell;
            NSLog(@"停止播放");
        }
    }
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
    [self.collectionView.mj_header endRefreshing];
    [self.collectionView.mj_footer endRefreshing];
}

- (void)addObserver{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reachabilityStatusViaWWAN:) name:@"netWorkChangeEventNotification" object:nil];// 网络检测变化
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(volumeChanged:) name:@"AVSystemController_SystemVolumeDidChangeNotification" object:nil];// 系统声音变化
}

- (void)removeObserver{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"netWorkChangeEventNotification" object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"AVSystemController_SystemVolumeDidChangeNotification" object:nil];
}

- (void)dealloc{
    [self removeObserver];
}

-(void) initUI
{
    [self bgView];
    [self notReachableView];
    [self setUpLeftMenuView];
    self.noNetView.hidden = YES;
    [self.view addSubview:self.collectionView];
    [self setNavigation];
    [self volumeView];
}

- (void)volumeView{
    if (_mpVolumeView == nil) {
        _mpVolumeView = [[MPVolumeView alloc] init];
        [_mpVolumeView setFrame:CGRectMake(-100, -100, 40, 40)];
        [_mpVolumeView setShowsVolumeSlider:YES];
        [_mpVolumeView sizeToFit];
    }
    [self.view addSubview:_mpVolumeView];
}

#pragma mark -lazy-

- (UICollectionView *)collectionView{
    if (!_collectionView) {
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
        layout.itemSize = CGSizeMake(KScreenW, KScreenH);
        layout.sectionInset = UIEdgeInsetsMake(0, 0, 0, 0);
        layout.minimumLineSpacing = 0;
        layout.minimumInteritemSpacing = 0;
        _collectionView = [[UICollectionView alloc] initWithFrame:self.view.frame collectionViewLayout:layout];
        _collectionView.backgroundColor = [UIColor clearColor];
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        _collectionView.pagingEnabled = YES;
        _collectionView.bounces = NO;
        [_collectionView registerClass:[DKVideoCell class] forCellWithReuseIdentifier:cellId];
        
        if (@available(iOS 11.0, *)) {
            _collectionView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
        }
//        _collectionView.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(headRefresh)];
//
//        _collectionView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(footerRefresh)];
    }
    return _collectionView;
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

- (void)setNavigation{
    [self.view bringSubviewToFront:self.naviView];
    self.naviView.backgroundColor = [UIColor clearColor];
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
    DKGameMainViewController *vc = [[DKGameMainViewController alloc] init];
//    vc.view.backgroundColor = [UIColor colorWithRed:arc4random_uniform(256)/255.0 green:arc4random_uniform(256)/255.0 blue:arc4random_uniform(256)/255.0 alpha:1.0];
    return vc;
}

- (void)lockScrollViewWithPanState:(PanState)panstate {
    switch (panstate) {
        case PanState_End:
            _collectionView.scrollEnabled = YES;
            break;
            
        case PanState_UpDown:
            _collectionView.scrollEnabled = YES;
            break;
            
        case PanState_LeftRight:
            _collectionView.scrollEnabled = NO;
            break;
        default:
            break;
    }
}

- (void)refreshScrollViewWithGesture:(UIPanGestureRecognizer *)panGesture {
    CGPoint translationTouchPoint = [panGesture translationInView:self.view];
    if (translationTouchPoint.y > 0 && _collectionView.contentOffset.y == 0) {// 向上（下拉刷新）
        NSLog(@"下拉translationTouchPointX = %lf , translationTouchPointY = %lf",translationTouchPoint.x,translationTouchPoint.y);
    }else if(translationTouchPoint.y < 0 && _collectionView.contentOffset.y == (_dataArr.count - 1) * KScreenH) {// 向下（上拉加载）
        NSLog(@"上拉translationTouchPointX = %lf , translationTouchPointY = %lf",translationTouchPoint.x,translationTouchPoint.y);
    }
}

#pragma mark -DKVideoCellDelegate-

- (void)netSign{
    //3G或者4G，反正用的是流量
    self.collectionView.hidden = NO;
    self.noNetView.hidden = YES;
    [self ViaWWAN];
}

- (void)shareVideo:(VideoInfoModel *)model {// 分享
    NSLog(@"分享");
}
- (void)likeVideo:(VideoInfoModel *)model { // 点赞
    NSLog(@"点赞");
}
- (void)downLoadVideo:(VideoInfoModel *)model { // 下载
    NSLog(@"下载");
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

#pragma mark -通知-
#pragma mark -网络状态-

- (void)reachabilityStatusViaWWAN:(NSNotification *)noti{// 流量的提示
    int networkState = [[noti object] intValue];
    switch (networkState) {
        case -1:
            //未知网络状态
            self.collectionView.hidden = NO;
            self.noNetView.hidden = YES;
            break;
            
        case 0:
            //没有网络
            self.collectionView.hidden = YES;
            self.noNetView.hidden = NO;
            if ([self.currentCell isPlaying]) {
                [self.currentCell pause];
            }
            break;
            
        case 1:
            //3G或者4G，反正用的是流量
            self.collectionView.hidden = NO;
            self.noNetView.hidden = YES;
            [self ViaWWAN];
            break;
            
        case 2:
            //WIFI网络
            self.collectionView.hidden = NO;
            self.noNetView.hidden = YES;
            if (self.isViewLoaded && self.view.window) {
                NSLog(@"屏幕上");
                [_currentCell resume];
            }
            break;
            
        default:
            break;
    }
}

- (void)ViaWWAN{
    [self.currentCell pause];
    DKViaWWANViewController *vc = [[DKViaWWANViewController alloc] initWith:^(PlayState state) {
        if (state == PlayState_play) {
            NSLog(@"继续播放");
            [self.currentCell resume];
        }else{
            NSLog(@"暂停播放");
            [self.currentCell pause];
        }
    }];
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

#pragma mark -进入前台-

- (void)enterForeground{
    if (_currentCell && _playerState == PlayerState_Play) {
        [_currentCell resume];
    }
}

#pragma mark -进入后台-

- (void)enterBackground{
    [_currentCell pause];
}

#pragma mark -音量显示控制-

- (void)volumeChanged:(NSNotification *)notification
{
    CGFloat volumeValue = [notification.userInfo[@"AVSystemController_AudioVolumeNotificationParameter"] floatValue];
    [_currentCell.progressView changeVolume:volumeValue];
}

- (void)proportyData{
    
    NSMutableArray* tempAry = [NSMutableArray array];
    NSMutableArray* mutableAry = [NSMutableArray array];
    _dataArr = [NSMutableArray array];
    __block UICollectionView *blockCollectionView = _collectionView;
    NSString *str = @"";
    __block NSString *blockStr = str;
    [VideoDataModel getHomePageVideoDataWithBlock:^(NSArray *dateAry, NSError *error) {
        [tempAry addObjectsFromArray:dateAry];
        NSLog(@"-----------------------");
        for (VideoDataModel* model in tempAry) {
            VideoInfoModel * item = [[VideoInfoModel alloc] init];
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
        [self.dataArr addObjectsFromArray:mutableAry];
        dispatch_async(dispatch_get_main_queue(), ^{
            [blockCollectionView reloadData];
        });
    }];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
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
