//
//  LikeController.m
//  xiangle
//
//  Created by wei cui on 2020/3/30.
//  Copyright © 2020 wei cui. All rights reserved.
//

#import "LikeController.h"
#import "ContentController.h"
#import "LikeModel.h"
#import "Like.h"
#import <MJExtension/MJExtension.h>
#import "LikeCell.h"
#import <MJRefresh/MJRefresh.h>
#import "TokenModel.h"

@interface LikeController ()<UITableViewDataSource, UITableViewDelegate>
@property (strong, nonatomic) NSMutableArray *fields;
/** 备注 */
@property (strong, nonatomic) UITableView *tableView;
//当前页码
@property (assign, nonatomic) NSInteger currentPage;

@end

@implementation LikeController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title=@"我的点赞";
    self.fields=[[NSMutableArray alloc] init];//初始化
    [self.view addSubview:self.tableView];
    [self loadFirst];//加载第一页
    MJRefreshNormalHeader *header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(loadFirst)];
    header.lastUpdatedTimeLabel.hidden=YES;
    header.stateLabel.hidden=YES;
    self.tableView.mj_header=header;
    self.tableView.mj_footer=[MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMore)];
    _currentPage=1;
}
-(UITableView *)tableView{
    if(_tableView==nil) {
        _tableView=[[UITableView alloc] initWithFrame:CGRectMake(0, 0, CWScreenW, CWScreenH) style:(UITableViewStylePlain)];
        _tableView.dataSource=self;
        _tableView.delegate=self;
        //self.tableView.rowHeight=100;
        //隐藏分割线
        _tableView.separatorStyle=UITableViewCellSeparatorStyleNone;
        //数据如果为空，不展示分割线；有数据才展示分割线
        _tableView.tableFooterView=[[UIView alloc] init];
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
    params[@"max"]=@10;
    //验证是否登录
    TokenModel *userDefaults = [[TokenModel alloc] init];
    NSMutableDictionary *data=[userDefaults getToken:@"user_cookie"];
    NSLog(@"见证奇迹getuserDefaults:%@", data);
    params[@"user_id"] = nil!=data?data[@"user_id"]:@0;
    LikeModel *obj=[[LikeModel alloc] init];
    [obj gets:params successBlock:^(id  _Nonnull responseObject) {
        NSMutableArray *more = [Like mj_objectArrayWithKeyValuesArray:responseObject[@"list"]];
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
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.fields.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    //cellWithTableView
    LikeCell *cell=[LikeCell cellWithTableView:tableView];
    Like *field=self.fields[indexPath.row];
    cell.field=field;
    //取消选择cell颜色
    cell.selectionStyle=UITableViewCellSelectionStyleNone;
    return cell;
}
//点击某个cell时调用
- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    ContentController *vc=[[ContentController alloc] init];
    Like *field=self.fields[indexPath.row];
    vc.id=field.joke_id;
    [self.navigationController pushViewController:vc animated:YES];
}
/**
 设置cell的真实高度
 */
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    Like *field=self.fields[indexPath.row];
    return field.cellHeight;
}

@end
