//
//  FollowModel.h
//  xiangle
//
//  Created by wei cui on 2020/3/28.
//  Copyright © 2020 wei cui. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface FollowModel : NSObject

//我的粉丝列表
-(void)getFans:(NSMutableDictionary *_Nullable)params successBlock:(void(^)(id responseObject))successBlock failure:(void(^)(NSError *error))failureBlock;
//我的关注列表（用户/话题
-(void)gets:(NSMutableDictionary *_Nullable)params successBlock:(void(^)(id responseObject))successBlock failure:(void(^)(NSError *error))failureBlock;
//关注用户
-(void)run:(NSMutableDictionary *_Nullable)params method:(NSString *)method successBlock:(void(^)(id responseObject))successBlock failure:(void(^)(NSError *error))failureBlock;
//关注话题
-(void)run2:(NSMutableDictionary *_Nullable)params method:(NSString *)method successBlock:(void(^)(id responseObject))successBlock failure:(void(^)(NSError *error))failureBlock;
@end

NS_ASSUME_NONNULL_END
