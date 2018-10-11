//
//  DKNetInfo.m
//  VideoTest
//
//  Created by 乔春晓 on 2018/7/19.
//  Copyright © 2018年 乔春晓. All rights reserved.
//

#import "DKNetInfo.h"

@implementation DKNetInfo

static DKNetInfo* _instance = nil;

+ (instancetype) shareInstance
{
    static dispatch_once_t onceToken ;
    dispatch_once(&onceToken, ^{
        _instance = [[self alloc] init] ;
    }) ;
    
    return _instance ;
}


@end
