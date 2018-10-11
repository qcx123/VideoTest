//
//  DKViaWWANViewController.m
//  VideoTest
//
//  Created by 乔春晓 on 2018/7/17.
//  Copyright © 2018年 乔春晓. All rights reserved.
//

#import "DKViaWWANViewController.h"
#import "DKNetInfo.h"

@interface DKViaWWANViewController ()

@end

@implementation DKViaWWANViewController

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.naviView.hidden = YES;
}

- (instancetype)initWith:(PlayStateBlock)block{
    if ([super init]) {
        _block = block;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor colorWithWhite:0.3 alpha:0.3];
    [self setupUI];
}

- (void)setupUI{
    UIImageView *bgImgView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"bg_bjkb"]];
    [self.view addSubview:bgImgView];
    bgImgView.userInteractionEnabled = YES;
    
    UIImageView *iconView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"img_tp"]];
    iconView.contentMode = UIViewContentModeScaleAspectFit;
    [bgImgView addSubview:iconView];
    
    UILabel *tpLabel = [[UILabel alloc] init];
    tpLabel.numberOfLines = 0;
    tpLabel.textAlignment = NSTextAlignmentCenter;
    tpLabel.textColor = [UIColor colorWithHexString:@"#999999"];
    tpLabel.text = @"当前为非wifi环境，是否使用流量\n观看视频";
    tpLabel.font = [UIFont systemFontOfSize:14];
    [bgImgView addSubview:tpLabel];
    
    UIButton *pauseBtn = [UIButton buttonWithType:(UIButtonTypeCustom)];
    [pauseBtn setBackgroundImage:[UIImage imageNamed:@"btn_hui"] forState:(UIControlStateNormal)];
    [pauseBtn setTitle:@"暂停播放" forState:(UIControlStateNormal)];
    [pauseBtn addTarget:self action:@selector(pauseBtnAction:) forControlEvents:(UIControlEventTouchUpInside)];
    [bgImgView addSubview:pauseBtn];
    
    UIButton *playBtn = [UIButton buttonWithType:(UIButtonTypeCustom)];
    [playBtn setBackgroundImage:[UIImage imageNamed:@"btn_lan"] forState:(UIControlStateNormal)];
    [playBtn setTitle:@"继续播放" forState:(UIControlStateNormal)];
    [playBtn addTarget:self action:@selector(playBtnAction:) forControlEvents:(UIControlEventTouchUpInside)];
    [bgImgView addSubview:playBtn];
    
    [bgImgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self.view);
        make.top.mas_equalTo(self.view).mas_offset(120);
        make.width.mas_equalTo(KScreenW * 0.7);
        make.height.mas_equalTo(KScreenW * 0.9);
    }];
    
    [iconView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(bgImgView);
        make.top.mas_equalTo(bgImgView).mas_offset(30);
        make.width.mas_equalTo(bgImgView.mas_width).multipliedBy(0.5);
        make.height.mas_equalTo(bgImgView.mas_height).multipliedBy(0.5);
    }];
    
    [tpLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(bgImgView);
        make.right.mas_equalTo(bgImgView);
        make.top.mas_equalTo(iconView.mas_bottom).mas_offset(10);
        make.height.mas_equalTo(50);
    }];
    
    [pauseBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(bgImgView).mas_offset(18);
        make.width.mas_equalTo((KScreenW * 0.7 - 18 * 3) / 2.0);
        make.height.mas_equalTo(30);
        make.bottom.mas_equalTo(bgImgView).mas_offset(-30);
    }];
    
    [playBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(bgImgView).mas_offset(-18);
        make.width.mas_equalTo((KScreenW * 0.7 - 18 * 3) / 2.0);
        make.height.mas_equalTo(30);
        make.bottom.mas_equalTo(bgImgView).mas_offset(-30);
    }];
}

- (void)pauseBtnAction:(UIButton *)btn {
    [self dismissViewControllerAnimated:YES completion:nil];
    [DKNetInfo shareInstance].isAllow3G4GPlay = NO;
    _block(PlayState_Pause);
}

- (void)playBtnAction:(UIButton *)btn {
    [self dismissViewControllerAnimated:YES completion:nil];
    [DKNetInfo shareInstance].isAllow3G4GPlay = YES;
    _block(PlayState_play);
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
