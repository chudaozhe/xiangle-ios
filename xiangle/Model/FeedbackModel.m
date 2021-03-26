//
//  FeedbackModel.m
//  xiangle
//  我的点赞
//
//  Created by wei cui on 2020/3/28.
//  Copyright © 2020 wei cui. All rights reserved.
//

#import "FeedbackModel.h"
#import "HTTP.h"
@implementation FeedbackModel
#pragma mark - 添加
-(void)create:(NSMutableDictionary *_Nullable)params successBlock:(void(^)(id responseObject))successBlock failure:(void(^)(NSError *error))failureBlock{
    //请求地址
    NSString *URLString = [NSString stringWithFormat:@"/user/%@/feedback", params[@"user_id"]];
    NSLog(@"uri:%@", URLString);
    NSLog(@"params:%@", params);
    [[HTTP sharedManager] request:URLString parameters:params success:^(id responseObject) {
        NSDictionary *dictArr = responseObject;
        if (successBlock != nil) {
            successBlock(dictArr);
        }
    } failure:^(NSError *error) {
        //错误回调
        NSLog(@"%@",error);
    } method:@"POST"];
}
@end
