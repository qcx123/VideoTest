//
//  DKGameMainViewController.m
//  VideoTest
//
//  Created by 乔春晓 on 2018/8/27.
//  Copyright © 2018年 乔春晓. All rights reserved.
//

#import "DKGameMainViewController.h"
#import "DKGameMsgCell.h"
#import "DKGameGiftCell.h"
#import "DKGameVideoListCell.h"
#import "DKVideoListInfo.h"

@interface DKGameMainViewController ()<UITableViewDelegate,UITableViewDataSource>
/**
 table
 */
@property (nonatomic, strong) UITableView *tableView;
@end

static NSString *magCell       = @"msgCell";
static NSString *giftCell      = @"giftCell";
static NSString *videoListCell = @"videoListCell";

@implementation DKGameMainViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 64, KScreenW, KScreenH - 64) style:(UITableViewStylePlain)];
    _tableView.dataSource = self;
    _tableView.delegate = self;
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:_tableView];
    [_tableView registerClass:[DKGameMsgCell class] forCellReuseIdentifier:magCell];
    [_tableView registerClass:[DKGameGiftCell class] forCellReuseIdentifier:giftCell];
    [_tableView registerClass:[DKGameVideoListCell class] forCellReuseIdentifier:videoListCell];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        DKGameMsgCell *cell = (DKGameMsgCell *)[self tableView:tableView cellForClass:@"DKGameMsgCell" withId:magCell];
        return cell;
    }else if (indexPath.section == 1){
        DKGameGiftCell *cell = (DKGameGiftCell *)[self tableView:tableView cellForClass:@"DKGameGiftCell" withId:giftCell];
        return cell;
    }else{
        DKGameVideoListCell *cell = (DKGameVideoListCell *)[self tableView:tableView cellForClass:@"DKGameVideoListCell" withId:videoListCell];
        return cell;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        return 450;
    }else if (indexPath.section == 1){
        return 90;
    }else{
//        NSInteger rowCount = 100 % 3 ? 100 / 3 + 1 : 100 / 3;
        NSInteger rowCount = 100 / 3 + 1;
        return RowHeight * rowCount + RowMargin * (rowCount - 1) + 2 * EdgeTopBottom;
    }
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    if (section == 2) {
        UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, KScreenW, 30)];
        headerView.backgroundColor = [UIColor whiteColor];
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(15, 0, KScreenW - 30, 30)];
        label.text = @"相关视频";
        [headerView addSubview:label];
        return headerView;
    }
    return nil;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (section == 2) {
        return 30;
    }
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForClass:(NSString *)className withId:(NSString *)cellId {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
    if (!cell) {
        cell = [[NSClassFromString(className) alloc] initWithStyle:(UITableViewCellStyleDefault) reuseIdentifier:cellId];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
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
