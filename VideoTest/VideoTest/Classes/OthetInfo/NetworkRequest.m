//
//  NetworkRequest.m
//  LessonDouBan
//
//  Created by qcx on 16/6/27.
//  Copyright © 2016年 yu. All rights reserved.
//

#import "NetworkRequest.h"
#import "AFNetworking.h"

@interface NetworkRequest ()<NSURLSessionDelegate>

@property (nonatomic, strong) NSURLSession *session;
@end

@implementation NetworkRequest

// 创建静态对象 防止外部访问
static NetworkRequest *_instance;
+(instancetype)allocWithZone:(struct _NSZone *)zone
{
    // 也可以使用一次性代码
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        if (_instance == nil) {
            _instance = [super allocWithZone:zone];
        }
    });
    return _instance;
}
// 为了使实例易于外界访问 我们一般提供一个类方法
// 类方法命名规范 share类名|default类名|类名
+ (instancetype)shareNetworkRequest
{
    //return _instance;
    // 最好用self 用Tools他的子类调用时会出现错误
    return [[self alloc]init];
}
// 为了严谨，也要重写copyWithZone 和 mutableCopyWithZone
-(id)copyWithZone:(NSZone *)zone
{
    return _instance;
}
-(id)mutableCopyWithZone:(NSZone *)zone
{
    return _instance;
}

+ (void)requestWithUrl:(NSString *)url parameters:(NSDictionary *)parameterDic successResponse:(SuccessResponse)success failureResponse:(FailureResponse)failure {
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    manager.requestSerializer = [AFHTTPRequestSerializer serializer];
    // AFNetworking框架不支持解析text/html这种格式.首先我们需要明白: AFNetworking为什么能够解析服务器返回的东西呢?因为manager有一个responseSerializer属性.它只设置了一些固定的解析格式.其中不包含text/html这种数据的格式.因为解析报错了.
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript", @"text/html", @"text/plain", nil];
    [manager GET:url parameters:parameterDic success:^(NSURLSessionDataTask * _Nonnull task, id  _Nonnull responseObject) {
        NSLog(@"URL = %@",url);
        NSLog(@"成功：%@",responseObject);
        success(responseObject);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"失败：%@",error);
        NSLog(@"URL = %@",url);
        failure(error);
    }];
}

+ (void)sendDataWithUrl:(NSString *)url
             parameters:(id)parameterDic
        successResponse:(SuccessResponse)success
                failure:(FailureResponse)failure{
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    manager.requestSerializer = [AFHTTPRequestSerializer serializer];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json",@"text/json",@"text/javascript",@"text/html",@"text/plain",nil];//前3个AF默认的，后面2个自加的
    
    [manager POST:url parameters:parameterDic success:^(NSURLSessionDataTask * _Nonnull task, id  _Nonnull responseObject) {
        NSLog(@"成功：%@",responseObject);
        success(responseObject);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"失败：%@",error);
        failure(error);
    }];
}

// 上传图片
+ (void)sendImagesWithUrl:(NSString *)url
               parameters:(NSDictionary *)params
               imageArray:(NSArray *)imageArray
          successResponse:(SuccessResponse)success
          failureResponse:(FailureResponse)failure{
    
    //检查地址中是否有中文
    NSString *urlStr=[NSURL URLWithString:url]?url:[self strUTF8Encoding:url];
    //1.创建管理者对象
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
//    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    manager.requestSerializer = [AFHTTPRequestSerializer serializer];
//    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json",@"text/json",@"text/javascript",@"text/html",@"text/plain",@"video/cc",nil];
    [manager POST:urlStr parameters:params constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        for (int i = 0; i < imageArray.count; i++) {
            //压缩图片
            NSData *imageData = UIImageJPEGRepresentation(imageArray[i], 1.0);
            NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
            formatter.dateFormat = @"yyyyMMddHHmmss";
            NSString *str = [formatter stringFromDate:[NSDate date]];
            NSString *imageFileName = [NSString stringWithFormat:@"%@.jpg", str];
            // 上传图片，以文件流的格式
            [formData appendPartWithFileData:imageData name:@"file" fileName:imageFileName mimeType:@"image/jpeg"];
        }
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nonnull responseObject) {
        //请求成功
        success(responseObject);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        //请求失败
        failure(error);
    }];
}

- (void)PUTWithURLStr:(NSString *)urlStr
             fromData:(NSData *)fromData
      successResponse:(SuccessResponse)success
      failureResponse:(FailureResponse)failure{
    
    // 1. url 最后一个是要上传的文件名
    NSURL *url = [NSURL URLWithString:urlStr];
    
    // 2. request
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    request.HTTPMethod = @"PUT";
    
    // 4. 由session发起任务
    //    NSURL *localURL = [NSURL URLWithString:filePath];
    
    NSURLSessionUploadTask * uploadtask = [self.session uploadTaskWithRequest:request fromData:fromData completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        
        NSString *result = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
        
        NSLog(@"sesult---> %@ %@", result, [NSThread currentThread]);
        
        if (!error) {
            success(result);
        }else{
            failure(error);
        }
    }];
    
    [uploadtask resume];
    
}

+ (NSString *)base64Encode:(NSString *)str
{
    // 1. 将字符串转换成二进制数据
    NSData *data = [str dataUsingEncoding:NSUTF8StringEncoding];
    
    // 2. 对二进制数据进行base64编码
    NSString *result = [data base64EncodedStringWithOptions:0];
    
    NSLog(@"base464--> %@", result);
    
    return result;
}

+(NSString *)strUTF8Encoding:(NSString *)str{
    //return [str stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLPathAllowedCharacterSet]];
    return [str stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
}


- (void)URLSession:(NSURLSession *)session
              task:(NSURLSessionTask *)task
   didSendBodyData:(int64_t)bytesSent
    totalBytesSent:(int64_t)totalBytesSent
totalBytesExpectedToSend:(int64_t)totalBytesExpectedToSend{
    if (_delegate && [_delegate respondsToSelector:@selector(setUpdateProgressWithTotalBytesSent:totalBytesExpectedToSend:)]) {
        //        NSLog(@"bytesSent = %lld,totalBytesSent = %lld,totalBytesExpectedToSend = %lld",bytesSent,totalBytesSent,totalBytesExpectedToSend);
        [_delegate setUpdateProgressWithTotalBytesSent:totalBytesSent totalBytesExpectedToSend:totalBytesExpectedToSend];
    }
    
}


- (NSURLSession *)session{
    if (!_session) {
        NSURLSessionConfiguration * configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
        _session = [NSURLSession sessionWithConfiguration:configuration delegate:self delegateQueue:[NSOperationQueue mainQueue]];
    }
    return _session;
}

@end

