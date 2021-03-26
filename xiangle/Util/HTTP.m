//
//  HTTP.m
//  xiangle
//
//  Created by wei cui on 2020/3/13.
//  Copyright © 2020 wei cui. All rights reserved.
//

#import "HTTP.h"
@implementation HTTP
+(instancetype)sharedManager{
    static HTTP *instance;
    static dispatch_once_t onceToken;//用来检测是否只被执行一次
    dispatch_once(&onceToken, ^{
        //实例化的同时,设置相对路径
        NSURL *baseURL = [NSURL URLWithString:@"https://xiangle.cuiwei.net/"];
        //使用父类的初始化方法instance = [self manager];
        instance = [[self alloc] initWithBaseURL:baseURL];
        //解决AFN反序列化时的问题
        instance.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript", @"text/html", nil];
    });
    return instance;
}
-(void)request:(NSString *)URLString parameters:(id _Nullable)parameters success:(void (^)(id))successBlock failure:(void (^)(NSError *))failureBlock method:(NSString *_Nullable)method{
    if(method==nil) method=@"GET";
    if ([method isEqualToString:@"GET"]) {
        [self GET:URLString parameters:parameters headers:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            if (successBlock != nil) {
                successBlock(responseObject);
            }
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            if (failureBlock != nil) {
                failureBlock(error);
            }
        }];
    }else if([method isEqualToString:@"POST"]){
        [self POST:URLString parameters:parameters headers:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            if (successBlock != nil) {
                successBlock(responseObject);
            }
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            if (failureBlock != nil) {
                failureBlock(error);
            }
        }];
    }else if([method isEqualToString:@"PUT"]){
        [self PUT:URLString parameters:parameters headers:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            if (successBlock != nil) {
                successBlock(responseObject);
            }
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            if (failureBlock != nil) {
                failureBlock(error);
            }
        }];
    }else if([method isEqualToString:@"DELETE"]){
        [self DELETE:URLString parameters:parameters headers:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            if (successBlock != nil) {
                successBlock(responseObject);
            }
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            if (failureBlock != nil) {
                failureBlock(error);
            }
        }];
    }
    
}
@end
