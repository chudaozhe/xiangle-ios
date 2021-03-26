//
//  TokenModel.h
//  xiangle
//
//  Created by wei cui on 2020/4/13.
//  Copyright © 2020 wei cui. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface TokenModel : NSObject
-(void)createToken:(NSString *)key value:(NSMutableDictionary *)value;
-(id)getToken:(NSString *)key;
-(void)removeToken:(NSString *)key;
@end

NS_ASSUME_NONNULL_END
