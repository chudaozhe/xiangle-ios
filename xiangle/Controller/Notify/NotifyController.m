//
//  NotifyController.m
//  xiangle
//
//  Created by wei cui on 2020/3/10.
//  Copyright © 2020 wei cui. All rights reserved.
//

#import "NotifyController.h"
#import "ContentController.h"
#import "NotifyModel.h"
#import "Notify.h"
#import <MJExtension/MJExtension.h>
#import "NotifyCell.h"
#import "TableViewDataSource.h"
#import <MJRefresh/MJRefresh.h>
#import "TokenModel.h"

@interface NotifyController ()
@property (strong, nonatomic) NSMutableArray *fields;
/** 备注 */
@property (strong, nonatomic) UITableView *tableView;
/** 备注 */
@property (strong, nonatomic) TableViewDataSource *dataSource;
/** 备注 */
@property (strong, nonatomic) TableViewDelegate *delegate;
//当前页码
@property (assign, nonatomic) NSInteger currentPage;
@end

@implementation NotifyController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor=CWGlobalBgColor;
    self.fields=[[NSMutableArray alloc] init];
    [self.view addSubview:self.tableView];
    [self loadFirst];//加载第一页
    MJRefreshNormalHeader *header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(loadFirst)];
    header.lastUpdatedTimeLabel.hidden=YES;
    header.stateLabel.hidden=YES;
    self.tableView.mj_header=header;
    self.tableView.mj_footer=[MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMore)];
    _currentPage=1;
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
    NotifyModel *obj=[[NotifyModel alloc] init];
    [obj gets:params successBlock:^(id  _Nonnull responseObject) {
        NSMutableArray *more = [Notify mj_objectArrayWithKeyValuesArray:responseObject[@"list"]];
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
#pragma mark - 创建列表
-(UITableView *)tableView{
    if (_tableView==nil) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, CWScreenW, CWScreenH) style:UITableViewStylePlain];
        [_tableView registerClass:[NotifyCell class] forCellReuseIdentifier:@"notify"];
        //_tableview.tableFooterView = [UIView new];
        self.delegate = [[TableViewDelegate alloc] initWithRowHeight:^CGFloat(NSIndexPath *indexPath) {
            return 100;
        } headerHeight:^CGFloat(NSInteger section) {
            return 0;
        } footerHeight:^CGFloat(NSInteger section) {
            return 0;
        } header:nil footer:nil didSelect:^(ContentController *vc, NSIndexPath *indexPath) {
//            vc=[[ContentController alloc] init];
//            Notify *field=self.fields[indexPath.row];
//            vc.id=[field.create_time intValue];
//            [self.navigationController pushViewController:vc animated:YES];
        }];
        _tableView.delegate = self.delegate;
        //隐藏分割线
        _tableView.separatorStyle=UITableViewCellSeparatorStyleNone;

        //数据如果为空，不展示分割线；有数据才展示分割线
        self.tableView.tableFooterView=[[UIView alloc] init];
    }
    self.dataSource = [[TableViewDataSource alloc] initWithData:self.fields identifier:@"notify" cellBlock:^(NotifyCell *cell, Notify *field, NSIndexPath *indexPath){
        cell.field = field;
    }];
    _tableView.dataSource = self.dataSource;
    return _tableView;
}

@end
