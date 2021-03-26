//
//  ChooseTopicController.m
//  xiangle
//
//  Created by wei cui on 2020/9/24.
//  Copyright © 2020 wei cui. All rights reserved.
//

#import "ChooseTopicController.h"
#import "FollowTopicCell.h"
#import "Topic.h"
#import "TopicModel.h"
#import <MJExtension/MJExtension.h>
#import <MJRefresh/MJRefresh.h>

@interface ChooseTopicController ()<UITextFieldDelegate, UITableViewDelegate, UITableViewDataSource>
/** 备注 */
@property (strong, nonatomic) UIView *containerView;
@property (strong, nonatomic) UITextField *searchView;
@property (strong, nonatomic) UITableView *tableView;
/** list数组 */
@property (strong, nonatomic) NSMutableArray *fields;
//当前页码
@property (assign, nonatomic) NSInteger currentPage;
@end

@implementation ChooseTopicController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title=@"选择话题";
    self.fields=[[NSMutableArray alloc] init];//初始化
    self.view.backgroundColor=CWGlobalBgColor;
    // Do any additional setup after loading the view.
    [self.view addSubview:self.containerView];
    
    [_containerView addSubview:self.searchView];
    [_containerView addSubview:self.tableView];
    [self loadFirst];//加载第一页
    MJRefreshNormalHeader *header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(loadFirst)];
    header.lastUpdatedTimeLabel.hidden=YES;
    header.stateLabel.hidden=YES;
    self.tableView.mj_header=header;
    self.tableView.mj_footer=[MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMore)];
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
    params[@"user_id"] = @0;
    params[@"category_id"]=@0;
    params[@"keyword"]=self.searchView.text;
    params[@"max"]=@100;
    TopicModel *obj=[[TopicModel alloc] init];
    [obj gets:params successBlock:^(id  _Nonnull responseObject) {
        NSLog(@"result: %@", responseObject);
        NSMutableArray *more = [Topic mj_objectArrayWithKeyValuesArray:responseObject[@"list"]];
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
#pragma mark - 容器
-(UIView *)containerView{
    if (nil==_containerView) {
        CGRect frame=CGRectMake(10, kNavBarAndStatusBarHeight, CWScreenW-20, CWScreenH);
        _containerView = [[UIView alloc] initWithFrame:frame];
    }
    return _containerView;
}
-(UITableView *)tableView{
    if (nil==_tableView) {
        _tableView=[[UITableView alloc] initWithFrame:_searchView.frame style:(UITableViewStylePlain)];
        _tableView.y=self.searchView.height+20;
        _tableView.height=CWScreenH-CGRectGetMaxY(self.searchView.frame)-kNavBarAndStatusBarHeight-10;
        _tableView.dataSource=self;
        _tableView.delegate=self;
        _tableView.rowHeight=80;
        _tableView.separatorStyle=UITableViewCellSeparatorStyleNone;
        //数据如果为空，不展示分割线；有数据才展示分割线
        _tableView.tableFooterView=[[UIView alloc] init];
        _tableView.sectionHeaderHeight = 0.01;//只要直接随便设置下面两个属性值后, -(CGFloat)tableView: heightForHeaderInSection:才生效
    }
    return _tableView;
}
-(UITextField *)searchView{
    if (nil==_searchView) {
        _searchView=[[UITextField alloc] initWithFrame:CGRectMake(0, 10, CWScreenW-20, 30)];
        _searchView.backgroundColor = [UIColor whiteColor];
        _searchView.placeholder=@"请输入关键字";
        //
        _searchView.leftView=self.searchLeftView;
        _searchView.leftViewMode=UITextFieldViewModeAlways; //此处用来设置leftview现实时机
        //_searchView.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
        //清空输入
        _searchView.clearButtonMode = UITextFieldViewModeWhileEditing;

        //边框
        _searchView.borderStyle = UITextBorderStyleRoundedRect;
        //内边距
        [_searchView setValue:[NSNumber numberWithInt:0] forKey:@"paddingLeft"];//光标距离左边的位置
        //文字垂直居中
        _searchView.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
        _searchView.font=[UIFont systemFontOfSize:12];
        
        //键盘return变搜索
        _searchView.returnKeyType=UIReturnKeySearch;
        _searchView.delegate=self;
    }
    return _searchView;
}
-(UIView *)searchLeftView{
    UIView *leftView=[[UIView alloc] initWithFrame:CGRectMake(0, 0, 30, 30)];
    UIImageView *icon=[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"search"]];
    icon.frame=CGRectMake(10, 5, 20, 20);
    [leftView addSubview:icon];
    return leftView;
}
/**
 键盘return变搜索
 */
-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    NSLog(@"搜索key:%@", self.searchView.text);
    //self.tableView=nil;
    [self loadFirst];
    
    [self.searchView resignFirstResponder];
    return YES;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.fields.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    //cellWithTableView
//    FavoriteCell *cell=[[FavoriteCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:nil];
    FollowTopicCell *cell=[FollowTopicCell cellWithTableView:tableView];
    Topic *field=self.fields[indexPath.row];
    cell.field=field;
    //取消选择cell颜色
    cell.selectionStyle=UITableViewCellSelectionStyleNone;
    return cell;
}
//点击某个cell时调用
- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    //ContentController *vc=[[ContentController alloc] init];
    Topic *field=self.fields[indexPath.row];
    NSLog(@"点击了：%@", field);
    //2代理通知list控制器刷新表格，或block
    if ([_delegate respondsToSelector:@selector(onControllerResult:)]) {
        [_delegate onControllerResult:field];
    }
    //[self.view resignFirstResponder];//隐藏键盘
    [self.navigationController popViewControllerAnimated:YES];
    
}
@end
