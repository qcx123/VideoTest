//
//  DKViewController.h
//  VideoTest
//
//  Created by 乔春晓 on 2018/7/16.
//  Copyright © 2018年 乔春晓. All rights reserved.
//

#import "DKBaseViewController.h"
#import "VideoInfoModel.h"
@interface DKViewController : DKBaseViewController

@property (nonatomic, strong) VideoInfoModel *live;
@property (nonatomic, strong) NSMutableArray *dataList;
@property (nonatomic, assign) NSInteger index;
@end
