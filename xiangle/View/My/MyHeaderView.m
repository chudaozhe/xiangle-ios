//
//  MyHeaderView.m
//  xiangle
//
//  Created by wei cui on 2020/4/4.
//  Copyright © 2020 wei cui. All rights reserved.
//

#import "MyHeaderView.h"
#import "LoginController.h"
#import <SDWebImage/SDWebImage.h>
#import "User.h"
#import "PersonInfoController.h"

@implementation MyHeaderView

//1重写构造方法
-(instancetype)init{
    if (self =[super init]) {
        self.backgroundColor=[UIColor orangeColor];
        
        _imageView=[[UIImageView alloc] init];
        [self addSubview:_imageView];
        
        _title=[[UIButton alloc] init];
        [self addSubview:_title];
        
        _edit=[[UIButton alloc] init];
        [self addSubview:_edit];
    }
    
    return self;
}
-(void)setField:(User *)field{
    _imageView.image=[UIImage imageNamed:@"avatar2"];
    if (field.avatar!=nil) {
        NSURL *url=[NSURL URLWithString:[NSString stringWithFormat:@"https://cw-test.oss-cn-hangzhou.aliyuncs.com/%@?x-oss-process=image/resize,w_80", field.avatar]];
        [_imageView sd_setImageWithURL:url placeholderImage:[UIImage imageNamed:@"avatar2"]];
    }
    [_title setTitle:@"登录/注册" forState:UIControlStateNormal];
    _title.titleLabel.font=[UIFont systemFontOfSize:14];
    _title.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;//左对齐
    //_title.backgroundColor=[UIColor grayColor];
    [_title addTarget:self action:@selector(doLogin) forControlEvents:UIControlEventTouchUpInside];
    //隐藏编辑按钮
    [_edit setHidden:YES];
    _title.y=50;
    if (field.nickname!=nil) {
        _title.y=30;
        [_title setTitle:field.nickname forState:UIControlStateNormal];
        [_title removeTarget:self action:@selector(doLogin) forControlEvents:UIControlEventTouchUpInside];
        //显示编辑按钮
        [_edit setHidden:NO];
    }
    //设置圆角的大小
    _title.layer.cornerRadius = 4;
    [_title setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];//默认白色
    /**编辑资料按钮*/
    [_edit setTitle:@"编辑资料" forState:UIControlStateNormal];
    _edit.titleLabel.font=[UIFont systemFontOfSize:14];
    //_edit.backgroundColor=[UIColor redColor];
    [_edit addTarget:self action:@selector(doPersonInfo) forControlEvents:UIControlEventTouchUpInside];
    //设置圆角的大小
    _edit.layer.cornerRadius = 4;
    //设置边框的粗细
    [_edit.layer setBorderWidth:1.0];
    //设置边框的颜色
    [_edit.layer setBorderColor:[UIColor whiteColor].CGColor];
}
-(void)layoutSubviews{
    [super layoutSubviews];
    _imageView.frame=CGRectMake(10, 10, 80, 80);
    _title.frame=CGRectMake(CGRectGetMaxX(_imageView.frame)+10, 30, 100, 30);//
    
    _imageView.frame = CGRectMake(10, 20, 80, 80);
    _imageView.backgroundColor = [UIColor whiteColor];
    _imageView.layer.masksToBounds = YES;
    _imageView.layer.cornerRadius = CGRectGetHeight(_imageView.bounds) / 2;
    _imageView.layer.borderWidth = 2.0f;
    _imageView.layer.borderColor = [[UIColor whiteColor] CGColor];
    
    _edit.frame=CGRectMake(CGRectGetMaxX(_imageView.frame)+10, 60, 80, 30);
}
-(void)doLogin{
    NSLog(@"..login");
    LoginController *vc=[[LoginController alloc] init];
    UITabBarController *tabBarVc= [UIApplication sharedApplication].keyWindow.rootViewController;
    UINavigationController *nav= (UINavigationController *) tabBarVc.selectedViewController;
    [nav pushViewController:vc animated:YES];
}
-(void)doPersonInfo{
    NSLog(@"doPersonInfo");
    PersonInfoController *vc=[[PersonInfoController alloc] init];
    UITabBarController *tabBarVc= [UIApplication sharedApplication].keyWindow.rootViewController;
    UINavigationController *nav= (UINavigationController *) tabBarVc.selectedViewController;
    [nav pushViewController:vc animated:YES];
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
