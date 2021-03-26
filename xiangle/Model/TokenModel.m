//
//  TokenModel.m
//  xiangle
//
//  Created by wei cui on 2020/4/13.
//  Copyright © 2020 wei cui. All rights reserved.
//

#import "TokenModel.h"
@interface TokenModel ()
/** 备注 */
@property (strong, nonatomic) NSUserDefaults *userDefaults;
@end
@implementation TokenModel
- (instancetype)init
{
    self = [super init];
    if (self) {
        self.userDefaults = [NSUserDefaults standardUserDefaults];
    }
    return self;
}
-(void)createToken:(NSString *)key value:(NSMutableDictionary *)value{
    [self.userDefaults setObject:value forKey:key];

    [self.userDefaults synchronize];
}
-(id)getToken:(NSString *)key{
    return [self.userDefaults objectForKey:key];
}
-(void)removeToken:(NSString *)key{
    [self.userDefaults removeObjectForKey:key];
}
@end
