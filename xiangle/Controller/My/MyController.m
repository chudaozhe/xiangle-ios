//
//  MyController.m
//  xiangle
//
//  Created by wei cui on 2020/2/29.
//  Copyright © 2020 wei cui. All rights reserved.
//

#import "MyController.h"
#import <AFNetworking/AFNetworking.h>
#import <MJExtension/MJExtension.h>
#import "ShortcutView.h"
#import "Shortcut.h"
#import "SettingController.h"
#import "FeedbackController.h"
#import "FavoriteController.h"
#import "CommentController.h"
#import "LikeController.h"
#import "LoginController.h"
#import "UserModel.h"
#import "MyHeaderView.h"
#import "User.h"
#import <MJRefresh/MJRefresh.h>
#import "TokenModel.h"
#import <SVProgressHUD/SVProgressHUD.h>
#import "FollowController.h"
#import "FansController.h"
#import "RecommendController.h"
#import "BannerView.h"

@interface MyController ()<UIScrollViewDelegate, UITableViewDelegate, UITableViewDataSource>
@property (strong, nonatomic) UIView *boxView;
@property (strong, nonatomic) UIView *shortcutView;
@property (strong, nonatomic) UIScrollView *scrollView;
@property (nonatomic, strong) UIImageView *avatarImageView;

/** 备注 */
@property (strong, nonatomic) BannerView *bannerView;

/** menu */
@property (strong, nonatomic) NSArray *fields;
/** shortcut数据 */
@property (strong, nonatomic) NSArray *fields2;
/** 备注 */
@property (strong, nonatomic) UIView *shortcutBox;
/** 备注 */
@property (strong, nonatomic) MyHeaderView *headerView;
/** 备注 */
@property (strong, nonatomic) NSMutableDictionary *cache;

@end

@implementation MyController
-(NSArray *)fields{
    if (!_fields) {
        //@"我要审核", @"浏览历史"
        //@"推荐给好友",
        _fields=@[@[@"我的收藏", @"我的评论", @"我的点赞"], @[@"意见反馈", @"推荐给朋友", @"设置"]];
    }
    return _fields;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    //1创建scrollView，并添加到View
    [self.view addSubview:self.scrollView];
    MJRefreshNormalHeader *header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(loadFirst)];
    header.lastUpdatedTimeLabel.hidden=YES;
    header.stateLabel.hidden=YES;
    self.scrollView.mj_header=header;
    
    //注册通知(等待接收消息)
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refresh:) name:@"RefreshMyControllerNotify" object:nil];
    [self loadFirst];
}
-(void)loadFirst{
    [self.scrollView addSubview:[self headerView:nil]];
    [self loadData];
}
-(void)refresh:(NSNotification *)sender{
    //打印通知传过来的数值
    NSLog(@"NSNotification：%@",sender);
    //发请求,进入下拉刷新
    [self.scrollView.mj_header beginRefreshing];
}

