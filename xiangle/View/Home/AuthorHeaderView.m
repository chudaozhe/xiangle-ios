//
//  AuthorHeaderView.m
//  xiangle
//
//  Created by wei cui on 2020/6/10.
//  Copyright © 2020 wei cui. All rights reserved.
//

#import "AuthorHeaderView.h"
#import <SDWebImage/SDWebImage.h>
#import "Author.h"
#import "FollowModel.h"
#import <SVProgressHUD/SVProgressHUD.h>
#import "TokenModel.h"

@implementation AuthorHeaderView

-(void)setup{
    _avatar=[[UIImageView alloc] init];
    _avatar.userInteractionEnabled=YES;
    UITapGestureRecognizer * ges = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(btnClick:)];
    [_avatar addGestureRecognizer:ges];
    [self addSubview:_avatar];
    
    _nickname=[[UILabel alloc] init];
    _nickname.font=[UIFont systemFontOfSize:16];
    [self addSubview:_nickname];
    
    //简介
    _quotes=[[UILabel alloc] init];
    _quotes.font=[UIFont systemFontOfSize:12];
    [self addSubview:_quotes];
    //粉丝数
    _followers=[[UILabel alloc] init];
    _followers.font=[UIFont systemFontOfSize:12];
    [self addSubview:_followers];
    //关注数
    _following=[[UILabel alloc] init];
    _following.font=[UIFont systemFontOfSize:12];
    [self addSubview:_following];
    
    _follow=[[UIButton alloc] init];
    //关注按钮
    //[_follow setBackgroundColor:[UIColor greenColor]];
    _follow.titleLabel.font=[UIFont systemFontOfSize:12];
    [_follow addTarget:self action:@selector(doFollow:) forControlEvents:UIControlEventTouchUpInside];
    //设置圆角的大小
    _follow.layer.cornerRadius = 2;
    //设置边框的粗细
    [_follow.layer setBorderWidth:1.0];
    [self addSubview:_follow];

}
- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        [self setup];
    }
    return self;
}
-(void)btnClick:(UITapGestureRecognizer *)tap{
    UIImageView *sv=(UIImageView *)[tap view];
    NSLog(@"click:%zd", sv.tag);
    //放大头像
}

-(void)setField:(Author *)field{
    _field=field;
    _avatar.image=[UIImage imageNamed:@"user"];
    if(field.avatar!=nil){
        NSURL *url=[NSURL URLWithString:[NSString stringWithFormat:@"https://cw-test.oss-cn-hangzhou.aliyuncs.com/%@?x-oss-process=image/resize,w_80", field.avatar]];
        [_avatar sd_setImageWithURL:url placeholderImage:[UIImage imageNamed:@"user"]];
        //_avatar.tag=field.user_id;
    }
    _nickname.text=@"...";
    if (field.nickname!=nil) {
        _nickname.text=field.nickname;
    }
    _quotes.text=@"";
    if (![field.quotes isEqual:@""]) {
        _quotes.text=[NSString stringWithFormat:@"简介：%@", field.quotes];
    }
    _followers.text=[NSString stringWithFormat:@"粉丝：%zd", field.followers];
    _following.text=[NSString stringWithFormat:@"关注：%zd", field.following];
    
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
    _avatar.frame=CGRectMake(10, 10, 80, 80);
    _avatar.backgroundColor = [UIColor whiteColor];
    _avatar.layer.masksToBounds = YES;
    _avatar.layer.cornerRadius = CGRectGetHeight(_avatar.bounds) / 2;
    _avatar.layer.borderWidth = 2.0f;
    _avatar.layer.borderColor = [[UIColor whiteColor] CGColor];
    
    
    //粉丝数
    _followers.frame=CGRectMake(100, 20, 100, 30);
    //关注数
    _following.frame=CGRectMake(160, 20, 100, 30);
    
    //关注按钮
    _follow.frame=CGRectMake(100, 50, 110, 30);
    
    //昵称
    _nickname.frame=CGRectMake(20, 90, 100, 30);
    //简介
    _quotes.frame=CGRectMake(20, 110, CWScreenW-100, 30);
    
}
-(void)doFollow:(UIButton *)btn{
    //NSLog(@"doFollow--: _field:%@", _field);
    //验证是否登录
    TokenModel *userDefaults = [[TokenModel alloc] init];
    NSMutableDictionary *data=[userDefaults getToken:@"user_cookie"];
    NSLog(@"见证奇迹2 getuserDefaults:%@", data);
    if (nil!=data) {
        NSString *method=@"PUT";
        if (_field.is_follow==1) method=@"DELETE";
        FollowModel *obj=[[FollowModel alloc] init];
        NSMutableDictionary *params = [NSMutableDictionary dictionary];
        params[@"user_id"] = nil!=data?data[@"user_id"]:@0;//当前登录用户的user_id
        params[@"to_uid"] = [NSString stringWithFormat:@"%zd", _field.id];
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
