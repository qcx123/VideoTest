//
//  DKNetInfo.h
//  VideoTest
//
//  Created by 乔春晓 on 2018/7/19.
//  Copyright © 2018年 乔春晓. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum {
    NetType_No,     // 无网络
    NetType_WIFI,   // wifi
    NetType_3G4G,   // 3G/4G
    NetType_Unknown // 未知网络
}NetType;

@interface DKNetInfo : NSObject
@property (nonatomic, assign) NetType netType;

/**
 是否允许3G4G情况播放
 */
@property (nonatomic, assign) BOOL isAllow3G4GPlay;

+ (instancetype) shareInstance;
@end