-(void)loadData{
    // 请求参数
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    //验证是否登录（必须下拉刷新时
    TokenModel *userDefaults = [[TokenModel alloc] init];
    _cache=[userDefaults getToken:@"user_cookie"];
    NSLog(@"见证奇迹getuserDefaults:%@", _cache);
    params[@"user_id"]=nil!=_cache?_cache[@"user_id"]:@0;
    UserModel *obj=[[UserModel alloc] init];
    [obj get:params successBlock:^(id  _Nonnull responseObject) {
        [self.scrollView.mj_header endRefreshing];//结束刷新
        User *info = [User mj_objectWithKeyValues:responseObject];
        [self headerView:info];//赋值
        self.fields2=@[@{@"id":@"0", @"title":@"获赞", @"count":[NSString stringWithFormat:@"%zd", info.like]}, @{@"id":@"1", @"title":@"关注", @"count":[NSString stringWithFormat:@"%zd", info.following]}, @{@"id":@"2", @"title":@"粉丝", @"count":[NSString stringWithFormat:@"%zd", info.followers]}, @{@"id":@"3", @"title":@"作品", @"count":[NSString stringWithFormat:@"%zd", info.posts]}];
        //NSLog(@"self.field:%@", self.fields2);
        [self.scrollView addSubview:self.shortcutView];
        [self createSquares:[Shortcut mj_objectArrayWithKeyValuesArray:self.fields2]];
        [self.scrollView addSubview:self.bannerView];
        [self createMenu];
    } failure:^(NSError * _Nonnull error) {
        NSLog(@"error:%@", error);
    }];
}
#pragma mark - 容器
-(UIScrollView *)scrollView{
    if (_scrollView==nil) {
        CGRect frame=CGRectMake(0, 0, CWScreenW, CWScreenH);
        _scrollView = [[UIScrollView alloc] initWithFrame:frame];
        _scrollView.contentSize = CGSizeMake(CWScreenW, 640);
        _scrollView.backgroundColor = [UIColor whiteColor];
        _scrollView.delegate=self;
        _scrollView.bounces=NO;//禁止弹簧效果
        _scrollView.showsVerticalScrollIndicator=NO;
        UIImageView *bg=[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"my_bg"]];
        [_scrollView addSubview:bg];
    }
    return _scrollView;
}
#pragma mark - 头部视图
-(MyHeaderView *)headerView:(User *)field{
    if (_headerView==nil) {
        _headerView=[[MyHeaderView alloc] init];
        _headerView.frame=CGRectMake(0, 0, CWScreenW, 120);
    }
    _headerView.field=field;
    return _headerView;
}
#pragma mark - 点赞/关注/粉丝/作品
-(UIView *)shortcutView{
    if (_shortcutView==nil) {
        _shortcutView=[[UIView alloc] initWithFrame:CGRectMake(10, CGRectGetMaxY(self.headerView.frame), CWScreenW-20, 200)];
        _shortcutView.backgroundColor=[UIColor whiteColor];
    }
    return _shortcutView;
}
-(void)createSquares:(NSArray *)sqaures{
       if (self.shortcutBox==nil) {
           self.shortcutBox = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.shortcutView.frame.size.width, self.shortcutView.frame.size.height)];
           self.shortcutBox.backgroundColor=[UIColor whiteColor];
           [self.shortcutView addSubview:self.shortcutBox];
       }else{
           //view已存在，清空子view重新创建
           for(ShortcutView *view in [self.shortcutBox subviews]){
               [view removeFromSuperview];
           }
       }
       
       //一行4列
       int maxCols=4;
       //宽和高
       CGFloat btnW=(CWScreenW-20)/maxCols;
       CGFloat btnH=60;
       for (int i=0; i<sqaures.count; i++) {
           ShortcutView *btn=[[ShortcutView alloc] init];
           //btn.backgroundColor=[UIColor redColor];
           //传递模型
           btn.shortcut=sqaures[i];//一个按钮绑一个模型
           [self.shortcutBox addSubview:btn];
           
           int col=i%maxCols;
           btn.frame=CGRectMake(col*btnW, 10, btnW, btnH);
           
           UITapGestureRecognizer * ges = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(btnClick:)];
           [btn addGestureRecognizer:ges];
           //背景
           //[btn setBackgroundColor:[UIColor redColor]];
           //计算背景框高度，（太简单）
           self.shortcutBox.height=CGRectGetMaxY(btn.frame);
       }

}

-(void)btnClick:(UITapGestureRecognizer *)tap{
    ShortcutView *sv=(ShortcutView *)[tap view];
    if (nil!=_cache) {
        if (sv.shortcut.id==1) {//我的关注
            FollowController *vc=[[FollowController alloc] init];
            [self.navigationController pushViewController:vc animated:YES];
        }else if (sv.shortcut.id==2){
            FansController *vc=[[FansController alloc] init];
            [self.navigationController pushViewController:vc animated:YES];
        }
    }else{
        //提示先登录
        [SVProgressHUD showErrorWithStatus:@"请先登录"];
        [SVProgressHUD dismissWithDelay:1.0f];
    }
    
    //NSLog(@"click:%zd", sv.shortcut.id);
}

