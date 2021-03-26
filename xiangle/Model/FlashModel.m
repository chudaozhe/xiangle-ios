//
//  FlashModel.m
//  xiangle
//
//  Created by wei cui on 2020/3/31.
//  Copyright © 2020 wei cui. All rights reserved.
//

#import "FlashModel.h"
#import "HTTP.h"

@implementation FlashModel
#pragma mark - 列表
-(void)gets:(NSMutableDictionary *_Nullable)params successBlock:(void(^)(id responseObject))successBlock failure:(void(^)(NSError *error))failureBlock{
    //请求地址
    NSString *URLString = @"/user/flash";
    NSLog(@"uri:%@", URLString);
    NSLog(@"params:%@", params);
    [[HTTP sharedManager] request:URLString parameters:params success:^(id responseObject) {
        NSDictionary *dictArr = responseObject[@"data"][@"data"];
        if (successBlock != nil) {
            successBlock(dictArr);
        }
    } failure:^(NSError *error) {
        //错误回调
        NSLog(@"%@",error);
    } method:nil];
}
@end
