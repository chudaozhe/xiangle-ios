//
//  CWTabBar.m
//
//  Created by wei cui on 2019/11/30.
//  Copyright © 2019 wei cui. All rights reserved.
//  底部tabBar

#import "CWTabBar.h"
#import "LoginController.h"
#import "PublishViewController.h"
#import <SVProgressHUD/SVProgressHUD.h>
#import "TokenModel.h"

@implementation CWTabBar

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
-(instancetype)initWithFrame:(CGRect)frame
{
    
    if (self=[super initWithFrame:frame]) {
        //添加tabBar背景图片
        //self.backgroundImage =[UIImage imageNamed:@"tabbar-light"];
        //中间发布按钮
        UIButton *publishButton=[UIButton buttonWithType:UIButtonTypeCustom];
        [publishButton setBackgroundImage:[UIImage imageNamed:@"jiahao"] forState:UIControlStateNormal];
        [publishButton setBackgroundImage:[UIImage imageNamed:@"jiahao"] forState:UIControlStateHighlighted];
        [publishButton addTarget:self action:@selector(doPublish) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:publishButton];
        self.publishButton=publishButton;
        
    }
    return self;
}
-(void)doPublish{
    //验证是否登录
    TokenModel *userDefaults = [[TokenModel alloc] init];
    NSMutableDictionary *data=[userDefaults getToken:@"user_cookie"];
    NSLog(@"见证奇迹getuserDefaults:%@", data);
    // 请求参数
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    //params[@"user_id"]=?data[@"user_id"]:@0;
    if (nil!=data) {
        UITabBarController *tabBarVc= [UIApplication sharedApplication].keyWindow.rootViewController;
        UINavigationController *nav= (UINavigationController *) tabBarVc.selectedViewController;
        PublishViewController *vc=[[PublishViewController alloc] init];
        //UIAlertControllerStyleActionSheet 底部弹出，不支持文本输入
        UIAlertController *alert=[UIAlertController alertControllerWithTitle:@"" message:nil preferredStyle:UIAlertControllerStyleActionSheet];
        [alert addAction:[UIAlertAction actionWithTitle:@"文字" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            NSLog(@"文字");
            vc.is_album=0;
            [nav pushViewController:vc animated:YES];
        }]];
        [alert addAction:[UIAlertAction actionWithTitle:@"图片/视频" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            NSLog(@"图片/视频");
            vc.is_album=1;
            [nav pushViewController:vc animated:YES];
        }]];
        [alert addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil]];
        
        [nav presentViewController:alert animated:YES completion:nil];
    }else{
        //提示先登录
        [SVProgressHUD showErrorWithStatus:@"请先登录"];
        [SVProgressHUD dismissWithDelay:1.0f];
    }
}
//重新设置TabBar的坐标
-(void)layoutSubviews
{
    [super layoutSubviews];
    self.publishButton.size=self.publishButton.currentBackgroundImage.size;
    //iphone x 需微调一下：self.frame.size.height*0.4
    CGFloat scale=0.5;
    if (CWISIphoneX) {
        scale=0.4;
    }
    self.publishButton.center=CGPointMake(self.width *0.5, self.height*scale);//应该是：self.frame.size.height*0.5
    CGFloat btnY=0;
    CGFloat btnW=self.width/5;
    CGFloat btnH=0;
    //iphone x 需微调一下：self.frame.size.height/1.5
    if (CWISIphoneX) {
        btnH=self.height/1.5;//应该是：self.frame.size.height
    }else{
        btnH=self.height;
    }
    NSInteger index=0;
    for (UIView *btn in self.subviews) {
        //if ([btn isKindOfClass:NSClassFromString(@"UITabBarButton")]) continue;//方法1
        if (![btn isKindOfClass:[UIControl class]] || btn==self.publishButton) continue;//方法2
        CGFloat btnX=btnW*((index>1)?(index+1):index);
        btn.frame=CGRectMake(btnX, btnY, btnW, btnH);
        
        index++;
    }
}
@end
