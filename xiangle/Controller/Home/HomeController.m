//
//  HomeController.m
//  php
//
//  Created by wei cui on 2019/12/3.
//  Copyright © 2019 wei cui. All rights reserved.
//

#import "HomeController.h"
#import "UIBarButtonItem+Extension.h"
#import "HomeArticleController.h"
#import "SearchController.h"
#import "UIColor+Hex.h"
#import "WebViewController.h"

@interface HomeController ()<UIScrollViewDelegate, UITextViewDelegate>
/** 红色指示器 */
@property (weak, nonatomic) UIView *indicatorView;
/** 当前选中的btn */
@property (weak, nonatomic) UIButton *selectBtn;
/** 顶部所有lab */
@property (weak, nonatomic) UIView *titlesView;
/** contentView */
@property (weak, nonatomic) UIScrollView *contentView;
@end

@implementation HomeController
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationItem.rightBarButtonItem=[[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"search"] style:UIBarButtonItemStyleDone target:self action:@selector(doSearch)];
    self.navigationItem.rightBarButtonItem.tintColor=[UIColor orangeColor];
//    self.navigationItem.titleView=[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"MainTitle"]];
//    self.navigationItem.leftBarButtonItem=[UIBarButtonItem itemWithImage:@"MainTagSubIcon" highImage:@"MainTagSubIconClick" target:self action:@selector(tagBtnClick)];
    self.view.backgroundColor=CWGlobalBgColor;
    //初始化子控制器
    [self setupChildVc];
    //设置顶部tab
    [self setupTitlesView];
    //内容区域
    [self setupContentView];
}
-(void)doSearch{
    SearchController *vc=[[SearchController alloc] init];
    //vc.id=fun.id;
    [self.navigationController pushViewController:vc animated:YES];
}
-(void)setupChildVc
{
    HomeArticleController *article=[[HomeArticleController alloc] init];
    HomeArticleController *article2=[[HomeArticleController alloc] init];
    HomeArticleController *article3=[[HomeArticleController alloc] init];
    HomeArticleController *article4=[[HomeArticleController alloc] init];
    
    article.index=0;
    [self addChildViewController:article];
    article2.index=3;
    [self addChildViewController:article2];
    article3.index=2;
    [self addChildViewController:article3];
    article4.index=1;
    [self addChildViewController:article4];
}
-(void)setupTitlesView
{
    NSLog(@"kNavBarAndStatusBarHeight:%f", kNavBarAndStatusBarHeight);
    UIView *titlesView=[[UIView alloc] init];
    //透明3中方式
    //titlesView.backgroundColor=[UIColor colorWithRed:1.0 green:1.0 blue:1.0 alpha:0.5];
    //titlesView.backgroundColor=[UIColor colorWithWhite: 1.0 alpha:0.5];
    //titlesView.backgroundColor=[[UIColor whiteColor] colorWithAlphaComponent:0.5];
    titlesView.backgroundColor=[UIColor whiteColor];
    titlesView.width=self.view.width;
    titlesView.height=45;
    titlesView.y=kNavBarAndStatusBarHeight;//64，iphoneX顶部是88
    [self.view addSubview:titlesView];
    self.titlesView=titlesView;
    
    //红色指示器
    UIView *indicatorView=[[UIView alloc] init];
    indicatorView.backgroundColor=[UIColor orangeColor];//橙色
    indicatorView.height=2;
    indicatorView.tag=-1;
    indicatorView.y=titlesView.height-indicatorView.height;
    
    self.indicatorView=indicatorView;
    //1=>'File', 2=>'Array', 3=>'String', 4=>'Mysql'
    NSArray *titles=@[@"推荐", @"视频", @"图片", @"文字"];
    CGFloat width=titlesView.width/titles.count;
    CGFloat height=titlesView.height;
    for (NSInteger i=0; i<titles.count; i++) {
        UIButton *btn=[[UIButton alloc] init];
        btn.tag=i;
        btn.height=height;
        btn.width=width;
        btn.x=i*width;
        [btn setTitle:titles[i] forState:UIControlStateNormal];
        [btn setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
        [btn setTitleColor:[UIColor orangeColor] forState:UIControlStateDisabled];
        btn.titleLabel.font=[UIFont systemFontOfSize:14];
        [btn addTarget:self action:@selector(titleClick:) forControlEvents:UIControlEventTouchUpInside];
        [titlesView addSubview:btn];
        //默认点击第一个按钮
        if (i==0) {
            btn.enabled=NO;
            self.selectBtn=btn;
            self.indicatorView.width=btn.titleLabel.width;
            self.indicatorView.centerX=btn.centerX;
        }
    }
    [titlesView addSubview:indicatorView];
}

-(void)titleClick:(UIButton *)btn
{
    //修改按钮状态
    self.selectBtn.enabled=YES;
    btn.enabled=NO;
    self.selectBtn=btn;
    [UIView animateWithDuration:0.25 animations:^{
        self.indicatorView.width=btn.titleLabel.width;
        self.indicatorView.centerX=btn.centerX;
    }];
    //滚动contentView
    CGPoint offset=self.contentView.contentOffset;
    offset.x=btn.tag *self.contentView.width;
    [self.contentView setContentOffset:offset animated:YES];
}
-(void)setupContentView
{
    NSLog(@"%zd", self.childViewControllers.count);
    //禁止系统调整inset
    self.automaticallyAdjustsScrollViewInsets=NO;
    UIScrollView *contentView=[[UIScrollView alloc] init];
    //contentView.backgroundColor=[UIColor redColor];
    contentView.frame=self.view.bounds;
    contentView.delegate=self;
    contentView.pagingEnabled=YES;
    contentView.showsHorizontalScrollIndicator = FALSE;

    [self.view insertSubview:contentView atIndex:0];
    contentView.contentSize=CGSizeMake(contentView.width*self.childViewControllers.count, 0);
    self.contentView=contentView;
    //设置第一个控制器view(x全部)
    [self scrollViewDidEndScrollingAnimation:contentView];
//    contentView.width=self.view.width;
//    contentView.Y=123;//99
//    contentView.height=self.view.height - contentView.Y - self.tabBarController.tabBar.height;
//    [self.view addSubview:contentView];
}
//滚动停止
-(void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView
{
    //添加子控制器的view
    //当前索引
    NSInteger index=scrollView.contentOffset.x/scrollView.width;
    //取出子控制器
    UITableViewController *vc=self.childViewControllers[index];
    vc.view.x=scrollView.contentOffset.x;
    vc.view.y=0;//设置控制器view的y值为0，默认是20
    vc.view.height=scrollView.height;
    //设置内边距
    CGFloat boottom=self.tabBarController.tabBar.height;
    CGFloat top=self.titlesView.frame.size.height;// CGRectGetMaxY(self.titlesView.frame)
    //NSLog(@"titlesView: %f", self.titlesView.frame.size.height);
    //CWLog(@"top:%f", top);
    vc.tableView.contentInset=UIEdgeInsetsMake(top, 0, boottom, 0);
    //设置滚动条内边距
    vc.tableView.scrollIndicatorInsets=vc.tableView.contentInset;
    [scrollView addSubview:vc.view];
}
//停止减速
-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    [self scrollViewDidEndScrollingAnimation:scrollView];
    //点击按钮
    NSInteger index=scrollView.contentOffset.x/scrollView.width;
    NSLog(@"index:%zd", index);
    [self titleClick:self.titlesView.subviews[index]];
}
@end
