//
//  FavoriteModel.h
//  xiangle
//
//  Created by wei cui on 2020/3/28.
//  Copyright © 2020 wei cui. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface FavoriteModel : NSObject

-(void)gets:(NSMutableDictionary *_Nullable)params successBlock:(void(^)(id responseObject))successBlock failure:(void(^)(NSError *error))failureBlock;
-(void)run:(NSMutableDictionary *_Nullable)params method:(NSString *)method successBlock:(void(^)(id responseObject))successBlock failure:(void(^)(NSError *error))failureBlock;
@end

NS_ASSUME_NONNULL_END
