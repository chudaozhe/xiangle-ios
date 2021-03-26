//
//  TopicCell.m
//  xiangle
//
//  Created by wei cui on 2020/9/22.
//  Copyright © 2020 wei cui. All rights reserved.
//

#import "TopicCell.h"
#import <SDWebImage/SDWebImage.h>
#import "TokenModel.h"
#import "FollowModel.h"
#import <SVProgressHUD/SVProgressHUD.h>

@implementation TopicCell
+ (instancetype)cellWithTableView:(UITableView *)tableView{
    static NSString *identifier = @"topicCell";
    // 1.缓存中取
    TopicCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
//    TopicCell *cell = nil;
    // 2.创建
    if (cell == nil) {
        cell = [[TopicCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    return cell;
}
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        //灰色的线,本来这块是没用的，但去掉后，关注按钮的点击事件就不触发了，故把_line的高度设为0
        _line=[[UIView alloc] init];
        _line.backgroundColor=CWGlobalBgColor;
        [self.contentView addSubview:_line];
        
        _desc=[[UILabel alloc] init];
        [self addSubview:_desc];
        
        _follow=[[UIButton alloc] init];
        //关注按钮
        //[_follow setBackgroundColor:[UIColor orangeColor]];
        _follow.titleLabel.font=[UIFont systemFontOfSize:12];
        //[_follow setTitleColor:[UIColor orangeColor] forState:UIControlStateNormal];
        [_follow addTarget:self action:@selector(doFollow:) forControlEvents:UIControlEventTouchUpInside];
        //设置圆角的大小
        _follow.layer.cornerRadius = 4;
        
        //设置边框的颜色
        //[_follow.layer setBorderColor:[UIColor orangeColor].CGColor];
        //设置边框的粗细
        [_follow.layer setBorderWidth:1.0];
        [self addSubview:_follow];
    }
    return self;
}
-(void)setField:(Topic *)field{
    _field=field;
    if (![field.name isEqualToString:@""]) {
        self.textLabel.text=field.name;
    }
    
    if (![field.image isEqualToString:@""]) {
        NSURL *url=[NSURL URLWithString:[NSString stringWithFormat:@"https://cw-test.oss-cn-hangzhou.aliyuncs.com/%@?x-oss-process=image/resize,w_80", field.image]];
        [self.imageView sd_setImageWithURL:url placeholderImage:[UIImage imageNamed:@"picture2"]];
    }
    _desc.text=[NSString stringWithFormat:@"%zd个内容", field.sum];
    [_follow setTitle:@"关注" forState:UIControlStateNormal];
    [_follow setTitleColor:[UIColor orangeColor] forState:UIControlStateNormal];
    [_follow.layer setBorderColor:[UIColor orangeColor].CGColor];
    if (field.is_follow) {
        [_follow setTitle:@"已关注" forState:UIControlStateNormal];
        [_follow setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
        [_follow.layer setBorderColor:[UIColor lightGrayColor].CGColor];
    }
    //[self layoutIfNeeded];
    //field.cellHeight=100;//计算cell的高度
}
/**
 重新布局子view
 */
- (void)layoutSubviews{
    [super layoutSubviews];//继承父类
    self.imageView.frame=CGRectMake(10, 6, 40, 40);
    
    self.textLabel.font=[UIFont systemFontOfSize:14];
    self.textLabel.frame=CGRectMake(60, 10, 100, 20);
    _desc.frame=CGRectMake(60, 30, 100, 20);
    _desc.font=[UIFont systemFontOfSize:12];
    
    _follow.frame=CGRectMake(self.width-70, (self.height-30)/2, 60, 30);
    _line.frame=CGRectMake(0, 0, CWScreenW, 0);
    
    //[self layoutIfNeeded];
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
        params[@"topic_id"] = [NSString stringWithFormat:@"%zd", _field.id];
        [obj run2:params method:method successBlock:^(id  _Nonnull responseObject) {
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
- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
@end
