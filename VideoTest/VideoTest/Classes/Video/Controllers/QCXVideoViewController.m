//
//  QCXVideoViewController.m
//  VideoTest
//
//  Created by 乔春晓 on 2018/7/13.
//  Copyright © 2018年 乔春晓. All rights reserved.
//

#import "QCXVideoViewController.h"
#import "QCXVideoCell.h"
#import "VideoDataModel.h"

@interface QCXVideoViewController ()<UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout>
@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, strong) NSMutableArray *dataArr;
@property (nonatomic, strong) QCXVideoCell *currentCell;
@property (nonatomic, strong) QCXVideoCell *lastCell;
@end

static NSString *cellId = @"cellId";

@implementation QCXVideoViewController

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES];
//    [self.navigationController.navigationBar setBackgroundImage:[UIImage new] forBarMetrics:UIBarMetricsDefault];
//    //去掉导航栏底部的黑线
//    self.navigationController.navigationBar.shadowImage = [UIImage new];
}

- (void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
    [self.navigationController setNavigationBarHidden:NO];
//    [self.navigationController.navigationBar setBackgroundImage:nil forBarMetrics:UIBarMetricsDefault];
//    [self.navigationController.navigationBar setShadowImage:nil];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor redColor];
    
    [self proportyData];
    
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
    [self.view addSubview:_collectionView];
    
    [_collectionView registerClass:[QCXVideoCell class] forCellWithReuseIdentifier:cellId];
    
    if (@available(iOS 11.0, *)) {
        self.collectionView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    }
    
}



- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return _dataArr.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    QCXVideoCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:cellId forIndexPath:indexPath];
    CGFloat r = arc4random() % 255 / 255.0;
    CGFloat g = arc4random() % 255 / 255.0;
    CGFloat b = arc4random() % 255 / 255.0;
    cell.contentView.backgroundColor = [UIColor colorWithRed:r green:g blue:b alpha:1];
    if (_currentCell) {
        _lastCell = _currentCell;
        NSLog(@"----------------------");
//        [_lastCell.player pause];
    }
    _currentCell = cell;
    VideoDataModel *model = _dataArr[indexPath.item];
    cell.urlStr = model.video_url;
    return cell;
}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    QCXVideoCell * cell = (QCXVideoCell *)[collectionView cellForItemAtIndexPath:indexPath];
    if ([cell.player isPlaying]) {
        [cell.player pause];
//        _isPlaying = NO;
    }else{
        [cell.player resume];
//        _isPlaying = YES;
    }
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    if ([_currentCell.player isPlaying]) {
        [_currentCell.player pause];
    }
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    [self scrollViewEndScroll:scrollView];
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
    if ( !decelerate ) {
        [self scrollViewEndScroll:scrollView];
    }
}

