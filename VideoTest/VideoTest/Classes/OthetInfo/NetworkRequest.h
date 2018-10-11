//
//  NetworkRequest.h
//  LessonDouBan
//
//  Created by qcx on 16/6/27.
//  Copyright © 2016年 yu. All rights reserved.
//

#import <Foundation/Foundation.h>
// 成功回调
typedef void(^SuccessResponse)(id data);
// 失败回调
typedef void(^FailureResponse)(NSError *error);

@protocol NetworkRequestDelegate <NSObject>
// 设置进度
- (void)setUpdateProgressWithTotalBytesSent:(int64_t)totalBytesSent totalBytesExpectedToSend:(int64_t)totalBytesExpectedToSend;
@end

@interface NetworkRequest : NSObject

/*
 代理
 */
@property (nonatomic, weak) id<NetworkRequestDelegate> delegate;

+ (instancetype)shareNetworkRequest;

/* 请求数据 GET
 @url:请求数据的url
 @parameterDic:请求的参数
 @success:成功回调的block
 @failure:失败回调的block
 */
+ (void)requestWithUrl:(NSString *)url
            parameters:(NSDictionary *)parameterDic
       successResponse:(SuccessResponse)success
       failureResponse:(FailureResponse)failure;


// POST
+ (void)sendDataWithUrl:(NSString *)url
             parameters:(id)parameterDic
        successResponse:(SuccessResponse)success
                failure:(FailureResponse)failure;



// POST上传图片
+ (void)sendImagesWithUrl:(NSString *)url
               parameters:(NSDictionary *)params
               imageArray:(NSArray *)imageArray
          successResponse:(SuccessResponse)success
          failureResponse:(FailureResponse)failure;


// 原生PUT
- (void)PUTWithURLStr:(NSString *)urlStr
             fromData:(NSData *)fromData
      successResponse:(SuccessResponse)success
      failureResponse:(FailureResponse)failure;

@end

