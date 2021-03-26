//
//  ContentFooterView.m
//  xiangle
//
//  Created by wei cui on 2020/4/12.
//  Copyright © 2020 wei cui. All rights reserved.
//

#import "ContentFooterView.h"
#import "Joke.h"
#import "LikeModel.h"
#import "FavoriteModel.h"
#import "UIColor+Hex.h"
#import "CommentModel.h"
#import <SVProgressHUD/SVProgressHUD.h>
#import "TokenModel.h"

@implementation ContentFooterView
-(instancetype)init{
    if (self =[super init]) {
        //评论框
//        _comment=[[UITextField alloc] init];
//        _comment.backgroundColor=[UIColor colorWithHexString:@"cccccc"];
//        _comment.placeholder = @"发表下你的看法";
//        _comment.layer.cornerRadius = 5;
//        _comment.borderStyle = UITextBorderStyleRoundedRect;
//
//        _comment.delegate=self;
//        [self addSubview:_comment];
        
        //点赞按钮
        _like=[[UIButton alloc] init];
        [_like setImage:[UIImage imageNamed:@"zan"] forState:UIControlStateNormal];
        _like.tag=0;
        [_like addTarget:self action:@selector(doLike:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:_like];
        
        //收藏按钮
        _favorite=[[UIButton alloc] init];
        [_favorite setImage:[UIImage imageNamed:@"shoucang"] forState:UIControlStateNormal];
        _favorite.tag=0;
        [_favorite addTarget:self action:@selector(doFavorite:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:_favorite];
    }
    
    return self;
}
-(void)setField:(Joke *)field{
    _field=field;

    [_like setImage:[UIImage imageNamed:@"zan"] forState:UIControlStateNormal];
    if (field.is_like) {
        [_like setImage:[UIImage imageNamed:@"zan2"] forState:UIControlStateNormal];
    }
    
    [_favorite setImage:[UIImage imageNamed:@"shoucang"] forState:UIControlStateNormal];
    if (field.is_favorite) {
        [_favorite setImage:[UIImage imageNamed:@"shoucang2"] forState:UIControlStateNormal];
    }
}
-(void)layoutSubviews{
    [super layoutSubviews];
    //_comment.frame=CGRectMake(20, 10, CWScreenW-120, 40);
    
    _like.frame=CGRectMake(CWScreenW-70, 12, 24, 24);
    _favorite.frame=CGRectMake(CWScreenW-40, 12, 24, 24);
}
-(void)doLike:(UIButton *)btn{
    //验证是否登录
    TokenModel *userDefaults = [[TokenModel alloc] init];
    NSMutableDictionary *data=[userDefaults getToken:@"user_cookie"];
    NSLog(@"见证奇迹getuserDefaults:%@", data);
    if (nil!=data) {
        NSString *method=@"PUT";
        if (_field.is_like==1) method=@"DELETE";
        LikeModel *obj=[[LikeModel alloc] init];
        NSMutableDictionary *params = [NSMutableDictionary dictionary];
        params[@"user_id"] = data[@"user_id"];//当前登录用户的user_id
        params[@"joke_id"] = [NSString stringWithFormat:@"%zd", _field.id];
        [obj run:params method:method successBlock:^(id  _Nonnull responseObject) {
            //NSLog(@"result: %@", responseObject);
            NSDictionary *field=responseObject;
            NSLog(@"field:%@", field);
            
            //切换按钮状态
            if (self.field.is_like) {//取反
                [self.like setImage:[UIImage imageNamed:@"zan"] forState:UIControlStateNormal];
            }else{
                [self.like setImage:[UIImage imageNamed:@"zan2"] forState:UIControlStateNormal];
            }
            self.like.enabled=NO;
        } failure:^(NSError * _Nonnull error) {
            NSLog(@"error:%@", error);
        }];
    }else{
        //提示先登录
        [SVProgressHUD showErrorWithStatus:@"请先登录"];
        [SVProgressHUD dismissWithDelay:1.0f];
    }

}
-(void)doFavorite:(UIButton *)btn{
    //验证是否登录
    TokenModel *userDefaults = [[TokenModel alloc] init];
    NSMutableDictionary *data=[userDefaults getToken:@"user_cookie"];
    NSLog(@"见证奇迹getuserDefaults:%@", data);
    if (nil!=data) {
        NSString *method=@"PUT";
        if (_field.is_favorite==1) method=@"DELETE";
        FavoriteModel *obj=[[FavoriteModel alloc] init];
        NSMutableDictionary *params = [NSMutableDictionary dictionary];
        params[@"user_id"] = data[@"user_id"];//当前登录用户的user_id
        params[@"joke_id"] = [NSString stringWithFormat:@"%zd", _field.id];
        [obj run:params method:method successBlock:^(id  _Nonnull responseObject) {
            //NSLog(@"result: %@", responseObject);
            NSDictionary *field=responseObject;
            NSLog(@"field:%@", field);
            
            //切换按钮状态
            if (self.field.is_favorite) {//取反
                [self.favorite setImage:[UIImage imageNamed:@"shoucang"] forState:UIControlStateNormal];
            }else{
                [self.favorite setImage:[UIImage imageNamed:@"shoucang2"] forState:UIControlStateNormal];
            }
            self.favorite.enabled=NO;
        } failure:^(NSError * _Nonnull error) {
            NSLog(@"error:%@", error);
        }];
    }else{
        //提示先登录
        [SVProgressHUD showErrorWithStatus:@"请先登录"];
        [SVProgressHUD dismissWithDelay:1.0f];
    }
}

@end
