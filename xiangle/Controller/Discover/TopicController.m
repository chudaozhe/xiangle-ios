//
//  TopicController.m
//  xiangle
//  话题下的内容列表
//  Created by wei cui on 2020/3/12.
//  Copyright © 2020 wei cui. All rights reserved.
//

#import "TopicController.h"
#import "ContentController.h"
#import <MJExtension/MJExtension.h>
#import "TopicHeaderView.h"
#import "JokeModel.h"
#import "Joke.h"
#import "TopicJokeCell.h"
#import "Topic.h"
#import <MJRefresh/MJRefresh.h>
#import "TokenModel.h"
#import "TopicModel.h"

@interface TopicController ()<UITableViewDelegate, UITableViewDataSource>
/** 备注 */
@property (strong, nonatomic) UITableView *tableView;

@property (strong, nonatomic) NSMutableArray *fields;
//当前页码
@property (assign, nonatomic) NSInteger currentPage;

@end

@implementation TopicController
- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor=CWGlobalBgColor;
    self.title=@"话题";
    self.fields=[[NSMutableArray alloc] init];//初始化
    //header
    // 请求参数
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"user_id"] = @0;
    params[@"id"] = [NSString stringWithFormat:@"%zd", self.id];
    TopicModel *obj=[[TopicModel alloc] init];
    [obj get:params successBlock:^(id  _Nonnull responseObject) {
        NSLog(@"result: %@", responseObject);
        Topic *field=[Topic mj_objectWithKeyValues:responseObject[@"data"]];
        self.topic=field;
        //创建tableView
        [self.view addSubview:self.tableView];

        MJRefreshNormalHeader *header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(loadFirst)];
        header.lastUpdatedTimeLabel.hidden=YES;
        header.stateLabel.hidden=YES;
        self.tableView.mj_header=header;
        self.tableView.mj_footer=[MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMore)];
        [self loadFirst];//加载第一页
    } failure:^(NSError * _Nonnull error) {
        NSLog(@"error:%@", error);
    }];
    //_currentPage=1;
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
    params[@"max"]=@10;
    params[@"topic_id"] = [NSString stringWithFormat:@"%zd", self.topic.id];
    JokeModel *obj=[[JokeModel alloc] init];
    [obj gets:params successBlock:^(id  _Nonnull responseObject) {
        NSMutableArray *more = [Joke mj_objectArrayWithKeyValuesArray:responseObject[@"list"]];
        [self.fields addObjectsFromArray:more];
        NSInteger count=[responseObject[@"count"] integerValue];
        NSLog(@"count: %zd", self.fields.count);
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
-(UITableView *)tableView{
    if (nil==_tableView) {
        TopicHeaderView *dhv=[[TopicHeaderView alloc] init];
        dhv.frame=CGRectMake(0, 0, CWScreenW, 100);
        dhv.field=self.topic;
        
        _tableView=[[UITableView alloc] initWithFrame:CGRectMake(0, 0, CWScreenW, CWScreenH) style:(UITableViewStylePlain)];
        _tableView.dataSource=self;
        _tableView.delegate=self;
        _tableView.tableHeaderView=dhv;
        //self.tableView.rowHeight=100;
        //数据如果为空，不展示分割线；有数据才展示分割线
        _tableView.tableFooterView=[[UIView alloc] init];
        _tableView.sectionHeaderHeight = 0.01;//只要直接随便设置下面两个属性值后, -(CGFloat)tableView: heightForHeaderInSection:才生效
    }
    return _tableView;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.fields.count;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    TopicJokeCell *cell=[TopicJokeCell cellWithTableView:tableView];
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
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    Joke *field=self.fields[indexPath.row];
    return field.cellHeight;
}
//每行的估计高度：用于性能优化，不设置的话 系统会先拿到所有cell的高度再渲染
//只要设置了 估计高度，就会先调用cellForRowAtIndexPath创建cell，再调用heightForRowAtIndexPath设置当前cell的实际高度
//-(CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    return 100;
//}

@end
