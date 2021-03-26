//
//  DivisionModel.m
//  xiangle
//
//  Created by wei cui on 2020/9/27.
//  Copyright © 2020 wei cui. All rights reserved.
//

#import "DivisionModel.h"
#import "HTTP.h"

@implementation DivisionModel
#pragma mark - 列表
-(void)get:(NSMutableDictionary *_Nullable)params successBlock:(void(^)(id responseObject))successBlock failure:(void(^)(NSError *error))failureBlock{
    //请求地址
    NSString *URLString = [NSString stringWithFormat:@"/user/division"];
    NSLog(@"uri:%@", URLString);
    NSLog(@"params:%@", params);
    [[HTTP sharedManager] request:URLString parameters:params success:^(id responseObject) {
        NSArray *dictArr = responseObject;
        if (successBlock != nil) {
            successBlock(dictArr);
        }
    } failure:^(NSError *error) {
        //错误回调
        NSLog(@"%@",error);
    } method:nil];
}
@end
