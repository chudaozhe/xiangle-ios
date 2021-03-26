//
//  ShieldModel.m
//  xiangle
//  拉黑
//  Created by wei cui on 2020/6/11.
//  Copyright © 2020 wei cui. All rights reserved.
//

#import "ShieldModel.h"
#import "HTTP.h"

@implementation ShieldModel
#pragma mark - 拉黑 method:POST
-(void)run:(NSMutableDictionary *_Nullable)params method:(NSString *)method successBlock:(void(^)(id responseObject))successBlock failure:(void(^)(NSError *error))failureBlock{
    //请求地址
    NSString *URLString = [NSString stringWithFormat:@"/user/%@/user/%@/shield", params[@"user_id"], params[@"to_uid"]];
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
