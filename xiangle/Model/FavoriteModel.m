//
//  FavoriteModel.m
//  xiangle
//  我的收藏
//
//  Created by wei cui on 2020/3/28.
//  Copyright © 2020 wei cui. All rights reserved.
//

#import "FavoriteModel.h"
#import "HTTP.h"
@implementation FavoriteModel
#pragma mark - 列表
-(void)gets:(NSMutableDictionary *_Nullable)params successBlock:(void(^)(id responseObject))successBlock failure:(void(^)(NSError *error))failureBlock{
    //请求地址
    NSString *URLString = [NSString stringWithFormat:@"/user/%@/favorite", params[@"user_id"]];
    NSLog(@"uri:%@", URLString);
    NSLog(@"params:%@", params);
    [[HTTP sharedManager] request:URLString parameters:params success:^(id responseObject) {
        NSDictionary *dictArr = responseObject[@"data"];
        if (successBlock != nil) {
            successBlock(dictArr);
        }
    } failure:^(NSError *error) {
        //错误回调
        NSLog(@"%@",error);
    } method:nil];
}
#pragma mark - 收藏/取消 method:PUT/DELETE
-(void)run:(NSMutableDictionary *_Nullable)params method:(NSString *)method successBlock:(void(^)(id responseObject))successBlock failure:(void(^)(NSError *error))failureBlock{
    //请求地址
    NSString *URLString = [NSString stringWithFormat:@"/user/%@/joke/%@/favorite", params[@"user_id"], params[@"joke_id"]];
    NSLog(@"uri:%@", URLString);
    NSLog(@"params:%@", params);
    [[HTTP sharedManager] request:URLString parameters:params success:^(id responseObject) {
        NSDictionary *dictArr = responseObject[@"data"];
        if (successBlock != nil) {
            successBlock(dictArr);
        }
    } failure:^(NSError *error) {
        //错误回调
        NSLog(@"%@",error);
    } method:method];
}
@end
