//
//  ShieldModel.h
//  xiangle
//
//  Created by wei cui on 2020/6/11.
//  Copyright © 2020 wei cui. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface ShieldModel : NSObject
-(void)run:(NSMutableDictionary *_Nullable)params method:(NSString *)method successBlock:(void(^)(id responseObject))successBlock failure:(void(^)(NSError *error))failureBlock;
@end

NS_ASSUME_NONNULL_END
