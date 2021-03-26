//
//  UserModel.h
//  xiangle
//
//  Created by wei cui on 2020/4/4.
//  Copyright © 2020 wei cui. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface UserModel : NSObject
//用户详情
-(void)get:(NSMutableDictionary *_Nullable)params successBlock:(void(^)(id responseObject))successBlock failure:(void(^)(NSError *error))failureBlock;
//更新用户信息
-(void)put:(NSMutableDictionary *_Nullable)params successBlock:(void(^)(id responseObject))successBlock failure:(void(^)(NSError *error))failureBlock;
//手机号登录
-(void)mobileLogin:(NSMutableDictionary *_Nullable)params successBlock:(void(^)(id responseObject))successBlock failure:(void(^)(NSError *error))failureBlock;
//发送验证码
-(void)sendCaptcha:(NSMutableDictionary *_Nullable)params successBlock:(void(^)(id responseObject))successBlock failure:(void(^)(NSError *error))failureBlock;
//登录
-(void)login:(NSMutableDictionary *_Nullable)params successBlock:(void(^)(id responseObject))successBlock failure:(void(^)(NSError *error))failureBlock DEPRECATED_MSG_ATTRIBUTE("use mobileLogin: instead");
//注册
-(void)reg:(NSMutableDictionary *_Nullable)params successBlock:(void(^)(id responseObject))successBlock failure:(void(^)(NSError *error))failureBlock DEPRECATED_MSG_ATTRIBUTE("use mobileLogin: instead");
@end

NS_ASSUME_NONNULL_END
