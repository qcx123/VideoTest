//
//  DKProgramView.h
//  VideoTest
//
//  Created by 乔春晓 on 2018/7/24.
//  Copyright © 2018年 乔春晓. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DKProgramView : UIView
/**
 进度
 */
@property (nonatomic, assign) CGFloat progress;

// 开始加载
- (void)starLoading;
// 结束加载
- (void)stopLoading;
// 设置声音
- (void)changeVolume:(CGFloat)volume;
@end