- (void)scrollViewEndScroll:(UIScrollView *)scrollView {
    // do something ...
    NSLog(@"============================");
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)proportyData{
//    NSMutableArray* mutablePosts = @[@"https://api.huoshan.com/hotsoon/item/video/_playback/?video_id=bea0903abb954f58ac0e17c21226a3c3&line=0&app_id=1115&watermark=1",@"https://api.huoshan.com/hotsoon/item/video/_playback/?video_id=e3da4d9917364f2b8f5826487563d763&line=0&app_id=1115&watermark=1",@"https://api.huoshan.com/hotsoon/item/video/_playback/?video_id=e486dc4931d041c1b5405e9fcb35e0ac&line=0&app_id=1115&watermark=1",@"https://api.huoshan.com/hotsoon/item/video/_playback/?video_id=f56df03dea804541a9fcd4d1cc26eefd&line=0&app_id=1115&watermark=1",@"https://api.huoshan.com/hotsoon/item/video/_playback/?video_id=15105c5f27db4c789b8ba43c3e5056c4&line=0&app_id=1115&watermark=1",@"https://api.huoshan.com/hotsoon/item/video/_playback/?video_id=dcb9b966feaf44b9bbb182ed6ec18905&line=0&app_id=1115&watermark=1",@"https://api.huoshan.com/hotsoon/item/video/_playback/?video_id=b05b22407e0c4ecfa9b9d9d61b3cde8d&line=0&app_id=1115&watermark=1",@"https://api.huoshan.com/hotsoon/item/video/_playback/?video_id=3addc2c120c64055b4d8d5aa02ed0358&line=0&app_id=1115&watermark=1",@"https://api.huoshan.com/hotsoon/item/video/_playback/?video_id=0023998b5c434594a341aa14ca246e78&line=0&app_id=1115&watermark=1",@"https://api.huoshan.com/hotsoon/item/video/_playback/?video_id=89a4c97611cb4e968ee527064910f8f5&line=0&app_id=1115&watermark=1",@"https://api.huoshan.com/hotsoon/item/video/_playback/?video_id=a3480c04fb474d8abe67b92ba3092385&line=0&app_id=1115&watermark=1",@"https://api.huoshan.com/hotsoon/item/video/_playback/?video_id=a32e93a6db1946b1923dab80426cf408&line=0&app_id=1115&watermark=1",@"https://api.huoshan.com/hotsoon/item/video/_playback/?video_id=4066031765e64444aec56555c7916c88&line=0&app_id=1115&watermark=1",@"https://api.huoshan.com/hotsoon/item/video/_playback/?video_id=de5fb0f7a58c474f99b0e36f14ab4f5e&line=0&app_id=1115&watermark=1",@"https://api.huoshan.com/hotsoon/item/video/_playback/?video_id=f74e414de26c4c3ab496e145e2133e4e&line=0&app_id=1115&watermark=1",@"https://api.huoshan.com/hotsoon/item/video/_playback/?video_id=e46a3badde1c4c45bdbd955f8cc3d4a0&line=0&app_id=1115&watermark=1",@"https://api.huoshan.com/hotsoon/item/video/_playback/?video_id=05cea72731f048dbb88e330a36ec5d7b&line=0&app_id=1115&watermark=1",@"https://api.huoshan.com/hotsoon/item/video/_playback/?video_id=287a0f388ff94132a0378590ce2ea10a&line=0&app_id=1115&watermark=1",@"https://api.huoshan.com/hotsoon/item/video/_playback/?video_id=ca29113defee42629100e25bae76f0cb&line=0&app_id=1115&watermark=1",@"https://api.huoshan.com/hotsoon/item/video/_playback/?video_id=47e79e358ccb4c068e17ff428589b890&line=0&app_id=1115&watermark=1",@"https://api.huoshan.com/hotsoon/item/video/_playback/?video_id=f8f3e8f939c74180ac58a07ae1c3db67&line=0&app_id=1115&watermark=1",@"https://api.huoshan.com/hotsoon/item/video/_playback/?video_id=94ecd0c72cc44a53ba10903430e725b7&line=0&app_id=1115&watermark=1",@"https://api.huoshan.com/hotsoon/item/video/_playback/?video_id=2f95ed89e7674f45a8c1dd42b1d7dca7&line=0&app_id=1115&watermark=1",@"https://api.huoshan.com/hotsoon/item/video/_playback/?video_id=02659682c15a48ccaa804f8529c77403&line=0&app_id=1115&watermark=1",@"https://api.huoshan.com/hotsoon/item/video/_playback/?video_id=9c847635c5c7448e87276e0af4b84312&line=0&app_id=1115&watermark=1",@"https://api.huoshan.com/hotsoon/item/video/_playback/?video_id=93836edd53674014b27e1635beeffcef&line=0&app_id=1115&watermark=1",@"https://api.huoshan.com/hotsoon/item/video/_playback/?video_id=31e409d479b246f38f3d78ad6db6a101&line=0&app_id=1115&watermark=1",@"https://api.huoshan.com/hotsoon/item/video/_playback/?video_id=38f8410535a64da7b4a478432aa8abc8&line=0&app_id=1115&watermark=1",@"https://api.huoshan.com/hotsoon/item/video/_playback/?video_id=6b5148345c2d48ce8567a17dbf2f45ca&line=0&app_id=1115&watermark=1",@"https://api.huoshan.com/hotsoon/item/video/_playback/?video_id=41267809310d4501ba7cf451291063de&line=0&app_id=1115&watermark=1",@"https://api.huoshan.com/hotsoon/item/video/_playback/?video_id=62847ccc4a4f489191f3cf33b1dc67ba&line=0&app_id=1115&watermark=1",@"https://api.huoshan.com/hotsoon/item/video/_playback/?video_id=6dbed011226d4f0684e94d498b9b8225&line=0&app_id=1115&watermark=1",@"https://api.huoshan.com/hotsoon/item/video/_playback/?video_id=fb79ed4429da4d9e8b092df7c5583961&line=0&app_id=1115&watermark=1",@"https://api.huoshan.com/hotsoon/item/video/_playback/?video_id=d577e3909d6747c88d302f99821bb07e&line=0&app_id=1115&watermark=1",@"https://api.huoshan.com/hotsoon/item/video/_playback/?video_id=6cc1e35d135c4435872d40a9c7042d92&line=0&app_id=1115&watermark=1",@"https://api.huoshan.com/hotsoon/item/video/_playback/?video_id=4bdc8186c3c54c77b84b06fed8b6c60b&line=0&app_id=1115&watermark=1",@"https://api.huoshan.com/hotsoon/item/video/_playback/?video_id=2ceb37d4f33b4df0b65dd870f213f39c&line=0&app_id=1115&watermark=1",@"https://api.huoshan.com/hotsoon/item/video/_playback/?video_id=819a2fdc8694479cada31f48c9f282a2&line=0&app_id=1115&watermark=1",@"https://api.huoshan.com/hotsoon/item/video/_playback/?video_id=0cdfe30b18ae4859ba6935474006ce38&line=0&app_id=1115&watermark=1",@"https://api.huoshan.com/hotsoon/item/video/_playback/?video_id=cc2cdbc32b3c4c3985785328a8d6c718&line=0&app_id=1115&watermark=1"].mutableCopy;
    
    NSMutableArray* tempAry = [NSMutableArray array];
    NSMutableArray* mutableAry = [NSMutableArray array];
    _dataArr = [NSMutableArray array];
    __block UICollectionView *blockCollectionView = _collectionView;
    [VideoDataModel getHomePageVideoDataWithBlock:^(NSArray *dateAry, NSError *error) {
        [tempAry addObjectsFromArray:dateAry];
        for (VideoDataModel* model in tempAry) {
            [mutableAry addObject:model];
        }
        [self.dataArr addObjectsFromArray:mutableAry];
//        dispatch_async(dispatch_get_main_queue(), ^{
//            [blockCollectionView reloadData];
//        });
        [blockCollectionView reloadData];
    }];
    
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
