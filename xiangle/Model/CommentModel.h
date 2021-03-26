//
//  CommentModel.h
//  xiangle
//
//  Created by wei cui on 2020/3/21.
//  Copyright © 2020 wei cui. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface CommentModel : NSObject

-(void)gets:(NSMutableDictionary *_Nullable)params successBlock:(void(^)(id responseObject))successBlock failure:(void(^)(NSError *error))failureBlock;
-(void)create:(NSMutableDictionary *_Nullable)params successBlock:(void(^)(id responseObject))successBlock failure:(void(^)(NSError *error))failureBlock;
#pragma mark - 我的评论列表
-(void)getListByUserId:(NSMutableDictionary *_Nullable)params successBlock:(void(^)(id responseObject))successBlock failure:(void(^)(NSError *error))failureBlock;
@end

NS_ASSUME_NONNULL_END
