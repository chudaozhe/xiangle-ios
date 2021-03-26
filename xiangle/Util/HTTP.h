//
//  HTTP.h
//  xiangle
//
//  Created by wei cui on 2020/3/13.
//  Copyright © 2020 wei cui. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AFNetworking/AFNetworking.h>

NS_ASSUME_NONNULL_BEGIN

@interface HTTP : AFHTTPSessionManager
+(instancetype)sharedManager;
/**
 *  发送GET请求,获取JSON数据
 *
 *  @param URLString JSON数据地址
 *  @param success   成功的回调,回调AFN反序列之后结果
 *  @param failed    失败的回调,回调AFN获取的错误信息
 */
- (void)request:(NSString *)URLString parameters:(id _Nullable)parameters success:(void(^)(id responseObject))successBlock failure:(void(^)(NSError *error))failureBlock method:(NSString *_Nullable)method;
@end

NS_ASSUME_NONNULL_END
