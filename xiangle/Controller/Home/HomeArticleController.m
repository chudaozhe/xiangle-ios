//
//  HomeArticleController.m
//  php
//
//  Created by wei cui on 2019/12/5.
//  Copyright © 2019 wei cui. All rights reserved.
//

#import "HomeArticleController.h"
#import <AFNetworking/AFNetworking.h>
#import "Joke.h"
#import <MJExtension/MJExtension.h>
#import "HomeCell.h"
#import "ContentController.h"
#import "JokeModel.h"
#import <MJRefresh/MJRefresh.h>
#import "TokenModel.h"

@interface HomeArticleController ()<UITableViewDelegate, UITableViewDataSource>
/** 备注 */
@property (strong, nonatomic) UITableView *tableView;
//要加载的数据
@property (nonatomic, strong) NSMutableArray *fields;
/** 备注 */
@property (assign, nonatomic) NSInteger currentPage;
@end

@implementation HomeArticleController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.fields=[[NSMutableArray alloc] init];
    self.view.backgroundColor=[UIColor whiteColor];
    //self.tableView.rowHeight=400;
    //设置内边距
//    CGFloat boottom=self.tabBarController.tabBar.height;
//    CGFloat top=44;
    //self.tableView.contentInset=UIEdgeInsetsMake(top, 0, boottom, 0);
    //[SVProgressHUD showWithMaskType:SVProgressHUDMaskTypeBlack];
    MJRefreshNormalHeader *header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(loadFirst)];
    header.lastUpdatedTimeLabel.hidden=YES;
    header.stateLabel.hidden=YES;
    self.tableView.mj_header=header;
    self.tableView.mj_footer=[MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMore)];
    _currentPage=1;
    [self loadFirst];//加载第一屏
 
}
-(UITableView *)tableView{
    if (nil==_tableView) {
        _tableView=[[UITableView alloc] initWithFrame:CGRectMake(0, kNavBarAndStatusBarHeight, CWScreenW, CWScreenH) style:(UITableViewStylePlain)];
        _tableView.dataSource=self;
        _tableView.delegate=self;
        //_tableView.rowHeight=100;
        //数据如果为空，不展示分割线；有数据才展示分割线
        _tableView.tableFooterView=[[UIView alloc] init];
        _tableView.sectionHeaderHeight = 0.01;//只要直接随便设置下面两个属性值后, -(CGFloat)tableView: heightForHeaderInSection:才生效
    }
    return _tableView;
}
-(void)loadFirst{
    [self loadData:YES];
}
-(void)loadMore{
    [self loadData:NO];
}
#pragma mark - 加载更多数据
- (void)loadData:(BOOL)first{
    // 请求参数
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    if (first) {
        NSLog(@"loadFirst");
        _currentPage=1;
        [self.fields removeAllObjects];
        params[@"page"]=@1;
    }else{
        NSLog(@"loadMore...");
        params[@"page"]=@(++_currentPage);
    }
    //验证是否登录
    TokenModel *userDefaults = [[TokenModel alloc] init];
    NSMutableDictionary *data=[userDefaults getToken:@"user_cookie"];
    NSLog(@"见证奇迹getuserDefaults:%@", data);
    params[@"user_id"] = nil!=data?data[@"user_id"]:@0;
    params[@"topic_id"] = @0;
    params[@"type"] = [NSString stringWithFormat:@"%zd", self.index];
    params[@"max"]=@10;
    JokeModel *obj=[[JokeModel alloc] init];
    [obj gets:params successBlock:^(id  _Nonnull responseObject) {
        [self.view addSubview:self.tableView];
        NSMutableArray *more = [Joke mj_objectArrayWithKeyValuesArray:responseObject[@"list"]];
        [self.fields addObjectsFromArray:more];
        NSInteger count=[responseObject[@"count"] integerValue];
//        NSLog(@"count: %zd", self.fields.count);
//        NSLog(@"result:%@", self.fields);
        [self.tableView reloadData];
        [self.tableView.mj_header endRefreshing];//结束刷新
        if (self.fields.count>=count) {
            //全部数据加载完毕
            [self.tableView.mj_footer endRefreshingWithNoMoreData];
        }else{
            [self.tableView.mj_footer endRefreshing];
        }
    } failure:^(NSError * _Nonnull error) {
        NSLog(@"error:%@", error);
        [self.tableView.mj_footer endRefreshing];
    }];
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.fields.count;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    HomeCell *cell=[HomeCell cellWithTableView:tableView];
    Joke *field=self.fields[indexPath.row];
    cell.field=field;
    return cell;
}
//点击某个cell时调用
- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    Joke *field=self.fields[indexPath.row];

    ContentController *vc=[[ContentController alloc] init];
    vc.id=field.id;
    [self.navigationController pushViewController:vc animated:YES];
    NSLog(@"点击了id：%zd", field.id);
}
/**
 设置cell的真实高度
 */
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    Joke *field=self.fields[indexPath.row];
    return field.cellHeight;
}
//每行的估计高度：用于性能优化，不设置的话 系统会先拿到所有cell的高度再渲染
//只要设置了 估计高度，就会先调用cellForRowAtIndexPath创建cell，再调用heightForRowAtIndexPath设置当前cell的实际高度
//-(CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    return 100;
//}
// 设置哪里都能显示 复制/粘贴。。。。
- (BOOL)tableView:(UITableView *)tableView shouldShowMenuForRowAtIndexPath:(NSIndexPath *)indexPath{
    return YES;
}
- (BOOL)tableView:(UITableView *)tableView canPerformAction:(SEL)action forRowAtIndexPath:(NSIndexPath *)indexPath withSender:(id)sender{
    // 设置只能复制
    if (action == @selector(cut:)){
        return NO;
    }else if(action == @selector(copy:)){
        return YES;
    }else if(action == @selector(paste:)){
        return NO;
    }else if(action == @selector(select:)){
        return NO;
    }else if(action == @selector(selectAll:)){
        return NO;
    }else{
        return [super canPerformAction:action withSender:sender];
    }
}
-(void)tableView:(UITableView *)tableView performAction:(SEL)action forRowAtIndexPath:(NSIndexPath *)indexPath withSender:(id)sender{
    if (action == @selector(copy:)) {
        //把获取到的字符串放置到剪贴板上
        Joke *field=self.fields[indexPath.row];
        [UIPasteboard generalPasteboard].string = field.content;
    }
}
@end
