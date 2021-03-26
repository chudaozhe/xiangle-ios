//
//  DivisionModel.h
//  xiangle
//
//  Created by wei cui on 2020/9/27.
//  Copyright © 2020 wei cui. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface DivisionModel : NSObject
-(void)get:(NSMutableDictionary *_Nullable)params successBlock:(void(^)(id responseObject))successBlock failure:(void(^)(NSError *error))failureBlock;
@end

NS_ASSUME_NONNULL_END
