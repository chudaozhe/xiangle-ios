//
//  DiscoverController.m
//  xiangle
//
//  Created by wei cui on 2020/3/1.
//  Copyright © 2020 wei cui. All rights reserved.
//

#import "DiscoverController.h"
#import "TopicModel.h"
#import "FlashModel.h"
#import "Topic.h"
#import "Flash.h"
#import "FlashView.h"
#import <MJExtension/MJExtension.h>
#import <SVProgressHUD/SVProgressHUD.h>
#import <MJRefresh/MJRefresh.h>
#import "SearchController.h"
#import "TopicController.h"
#import "ContentController.h"
#import "CategoryCell.h"
#import "TopicCell.h"
#import "Category1.h"
#import "TokenModel.h"

@interface DiscoverController ()<UIScrollViewDelegate, UITableViewDelegate, UITableViewDataSource>
/** 备注 */
@property (strong, nonatomic) UITableView *leftTableView;
@property (strong, nonatomic) UITableView *rightTableView;
@property (strong, nonatomic) UIView *containerView;
/** 备注 */
@property (strong, nonatomic) UILabel *topicTitle;

//左侧表格数据（分类列表）
@property (strong, nonatomic) NSArray *fields1;
//右侧表格数据（话题列表）
@property (strong, nonatomic) NSMutableArray *fields2;
/** 备注 */
@property (assign, nonatomic) NSInteger currentPage;

/** 备注 */
@property (strong, nonatomic) FlashView *flashView;
@end

