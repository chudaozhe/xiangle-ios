//
//  NotifyModel.m
//  xiangle
//  消息通知
//
//  Created by wei cui on 2020/3/28.
//  Copyright © 2020 wei cui. All rights reserved.
//

#import "NotifyModel.h"
#import "HTTP.h"
@implementation NotifyModel
#pragma mark - 列表
-(void)gets:(NSMutableDictionary *_Nullable)params successBlock:(void(^)(id responseObject))successBlock failure:(void(^)(NSError *error))failureBlock{
    //请求地址
    NSString *URLString = [NSString stringWithFormat:@"/user/%@/notify", params[@"user_id"]];
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
@end
