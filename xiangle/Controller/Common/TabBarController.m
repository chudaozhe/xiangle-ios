//
//  TabBarController.m
//  ios_enterprise
//  底部tab
//  Created by wei cui on 2020/1/7.
//  Copyright © 2020 wei cui. All rights reserved.
//

#import "TabBarController.h"
#import "HomeController.h"
#import "MyController.h"
#import "DiscoverController.h"
#import "NotifyController.h"
#import "CWTabBar.h"
#import "NavigationController.h"

@interface TabBarController ()

@end

@implementation TabBarController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    NSMutableDictionary *attrs= [NSMutableDictionary dictionary];
    attrs[NSFontAttributeName]=[UIFont systemFontOfSize:12];//字体大小
    attrs[NSForegroundColorAttributeName]=[UIColor grayColor];//Foreground 前面文字的颜色，对应background
    NSMutableDictionary *attrs2= [NSMutableDictionary dictionary];
    attrs2[NSFontAttributeName]=attrs[NSFontAttributeName];
    attrs2[NSForegroundColorAttributeName]=[UIColor orangeColor];
    //通过appearance，为所有tabBarItem设置统一的样式
    UITabBarItem *item=[UITabBarItem appearance];
    [item setTitleTextAttributes:attrs forState:UIControlStateNormal];
    [item setTitleTextAttributes:attrs2 forState:UIControlStateSelected];
    //添加子控制器
    [self setupChildVc:[[HomeController alloc] init] title:@"首页" image:@"shouye" selectImage:@"shouye2"];
    [self setupChildVc:[[DiscoverController alloc] init] title:@"发现" image:@"faxian" selectImage:@"faxian2"];
    [self setupChildVc:[[NotifyController alloc] init] title:@"消息" image:@"xiaoxi" selectImage:@"xiaoxi2"];
    [self setupChildVc:[[MyController alloc] init] title:@"我的" image:@"user" selectImage:@"user2"];
    //自定义tabBar
    //self.tabBar=[[CWTabBar alloc] init];
    //只读属性不能赋值，可以试下kvc赋值
    [self setValue:[[CWTabBar alloc] init] forKey:@"tabBar"];
}
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear: animated];
}
-(void)setupChildVc:(UIViewController *)vc  title:(NSString *)title image:(NSString *)image selectImage:(NSString *)selectImage
{
    
    vc.navigationItem.title=title;
    //RGB的颜色值范围都是在0.0~1.0之间的
    //vc.view.backgroundColor=[UIColor colorWithRed:arc4random_uniform(100)/100.0 green:arc4random_uniform(100)/100.0 blue:arc4random_uniform(100)/100.0 alpha:1.0];
    vc.tabBarItem.title=title;
    vc.tabBarItem.image=[UIImage imageNamed:image];
    vc.tabBarItem.selectedImage=[UIImage imageNamed:selectImage];
    
    //包装一个导航控制器
    UINavigationController *navVc=[[NavigationController alloc] initWithRootViewController:vc];
    [self addChildViewController:navVc];
}

@end
