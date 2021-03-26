//
//  OSS.m
//  xiangle
//
//  Created by wei cui on 2020/3/5.
//  Copyright © 2020 wei cui. All rights reserved.
//

#import "OSS.h"
#import <AliyunOSSiOS/AliyunOSSiOS.h>
#define OSS_STS_URL                 @"https://xiangle.cuiwei.net/user/oss/sts"
#define OSS_ENDPOINT                @"https://oss-cn-hangzhou.aliyuncs.com"
#define OSS_BUCKET                  @"cw-test"

@interface OSS ()

@property(nonatomic,strong) OSSClient * client;

@end

@implementation OSS
+(instancetype)sharedManager{
    static OSS *_sharedManager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedManager = [[OSS alloc] init];
        [_sharedManager initAliClient];
    });
    return _sharedManager;
}

-(void)initAliClient{
    // 初始化具有自动刷新的provider
    OSSAuthCredentialProvider *credentialProvider = [[OSSAuthCredentialProvider alloc] initWithAuthServerUrl:OSS_STS_URL];
    // client端的配置,如超时时间，开启dns解析等等
    OSSClientConfiguration *conf = [[OSSClientConfiguration alloc] init];

    // 网络请求遇到异常失败后的重试次数
    conf.maxRetryCount = 3;
    // 网络请求的超时时间
    conf.timeoutIntervalForRequest =30;
    // 允许资源传输的最长时间
    conf.timeoutIntervalForResource =24 * 60 * 60;
    
    _client = [[OSSClient alloc] initWithEndpoint:OSS_ENDPOINT credentialProvider:credentialProvider clientConfiguration:conf];
}
-(NSString *)uploadJokeImage:(NSString *)path data:(NSData *)data{
    OSSPutObjectRequest * put = [OSSPutObjectRequest new];
    put.bucketName = OSS_BUCKET;
    put.objectKey = path;
    put.uploadingData = data; // 直接上传NSData
//    put.uploadProgress = ^(int64_t bytesSent, int64_t totalByteSent, int64_t totalBytesExpectedToSend) {
//        NSLog(@"%lld, %lld, %lld", bytesSent, totalByteSent, totalBytesExpectedToSend);
//    };

    OSSTask * putTask = [self.client putObject:put];

    [putTask continueWithBlock:^id(OSSTask *task) {
        if (!task.error) {
            return path;
        } else {
            NSLog(@"upload object failed, error: %@" , task.error);
            return @"";
        }
        return nil;
    }];
    return path;
}
-(NSString *)uploadJokeVideo:(NSString *)path data:(NSURL *)url{
    OSSPutObjectRequest * put = [OSSPutObjectRequest new];
    put.bucketName = OSS_BUCKET;
    put.objectKey = path;
    put.uploadingFileURL = url;
    put.uploadProgress = ^(int64_t bytesSent, int64_t totalByteSent, int64_t totalBytesExpectedToSend) {
        NSLog(@"%lld, %lld, %lld", bytesSent, totalByteSent, totalBytesExpectedToSend);
    };

    OSSTask * putTask = [self.client putObject:put];

    [putTask continueWithBlock:^id(OSSTask *task) {
        if (!task.error) {
            return path;
        } else {
            NSLog(@"upload object failed, error: %@" , task.error);
            return @"";
        }
        return nil;
    }];
    return path;
}
@end
