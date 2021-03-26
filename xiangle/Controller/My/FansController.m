//
//  FansController.m
//  xiangle
//
//  Created by wei cui on 2020/9/25.
//  Copyright © 2020 wei cui. All rights reserved.
//

#import "FansController.h"
#import <MJRefresh/MJRefresh.h>
#import "TokenModel.h"
#import "FollowModel.h"
#import "FollowUser.h"
#import <MJExtension/MJExtension.h>
#import "AuthorController.h"
#import <SDWebImage/SDWebImage.h>
#import "FollowUserCell.h"

@interface FansController ()<UITableViewDelegate, UITableViewDataSource>
@property (strong, nonatomic) UITableView *tableView;
//要加载的数据
@property (nonatomic, strong) NSMutableArray *fields;
/** 备注 */
@property (assign, nonatomic) NSInteger currentPage;
/** 备注 */
@property (strong, nonatomic) NSMutableDictionary *cache;

@end

@implementation FansController
- (void)viewDidLoad {
    [super viewDidLoad];
    self.title=@"我的粉丝";
    self.view.backgroundColor=CWGlobalBgColor;
    self.fields=[[NSMutableArray alloc] init];
    //验证是否登录
    TokenModel *userDefaults = [[TokenModel alloc] init];
    _cache=[userDefaults getToken:@"user_cookie"];
    NSLog(@"见证奇迹getuserDefaults:%@", _cache);
    
    MJRefreshNormalHeader *header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(loadFirst)];
    header.lastUpdatedTimeLabel.hidden=YES;
    header.stateLabel.hidden=YES;
    self.tableView.mj_header=header;
    self.tableView.mj_footer=[MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMore)];

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
        _tableView.rowHeight = 80;
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
    
    params[@"user_id"] = nil!=_cache?_cache[@"user_id"]:@0;
    //params[@"type"] = @1;
    params[@"max"]=@10;
    FollowModel *obj=[[FollowModel alloc] init];
    [obj getFans:params successBlock:^(id  _Nonnull responseObject) {
        [self.view addSubview:self.tableView];
        NSMutableArray *more = [FollowUser mj_objectArrayWithKeyValuesArray:responseObject[@"list"]];
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

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.fields.count;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    FollowUserCell *cell=[FollowUserCell cellWithTableView:tableView];
    FollowUser *field=self.fields[indexPath.row];
    cell.field=field;
    //取消选择cell颜色
    cell.selectionStyle=UITableViewCellSelectionStyleNone;
    return cell;
    
}
//点击某个cell时调用
- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    FollowUser *field=self.fields[indexPath.row];
    AuthorController *vc=[[AuthorController alloc] init];
    vc.id=field.user_id;
    [self.navigationController pushViewController:vc animated:YES];
    
    //NSLog(@"点击了id：%zd", field.id);
}

@end