@implementation DiscoverController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.rightBarButtonItem=[[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"search"] style:UIBarButtonItemStyleDone target:self action:@selector(doSearch)];
    self.navigationItem.rightBarButtonItem.tintColor=[UIColor orangeColor];
    
    self.fields2=[[NSMutableArray alloc] init];
    self.view.backgroundColor=[UIColor whiteColor];
    //2创建containerView,其他板块都在其中（灰色）
    self.containerView=[[UIView alloc] initWithFrame:CGRectMake(0, kNavBarAndStatusBarHeight, CWScreenW, CWScreenH)];
    self.containerView.backgroundColor=[UIColor whiteColor];
    [self.view addSubview:self.containerView];
    
    //3子模块
    [self.containerView addSubview:self.flashView];
    [self topics];
}
-(void)doSearch{
    SearchController *vc=[[SearchController alloc] init];
    //vc.id=fun.id;
    [self.navigationController pushViewController:vc animated:YES];
}
#pragma mark 轮播图
-(FlashView *)flashView{
    if (nil==_flashView) {
        _flashView=[[FlashView alloc] init];
        _flashView.frame=CGRectMake(0, 0, CWScreenW, (CWScreenW/30)*13);
        Flash *f=nil;
        self.flashView.field=f;
    }
    return _flashView;
}
#pragma mark 全部话题
-(void)topics{
    _topicTitle=[[UILabel alloc] initWithFrame:CGRectMake(10, CGRectGetMaxY(self.flashView.frame)+10, 100, 20)];
    _topicTitle.text=@"全部话题";
    _topicTitle.textColor=[UIColor orangeColor];
    [self.containerView addSubview:_topicTitle];
    
    [self loadCategory];
}
-(void)loadCategory{
    TopicModel *obj=[[TopicModel alloc] init];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [obj getCategorys:params successBlock:^(id  _Nonnull responseObject) {
        [self.containerView addSubview:self.leftTableView];
        NSMutableArray *more = [Category1 mj_objectArrayWithKeyValuesArray:responseObject];
        self.fields1=more;
        NSLog(@"categorys:%@", self.fields1);
        [self.leftTableView reloadData];
        
        [self.containerView addSubview:self.rightTableView];
        MJRefreshNormalHeader *header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(loadFirst)];
        header.lastUpdatedTimeLabel.hidden=YES;
        header.stateLabel.hidden=YES;
        self.rightTableView.mj_header=header;
        self.rightTableView.mj_footer=[MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMore)];
        //选中首行
        [self.leftTableView selectRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0] animated:NO scrollPosition:UITableViewScrollPositionTop];
        [self tableView:self.leftTableView didSelectRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];//模拟点击
    } failure:^(NSError * _Nonnull error) {
        NSLog(@"error:%@", error);
        [self.leftTableView.mj_footer endRefreshing];
    }];
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
        [self.fields2 removeAllObjects];
        params[@"page"]=@1;
    }else{
        NSLog(@"loadMore...");
        params[@"page"]=@(++_currentPage);
    }
    Category1 *c= self.fields1[self.leftTableView.indexPathForSelectedRow.row];
    //验证是否登录
    TokenModel *userDefaults = [[TokenModel alloc] init];
    NSMutableDictionary *data=[userDefaults getToken:@"user_cookie"];
    NSLog(@"见证奇迹getuserDefaults:%@", data);
    params[@"user_id"] = nil!=data?data[@"user_id"]:@0;
    //params[@"user_id"] = @1;
    params[@"category_id"]=@(c.id);
    //params[@"keyword"]=@"";
    params[@"max"]=@10;
    TopicModel *obj=[[TopicModel alloc] init];
    [obj gets:params successBlock:^(id  _Nonnull responseObject) {
        NSMutableArray *more = [Topic mj_objectArrayWithKeyValuesArray:responseObject[@"list"]];
        [self.fields2 addObjectsFromArray:more];
        //NSLog(@"count: %zd", self.fields2.count);
        //NSLog(@"fields2: %@", self.fields2);
        //NSLog(@"more: %@", more);
        NSInteger count=[responseObject[@"count"] integerValue];
       
        [self.rightTableView reloadData];
        [self.rightTableView.mj_header endRefreshing];//结束刷新
        if (self.fields2.count>=count) {
            //全部数据加载完毕
            [self.rightTableView.mj_footer endRefreshingWithNoMoreData];
        }else{
            [self.rightTableView.mj_footer endRefreshing];
        }
    } failure:^(NSError * _Nonnull error) {
        NSLog(@"error:%@", error);
        [self.rightTableView.mj_footer endRefreshing];
    }];
}
-(UITableView *)leftTableView{
    if (nil==_leftTableView) {
        CGFloat y=CGRectGetMaxY(self.topicTitle.frame);
        _leftTableView=[[UITableView alloc] initWithFrame:CGRectMake(0, y+10, CWScreenW*0.2, CWScreenH-kNavAndTabHeight-y-10) style:(UITableViewStylePlain)];
        _leftTableView.dataSource=self;
        _leftTableView.delegate=self;
        _leftTableView.separatorStyle=UITableViewCellSeparatorStyleNone;
        //_leftTableView.backgroundColor=[UIColor redColor];
        //_leftTableView.rowHeight=100;
        //数据如果为空，不展示分割线；有数据才展示分割线
        _leftTableView.tableFooterView=[[UIView alloc] init];
        _leftTableView.sectionHeaderHeight = 0.01;//只要直接随便设置下面两个属性值后, -(CGFloat)tableView: heightForHeaderInSection:才生效
        _leftTableView.bounces=NO;//禁止弹簧效果
        _leftTableView.showsVerticalScrollIndicator=NO;
    }
    return _leftTableView;
}
-(UITableView *)rightTableView{
    if (nil==_rightTableView) {
        _rightTableView=[[UITableView alloc] initWithFrame:_leftTableView.frame style:(UITableViewStylePlain)];
        _rightTableView.width=CWScreenW*0.78;
        _rightTableView.x=CWScreenW*0.22;
        _rightTableView.dataSource=self;
        _rightTableView.delegate=self;
        _rightTableView.separatorStyle=UITableViewCellSeparatorStyleNone;
        _rightTableView.rowHeight=60;
        //数据如果为空，不展示分割线；有数据才展示分割线
        _rightTableView.tableFooterView=[[UIView alloc] init];
        _rightTableView.sectionHeaderHeight = 0.01;//只要直接随便设置下面两个属性值后, -(CGFloat)tableView: heightForHeaderInSection:才生效
        //_rightTableView.showsVerticalScrollIndicator=NO;
    }
    return _rightTableView;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (tableView==self.leftTableView) {
        return self.fields1.count;
    }else{
        //右侧
        //Category1 *c= self.fields1[self.leftTableView.indexPathForSelectedRow.row];
        self.rightTableView.mj_footer.hidden=(self.fields2.count==0);//每次刷新右侧数据时，隐藏footer
        return self.fields2.count;
    }
    
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView ==self.leftTableView) {
        //left
        CategoryCell *cell=[CategoryCell cellWithTableView:tableView];
        Category1 *field = self.fields1[indexPath.row];
        cell.field=field;
        cell.textLabel.font=[UIFont systemFontOfSize:12.0];
        //取消选择cell颜色
        cell.selectionStyle=UITableViewCellSelectionStyleNone;
        
//        UIView *selectbg=[[UIView alloc] init];
//        selectbg.backgroundColor=[UIColor whiteColor];
//        cell.selectedBackgroundView=selectbg;

        return cell;
    }else {
        //right
        TopicCell *cell=[TopicCell cellWithTableView:tableView];
        
        //Category1 *c= self.fields1[self.leftTableView.indexPathForSelectedRow.row];
        Topic *field = self.fields2[indexPath.row];
        
        cell.field=field;
        cell.textLabel.font=[UIFont systemFontOfSize:12.0];
        //取消选择cell颜色
        cell.selectionStyle=UITableViewCellSelectionStyleNone;
        return cell;
    }
    
}

//点击某个cell时调用
- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (tableView==self.leftTableView) {
        //发请求,进入下拉刷新
        [self.rightTableView.mj_header beginRefreshing];
    }else{
        NSLog(@"点击了右侧tableView:%zd", indexPath.row);
        Topic *field=self.fields2[indexPath.row];
        TopicController *vc=[[TopicController alloc] init];
        vc.id=field.id;
        [self.navigationController pushViewController:vc animated:YES];
    }
}
/**
 设置cell的真实高度
 */
//- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
//    Topic *field=self.fields2[indexPath.row];
//    //NSLog(@"field.cellHeight:%f", field.cellHeight);
//    return field.cellHeight;
//}
//每行的估计高度：用于性能优化，不设置的话 系统会先拿到所有cell的高度再渲染
//只要设置了 估计高度，就会先调用cellForRowAtIndexPath创建cell，再调用heightForRowAtIndexPath设置当前cell的实际高度
//-(CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath{
//    return 100;
//}
@end
