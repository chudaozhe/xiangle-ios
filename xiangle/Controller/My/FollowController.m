//
//  FollowController.m
//  xiangle
//
//  Created by wei cui on 2020/9/23.
//  Copyright © 2020 wei cui. All rights reserved.
//

#import "FollowController.h"
#import <MJRefresh/MJRefresh.h>
#import "TokenModel.h"
#import "FollowModel.h"
#import "FollowUser.h"
#import "FollowTopic.h"
#import <MJExtension/MJExtension.h>
#import "AuthorController.h"
#import <SDWebImage/SDWebImage.h>
#import "FollowUserCell.h"
#import "FollowTopicCell.h"
#import "TopicController.h"
#import "Topic.h"

@interface FollowController ()<UITableViewDelegate, UITableViewDataSource>
/** 备注 */
@property (strong, nonatomic) UISegmentedControl *segmentedControl;
@property (strong, nonatomic) UITableView *tableView0;
@property (strong, nonatomic) UITableView *tableView1;
//要加载的数据
@property (nonatomic, strong) NSMutableArray *fields0;
@property (nonatomic, strong) NSMutableArray *fields1;
/** 备注 */
@property (assign, nonatomic) NSInteger currentPage0;
@property (assign, nonatomic) NSInteger currentPage1;
/** 备注 */
@property (assign, nonatomic) NSInteger currentSegmented;

@property (strong, nonatomic) NSMutableDictionary *cache;
@end

@implementation FollowController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor=CWGlobalBgColor;
    [self.navigationItem setTitleView:self.segmentedControl];
    self.fields0=[[NSMutableArray alloc] init];
    self.fields1=[[NSMutableArray alloc] init];
    //验证是否登录
    TokenModel *userDefaults = [[TokenModel alloc] init];
    _cache=[userDefaults getToken:@"user_cookie"];
    NSLog(@"见证奇迹getuserDefaults:%@", _cache);
    
    MJRefreshNormalHeader *header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(loadFirst)];
    header.lastUpdatedTimeLabel.hidden=YES;
    header.stateLabel.hidden=YES;
    self.tableView0.mj_header=header;
    self.tableView0.mj_footer=[MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMore)];
    
    MJRefreshNormalHeader *header2 = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(loadFirst)];
    header2.lastUpdatedTimeLabel.hidden=YES;
    header2.stateLabel.hidden=YES;
    self.tableView1.mj_header=header2;
    self.tableView1.mj_footer=[MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMore)];
    _currentPage0=1;
    _currentPage1=1;
    [self loadFirst];//加载第一屏
    //[self.view addSubview:self.pageControl];
}
#pragma mark 分段控件
-(UISegmentedControl *)segmentedControl{
    if (nil==_segmentedControl) {
        _segmentedControl=[[UISegmentedControl alloc] initWithItems:@[@"用户", @"话题"]];
        _segmentedControl.frame=CGRectMake(60, 100, 200, 30);
        _segmentedControl.selectedSegmentIndex=0;//默认选中第1个
        
        //_segmentedControl.selectedSegmentTintColor=[UIColor orangeColor];
        
        //添加事件
        [_segmentedControl addTarget:self action:@selector(indexDidChangeForSegmentedControl:) forControlEvents:UIControlEventValueChanged];
    }
    return _segmentedControl;
}

