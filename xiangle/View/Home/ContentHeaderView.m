//
//  ContentHeaderView.m
//  xiangle
//
//  Created by wei cui on 2020/4/1.
//  Copyright © 2020 wei cui. All rights reserved.
//

#import "ContentHeaderView.h"
#import <SDWebImage/SDWebImage.h>
#import "Joke.h"
#import "FollowModel.h"
#import <SVProgressHUD/SVProgressHUD.h>
#import "TokenModel.h"
#import "AuthorController.h"

@implementation ContentHeaderView
//1重写构造方法
-(instancetype)init{
    if (self =[super init]) {
        _avatar=[[UIImageView alloc] init];
        _avatar.userInteractionEnabled=YES;
        UITapGestureRecognizer *ges = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(btnClick:)];
        [_avatar addGestureRecognizer:ges];
        [self addSubview:_avatar];
        
        _nickname=[[UILabel alloc] init];
        _nickname.font=[UIFont systemFontOfSize:14];
        _nickname.userInteractionEnabled=YES;
        UITapGestureRecognizer *ges2 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(btnClick:)];
        [_nickname addGestureRecognizer:ges2];
        [self addSubview:_nickname];
        
        _follow=[[UIButton alloc] init];
        //关注按钮
        //[_follow setBackgroundColor:[UIColor orangeColor]];
        _follow.titleLabel.font=[UIFont systemFontOfSize:12];
        [_follow addTarget:self action:@selector(doFollow:) forControlEvents:UIControlEventTouchUpInside];
        //设置圆角的大小
        _follow.layer.cornerRadius = 2;
        //设置边框的粗细
        [_follow.layer setBorderWidth:1.0];
        [self addSubview:_follow];
    }
    
    return self;
}
-(void)btnClick:(UITapGestureRecognizer *)tap{
    UIImageView *sv=(UIImageView *)[tap view];
    NSLog(@"click:%zd", sv.tag);
    AuthorController *vc=[[AuthorController alloc] init];
    vc.id=sv.tag;
    UITabBarController *tabBarVc= [UIApplication sharedApplication].keyWindow.rootViewController;
    UINavigationController *nav= (UINavigationController *) tabBarVc.selectedViewController;
    [nav pushViewController:vc animated:YES];
}

-(void)setField:(Joke *)field{
    _field=field;
    _avatar.image=[UIImage imageNamed:@"user"];
    if(field.avatar!=nil){
        NSURL *url=[NSURL URLWithString:[NSString stringWithFormat:@"https://cw-test.oss-cn-hangzhou.aliyuncs.com/%@?x-oss-process=image/resize,w_80", field.avatar]];
        [_avatar sd_setImageWithURL:url placeholderImage:[UIImage imageNamed:@"user"]];
        _avatar.tag=field.user_id;
    }
    _nickname.text=@"...";
    if (field.nickname!=nil) {
        _nickname.text=field.nickname;
        _nickname.tag=field.user_id;
    }
    
    [_follow setTitle:@"关注" forState:UIControlStateNormal];
    [_follow setTitleColor:[UIColor orangeColor] forState:UIControlStateNormal];
    [_follow.layer setBorderColor:[UIColor orangeColor].CGColor];
    if (field.is_follow) {
        [_follow setTitle:@"已关注" forState:UIControlStateNormal];
        [_follow setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
        [_follow.layer setBorderColor:[UIColor lightGrayColor].CGColor];
    }
}
-(void)layoutSubviews{
    [super layoutSubviews];
    _avatar.frame=CGRectMake(0, 0, 60, 60);
    _avatar.backgroundColor = [UIColor whiteColor];
    _avatar.layer.masksToBounds = YES;
    _avatar.layer.cornerRadius = CGRectGetHeight(_avatar.bounds) / 2;
    _avatar.layer.borderWidth = 2.0f;
    _avatar.layer.borderColor = [[UIColor whiteColor] CGColor];
    
    _nickname.frame=CGRectMake(70, 14, 100, 30);
    _follow.frame=CGRectMake(CWScreenW-80, 14, 60, 30);
}
-(void)doFollow:(UIButton *)btn{
    NSLog(@"_field:%@", _field);
    //验证是否登录
    TokenModel *userDefaults = [[TokenModel alloc] init];
    NSMutableDictionary *data=[userDefaults getToken:@"user_cookie"];
    NSLog(@"见证奇迹getuserDefaults:%@", data);
    if (nil!=data) {
        NSString *method=@"PUT";
        if (_field.is_follow==1) method=@"DELETE";
        FollowModel *obj=[[FollowModel alloc] init];
        NSMutableDictionary *params = [NSMutableDictionary dictionary];
        params[@"user_id"] = data[@"user_id"];//当前登录用户的user_id
        params[@"to_uid"] = [NSString stringWithFormat:@"%zd", _field.user_id];
        [obj run:params method:method successBlock:^(id  _Nonnull responseObject) {
            //NSLog(@"result: %@", responseObject);
            NSDictionary *field=responseObject;
            NSLog(@"field:%@", field);//[un_follow:1]
            //切换按钮状态
            if (self.field.is_follow) {//取反
                [self.follow setTitle:@"关注" forState:UIControlStateNormal];
                [self.follow setTitleColor:[UIColor orangeColor] forState:UIControlStateNormal];
                [self.follow.layer setBorderColor:[UIColor orangeColor].CGColor];
            }else{
                [self.follow setTitle:@"已关注" forState:UIControlStateNormal];
                [self.follow setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
                [self.follow.layer setBorderColor:[UIColor lightGrayColor].CGColor];
            }
            self.follow.enabled=NO;
            //self.follow.backgroundColor = [[UIColor orangeColor] colorWithAlphaComponent:0.4];
        } failure:^(NSError * _Nonnull error) {
            NSLog(@"error:%@", error);
        }];
    }else{
        //提示先登录
        [SVProgressHUD showErrorWithStatus:@"请先登录"];
        [SVProgressHUD dismissWithDelay:1.0f];
    }
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