#pragma mark banner
-(BannerView *)bannerView{
    if (nil==_bannerView) {
        _bannerView=[[BannerView alloc] init];
        _bannerView.frame=CGRectMake(10, 220, CWScreenW-20, 100);
        NSString *f=nil;
        _bannerView.field=f;
    }
    return _bannerView;
}
-(void)createMenu{
    UITableView *menu=[[UITableView alloc] initWithFrame:CGRectMake(10, CGRectGetMaxY(_bannerView.frame), CWScreenW-20, 400) style:(UITableViewStyleGrouped)];
    menu.dataSource=self;
    menu.delegate=self;
    //self.tableView.rowHeight=100;
    //数据如果为空，不展示分割线；有数据才展示分割线
    menu.tableFooterView=[[UIView alloc] init];
    menu.sectionHeaderHeight = 0.01;//只要直接随便设置下面两个属性值后, -(CGFloat)tableView: heightForHeaderInSection:才生效
    //隐藏分割线
    menu.separatorStyle=UITableViewCellSeparatorStyleNone;
    menu.backgroundColor=[UIColor whiteColor];
    menu.tableHeaderView=[[UIView alloc] initWithFrame:CGRectMake(0, 0, CWScreenW, 1)];
    menu.bounces=NO;//禁止弹簧效果
    menu.showsVerticalScrollIndicator=NO;
    [self.scrollView addSubview:menu];
    
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 10;
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return self.fields.count;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [self.fields[section] count];
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell=[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:nil];
    cell.textLabel.text=self.fields[indexPath.section][indexPath.row];//[NSString stringWithFormat:@"%zd", indexPath.row];
    cell.textLabel.font=[UIFont systemFontOfSize:14];
    UIImage *img=[UIImage imageNamed:@"xiaoxi"];
    if (indexPath.section==0 && indexPath.row==0) {
        img=[UIImage imageNamed:@"shoucang2"];
    }else if(indexPath.section==0 && indexPath.row==1){
        img=[UIImage imageNamed:@"pinglun2"];
    }else if(indexPath.section==0 && indexPath.row==2){
        img=[UIImage imageNamed:@"zan2"];
    }else if(indexPath.section==1 && indexPath.row==0){
        img=[UIImage imageNamed:@"email2"];
    }else if(indexPath.section==1 && indexPath.row==1){
        img=[UIImage imageNamed:@"tuijian2"];
    }else if(indexPath.section==1 && indexPath.row==2){
        img=[UIImage imageNamed:@"setting2"];
    }
    cell.imageView.image=img;
    //2、调整大小
          CGSize itemSize = CGSizeMake(26, 26);
          UIGraphicsBeginImageContextWithOptions(itemSize, NO, UIScreen.mainScreen.scale);
          CGRect imageRect = CGRectMake(0.0, 0.0, itemSize.width, itemSize.height);
          [cell.imageView.image drawInRect:imageRect];
          cell.imageView.image = UIGraphicsGetImageFromCurrentImageContext();
          UIGraphicsEndImageContext();
    //取消选择cell颜色
    cell.selectionStyle=UITableViewCellSelectionStyleNone;

    //右侧指示器
    cell.accessoryType=UITableViewCellAccessoryDisclosureIndicator;
    return cell;
}
//点击某个cell时调用
- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    //indexPath.section==0 都需要验证登录状态
    if (indexPath.section==0) {
        if (nil!=_cache) {
            if (indexPath.section==0 && indexPath.row==0) {
                //收藏
                FavoriteController *vc=[[FavoriteController alloc] init];
                [self.navigationController pushViewController:vc animated:YES];
            }else if(indexPath.section==0 && indexPath.row==1) {
                //我的评论
                CommentController *vc=[[CommentController alloc] init];
                [self.navigationController pushViewController:vc animated:YES];
            }else if(indexPath.section==0 && indexPath.row==2) {
                //我的点赞
                LikeController *vc=[[LikeController alloc] init];
                [self.navigationController pushViewController:vc animated:YES];
            }
        }else{
            //提示先登录
            [SVProgressHUD showErrorWithStatus:@"请先登录"];
            [SVProgressHUD dismissWithDelay:1.0f];
        }
        
    }
    if(indexPath.section==1 && indexPath.row==0){
        //意见反馈
        FeedbackController *vc=[[FeedbackController alloc] init];
        [self.navigationController pushViewController:vc animated:YES];
    }else if(indexPath.section==1 && indexPath.row==1) {
        //推荐给朋友
        RecommendController *vc=[[RecommendController alloc] init];
        [self.navigationController pushViewController:vc animated:YES];
    }else if(indexPath.section==1 && indexPath.row==2) {
        //设置
        SettingController *vc=[[SettingController alloc] init];
        [self.navigationController pushViewController:vc animated:YES];
    }
}
- (void)dealloc{
    NSLog(@"注销通知");
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"RefreshMyControllerNotify" object:nil];
}
@end
