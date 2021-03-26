//
//  AuthorController.m
//  xiangle
//  作者主页
//  Created by wei cui on 2020/6/9.
//  Copyright © 2020 wei cui. All rights reserved.
//

#import "AuthorController.h"
#import "AuthorHeaderView.h"
#import "UserModel.h"
#import "TokenModel.h"
#import "Author.h"
#import <MJExtension/MJExtension.h>
#import <MJRefresh/MJRefresh.h>
#import "AuthorModel.h"
#import "Joke.h"
#import "HomeCell.h"
#import "ContentController.h"
#import "UserModel.h"
#import "BottomDialog.h"
#import "SpecifitButton.h"
#import <SVProgressHUD/SVProgressHUD.h>
#import "ShieldModel.h"

@interface AuthorController ()<UITableViewDelegate, UITableViewDataSource>
/** 备注 */
@property (strong, nonatomic) UITableView *tableView;

@property (strong, nonatomic) NSMutableArray *fields;
//当前页码
@property (assign, nonatomic) NSInteger currentPage;
@property (strong, nonatomic) UIScrollView *scrollView;
/** 备注 */
@property (strong, nonatomic) AuthorHeaderView *headerView;
/** 备注 */
@property (strong, nonatomic) BottomDialog *bottomDialogView;
/** 备注 */
@property (strong, nonatomic) NSMutableDictionary *cache;
/** 备注 */
@property (strong, nonatomic) NSArray *sharedArray;
@end

@implementation AuthorController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor=CWGlobalBgColor;
    self.fields=[[NSMutableArray alloc] init];//初始化
    self.title=@"作者主页";
    self.navigationItem.rightBarButtonItem=[[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"diandian"] style:UIBarButtonItemStyleDone target:self action:@selector(more)];
    //self.navigationItem.rightBarButtonItem.tintColor=[UIColor orangeColor];
    //验证是否登录
    TokenModel *userDefaults = [[TokenModel alloc] init];
    _cache=[userDefaults getToken:@"user_cookie"];
    NSLog(@"见证奇迹getuserDefaults:%@", _cache);
    //底部弹窗
    self.sharedArray=@[@{@"name":@"拉黑", @"image":@"lahei"}, @{@"name":@"举报", @"image":@"jubao"}];
    // 请求参数
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"user_id"] = nil!=_cache?_cache[@"user_id"]:@0;;//当前用户id
    params[@"author_id"] = [NSString stringWithFormat:@"%zd", self.id];
    AuthorModel *obj=[[AuthorModel alloc] init];
    [obj get:params successBlock:^(id  _Nonnull responseObject) {
        Author *author=[Author mj_objectWithKeyValues:responseObject];
        //创建tableView
        [self.view addSubview:[self tableView:author]];
        MJRefreshNormalHeader *header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(loadFirst)];
        header.lastUpdatedTimeLabel.hidden=YES;
        header.stateLabel.hidden=YES;
        self.tableView.mj_header=header;
        self.tableView.mj_footer=[MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMore)];
    } failure:^(NSError * _Nonnull error) {
        NSLog(@"error:%@", error);
    }];

    [self loadFirst];//加载第一页
    _currentPage=1;
}

-(void)more{
    [self.bottomDialogView showInView:self.view];
}
-(BottomDialog *)bottomDialogView{
    if (nil==_bottomDialogView) {
        _bottomDialogView=[[BottomDialog alloc] init];
        //一行5列
        int maxCols=5;
        //宽和高
        CGFloat btnW=(CWScreenW-20)/maxCols;
        CGFloat btnH=btnW;
        for (int i=0; i<_sharedArray.count; i++) {
            SpecifitButton *btn=[SpecifitButton buttonWithType:UIButtonTypeCustom];
            int col=i%maxCols;
            int row=i/maxCols;
            btn.frame=CGRectMake(col*btnW, row*btnH, btnW, btnH);
            //分配数据
            btn.field=_sharedArray[i];
            if (i==0) {
                [btn addTarget:self action:@selector(doShield:) forControlEvents:UIControlEventTouchUpInside];
            }else if (i==1){
                [btn addTarget:self action:@selector(doReport:) forControlEvents:UIControlEventTouchUpInside];
            }
            [_bottomDialogView.contentView addSubview:btn];
        }
    }
    return _bottomDialogView;
}
#pragma mark - 容器
-(UIScrollView *)scrollView{
    if (_scrollView==nil) {
        CGRect frame=CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height-80);//底部评论框h=80
        _scrollView = [[UIScrollView alloc] initWithFrame:frame];
        _scrollView.contentSize = CGSizeMake([UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height);
        _scrollView.backgroundColor = [UIColor whiteColor];
        _scrollView.delegate=self;
    }
    NSLog(@"_scrollView.contentSize:%f", _scrollView.contentSize.height);
    return _scrollView;
}
#pragma mark - 头部
-(AuthorHeaderView *)headerView{
    if (_headerView==nil) {
        _headerView=[[AuthorHeaderView alloc] initWithFrame:CGRectMake(0, 0, CWScreenW-20, 50)];
    }
    return _headerView;
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
    params[@"author_id"] = [NSString stringWithFormat:@"%zd", self.id];
    params[@"max"]=@10;

    AuthorModel *obj=[[AuthorModel alloc] init];
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
-(UITableView *)tableView:(Author *) author{
    if (nil==_tableView) {
        AuthorHeaderView *dhv=[[AuthorHeaderView alloc] init];
        dhv.field=author;
        
        _tableView=[[UITableView alloc] initWithFrame:CGRectMake(0, 0, CWScreenW, CWScreenH) style:(UITableViewStylePlain)];
        _tableView.dataSource=self;
        _tableView.delegate=self;
        _tableView.tableHeaderView=dhv;
        _tableView.tableHeaderView.height=150;
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
#pragma mark 举报动作
-(void)doReport:(UIButton *)btn{
    [SVProgressHUD showSuccessWithStatus:@"感谢您的举报，我们会很快处理～"];
    [SVProgressHUD dismissWithDelay:2.0f];
}
#pragma mark 拉黑动作
-(void)doShield:(UIButton *)btn{
    if (nil!=_cache) {
        if (_cache[@"user_id"]==[NSString stringWithFormat:@"%zd", self.id]) {
            [SVProgressHUD showErrorWithStatus:@"不能拉黑自己"];
            [SVProgressHUD dismissWithDelay:2.0f];
        }else{
            ShieldModel *obj=[[ShieldModel alloc] init];
            NSMutableDictionary *params = [NSMutableDictionary dictionary];
            params[@"user_id"] = _cache[@"user_id"];//当前登录用户的user_id
            params[@"to_uid"] = [NSString stringWithFormat:@"%zd", self.id];
            [obj run:params method:@"POST" successBlock:^(id  _Nonnull responseObject) {
                //NSLog(@"result: %@", responseObject);
                NSDictionary *field=responseObject;
                NSLog(@"field:%@", field);//[shield:1]
               //提示已拉黑
                [SVProgressHUD showSuccessWithStatus:@"拉黑成功，您将看不到他的作品～"];
                [SVProgressHUD dismissWithDelay:2.0f];
            } failure:^(NSError * _Nonnull error) {
                NSLog(@"error:%@", error);
            }];
        }
    }else{
        //提示先登录
        [SVProgressHUD showErrorWithStatus:@"请先登录"];
        [SVProgressHUD dismissWithDelay:1.0f];
    }
}
@end