-(void)indexDidChangeForSegmentedControl:(UISegmentedControl *)sender{
    NSLog(@"index:%ld",sender.selectedSegmentIndex);
    if (sender.selectedSegmentIndex==0) {
        _tableView0.hidden = NO;
        _tableView1.hidden = YES;
        _currentSegmented=0;
    }else{
        //1
        _tableView0.hidden = YES;
        _tableView1.hidden = NO;
        _currentSegmented=1;
    }
    [self loadFirst];//加载第一屏
}
-(UITableView *)tableView0{
    if (nil==_tableView0) {
        _tableView0=[[UITableView alloc] initWithFrame:CGRectMake(0, kNavBarAndStatusBarHeight, CWScreenW, CWScreenH) style:(UITableViewStylePlain)];
        _tableView0.dataSource=self;
        _tableView0.delegate=self;
        //_tableView0.rowHeight=100;
        //数据如果为空，不展示分割线；有数据才展示分割线
        _tableView0.tableFooterView=[[UIView alloc] init];
        _tableView0.rowHeight = 80;
    }
    return _tableView0;
}
-(UITableView *)tableView1{
    if (nil==_tableView1) {
        _tableView1=[[UITableView alloc] initWithFrame:CGRectMake(0, kNavBarAndStatusBarHeight, CWScreenW, CWScreenH) style:(UITableViewStylePlain)];
        _tableView1.dataSource=self;
        _tableView1.delegate=self;
        //_tableView1.rowHeight=100;
        //数据如果为空，不展示分割线；有数据才展示分割线
        _tableView1.tableFooterView=[[UIView alloc] init];
        _tableView1.rowHeight = 80;
    }
    return _tableView1;
}
-(void)loadFirst{
    if (_currentSegmented==0) {
        [self loadData0:YES];
    }else [self loadData1:YES];
}
-(void)loadMore{
    if (_currentSegmented==0) {
        [self loadData0:NO];
    }else [self loadData1:NO];
}
#pragma mark - 加载更多数据
- (void)loadData0:(BOOL)first{
    // 请求参数
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    if (first) {
        NSLog(@"loadFirst");
        _currentPage0=1;
        [self.fields0 removeAllObjects];
        params[@"page"]=@1;
    }else{
        NSLog(@"loadMore...");
        params[@"page"]=@(++_currentPage0);
    }
    params[@"user_id"] = nil!=_cache?_cache[@"user_id"]:@0;
    params[@"type"] = @1;
    params[@"max"]=@10;
    FollowModel *obj=[[FollowModel alloc] init];
    [obj gets:params successBlock:^(id  _Nonnull responseObject) {
        [self.view addSubview:self.tableView0];
        NSMutableArray *more = [FollowUser mj_objectArrayWithKeyValuesArray:responseObject[@"list"]];
        [self.fields0 addObjectsFromArray:more];
        NSInteger count=[responseObject[@"count"] integerValue];
        NSLog(@"count: %zd", self.fields0.count);
        [self.tableView0 reloadData];
        [self.tableView0.mj_header endRefreshing];//结束刷新
        if (self.fields0.count>=count) {
            //全部数据加载完毕
            [self.tableView0.mj_footer endRefreshingWithNoMoreData];
        }else{
            [self.tableView0.mj_footer endRefreshing];
        }
    } failure:^(NSError * _Nonnull error) {
        NSLog(@"error:%@", error);
        [self.tableView0.mj_footer endRefreshing];
    }];
}
#pragma mark - 加载更多数据
- (void)loadData1:(BOOL)first{
    // 请求参数
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    if (first) {
        NSLog(@"loadFirst");
        _currentPage1=1;
        [self.fields1 removeAllObjects];
        params[@"page"]=@1;
    }else{
        NSLog(@"loadMore...");
        params[@"page"]=@(++_currentPage1);
    }
    //验证是否登录
    TokenModel *userDefaults = [[TokenModel alloc] init];
    NSMutableDictionary *data=[userDefaults getToken:@"user_cookie"];
    NSLog(@"见证奇迹getuserDefaults:%@", data);
    params[@"user_id"] = nil!=data?data[@"user_id"]:@0;
    params[@"type"] = @2;
    params[@"max"]=@10;
    FollowModel *obj=[[FollowModel alloc] init];
    [obj gets:params successBlock:^(id  _Nonnull responseObject) {
        [self.view addSubview:self.tableView1];
        NSMutableArray *more = [FollowTopic mj_objectArrayWithKeyValuesArray:responseObject[@"list"]];
        [self.fields1 addObjectsFromArray:more];
        NSInteger count=[responseObject[@"count"] integerValue];
        NSLog(@"count: %zd", self.fields1.count);
        [self.tableView1 reloadData];
        [self.tableView1.mj_header endRefreshing];//结束刷新
        if (self.fields1.count>=count) {
            //全部数据加载完毕
            [self.tableView1.mj_footer endRefreshingWithNoMoreData];
        }else{
            [self.tableView1.mj_footer endRefreshing];
        }
    } failure:^(NSError * _Nonnull error) {
        NSLog(@"error:%@", error);
        [self.tableView1.mj_footer endRefreshing];
    }];
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (_currentSegmented==0) {
        return self.fields0.count;
    }else return self.fields1.count;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
//    UITableViewCell *cell=[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:nil];
//    FollowUser *field=self.fields0[indexPath.row];
//    cell.textLabel.text=@"aa";
//    cell.imageView.image=[UIImage imageNamed:field.avatar];
//    cell.detailTextLabel.text=@"cc";
    if (_currentSegmented==0) {
        FollowUserCell *cell=[FollowUserCell cellWithTableView:tableView];
        FollowUser *field=self.fields0[indexPath.row];
        cell.field=field;
        //取消选择cell颜色
        cell.selectionStyle=UITableViewCellSelectionStyleNone;
        return cell;
    }else{
        FollowTopicCell *cell=[FollowTopicCell cellWithTableView:tableView];
        FollowTopic *field=self.fields1[indexPath.row];
        cell.field=field;
        //取消选择cell颜色
        cell.selectionStyle=UITableViewCellSelectionStyleNone;
        return cell;
    }
    
}
//点击某个cell时调用
- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (_currentSegmented==0) {
        FollowUser *field=self.fields0[indexPath.row];
        AuthorController *vc=[[AuthorController alloc] init];
        vc.id=field.to_user_id;
        [self.navigationController pushViewController:vc animated:YES];
    }else{
        FollowTopic *field=self.fields1[indexPath.row];
        Topic *t=[[Topic new] setTopic:field.topic_id name:field.name image:field.image sum:field.sum];
//        Topic *t=[Topic new];
//        t.id=1;
        
        //NSLog(@"t:%@", t);
        TopicController *vc=[[TopicController alloc] init];
        vc.id=t.id;
        [self.navigationController pushViewController:vc animated:YES];
    }
    
    //NSLog(@"点击了id：%zd", field.id);
}
///**
// 设置cell的真实高度
// */
//- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
//    return 80;
//}
@end
