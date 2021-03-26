//
//  NavigationController.m
//  ios_enterprise
//
//  Created by wei cui on 2020/1/7.
//  Copyright © 2020 wei cui. All rights reserved.
//

#import "NavigationController.h"

@interface NavigationController ()

@end

@implementation NavigationController

//一次性设置
+(void)initialize
{
    //顶部navigationBar背景图片
    //方法1，viewDidLoad，pushViewController内有效
    //[self.navigationBar setBackgroundImage:[UIImage imageNamed:@"navigationbarBackgroundWhite"] forBarMetrics:UIBarMetricsDefault];
    //方法2， 仅仅 CWNavigationController 设置背景图片
    //UINavigationBar *bar=[UINavigationBar appearanceWhenContainedIn:[self class], nil];
    //方法3，全部UINavigationBar及继承者都添加背景图片
    UINavigationBar *bar=[UINavigationBar appearance];
    [bar setBackgroundImage:[UIImage imageNamed:@"navigationbarBackgroundWhite"] forBarMetrics:UIBarMetricsDefault];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}
//重写pushViewController
-(void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated
{
    if (self.childViewControllers.count>0) { //如果push进来的不是第一个控制器，就加返回按钮
        UIButton *back=[UIButton buttonWithType:UIButtonTypeCustom];
        [back setTitle:@"返回" forState:UIControlStateNormal];
        [back setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [back setTitleColor:[UIColor redColor] forState:UIControlStateHighlighted];
        [back setImage:[UIImage imageNamed:@"navigationButtonReturn"] forState:UIControlStateNormal];
        [back setImage:[UIImage imageNamed:@"navigationButtonReturnClick"] forState:UIControlStateHighlighted];
        //点击事件
        [back addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
        back.size=CGSizeMake(70, 30);
        back.contentHorizontalAlignment=UISegmentedControlSegmentLeft;//按钮内所有内容左对齐
        back.contentEdgeInsets=UIEdgeInsetsMake(0, -10, 0, 0);//内边距 左边-10
        
        viewController.navigationItem.leftBarButtonItem=[[UIBarButtonItem alloc] initWithCustomView:back];
        viewController.hidesBottomBarWhenPushed=YES;//隐藏tabbar
        //viewController.navigationItem.backBarButtonItem=[[UIBarButtonItem alloc] initWithTitle:@"t返回2" style:UIBarButtonItemStyleDone target:nil action:nil];
    
    }
    
    [super pushViewController:viewController animated:YES];
}
-(void)back
{
    [self popViewControllerAnimated:YES];
}

@end
