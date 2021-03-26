//
//  CWContentController.m
//  php
//
//  Created by wei cui on 2019/12/5.
//  Copyright © 2019 wei cui. All rights reserved.
//
#import <WebKit/WebKit.h>
#import "ContentController.h"
#import <AFNetworking/AFNetworking.h>
#import "UIColor+Hex.h"
#import <MJExtension/MJExtension.h>
#import "JokeModel.h"
#import "CommentModel.h"
#import "Joke.h"
#import <SDWebImage/SDWebImage.h>
#import "CommentCell.h"
#import "ImageBrowser.h"
#import "VideoBrowser.h"
#import <MJRefresh/MJRefresh.h>
#import "GridLayout.h"
#import "FollowModel.h"
#import "ContentHeaderView.h"
#import "FavoriteModel.h"
#import "LikeModel.h"
#import "ContentFooterView.h"
#import "TokenModel.h"
#import <SVProgressHUD/SVProgressHUD.h>
#import "UIColor+Hex.h"

@interface ContentController ()<UIScrollViewDelegate, UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate>

@property (strong, nonatomic) UIScrollView *scrollView;
/** 备注 */
@property (strong, nonatomic) ContentHeaderView *headerView;
/** 备注 */
@property (strong, nonatomic) UILabel *contentLabel;
/** 九宫格布局 */
@property (strong, nonatomic) GridLayout *gridLayout;
/** 备注 */
@property (strong, nonatomic) UITableView *tableView;
/** 包裹着 评论输入框 */
@property (strong, nonatomic) ContentFooterView *footerView;
/** 评论输入框 */
@property (strong, nonatomic) UITextField *comment;
/** 评论列表 */
@property (strong, nonatomic) NSMutableArray *fields;
//评论，当前页码
@property (assign, nonatomic) NSInteger currentPage;
@end

@implementation ContentController
- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor=[UIColor whiteColor];
    self.fields=[[NSMutableArray alloc] init];//初始化
    self.title=@"段子详情";
    //1创建scrollView，并添加到View（蓝色）
    [self.view addSubview:self.scrollView];
    // 请求参数
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    //验证是否登录
    TokenModel *userDefaults = [[TokenModel alloc] init];
    NSMutableDictionary *data=[userDefaults getToken:@"user_cookie"];
    NSLog(@"见证奇迹getuserDefaults:%@", data);
    params[@"user_id"] = nil!=data?data[@"user_id"]:@0;
    params[@"id"] = [NSString stringWithFormat:@"%zd", self.id];
    JokeModel *obj=[[JokeModel alloc] init];
    [obj get:params successBlock:^(id  _Nonnull responseObject) {
        NSLog(@"result: %@", responseObject);
        Joke *field=[Joke mj_objectWithKeyValues:responseObject[@"data"]];
        //头部
        [self.scrollView addSubview:self.headerView];
        self.headerView.field=field;//赋值
        [self createContent:field];
        //评论列表
        [self.scrollView addSubview:self.tableView];
        //底部
        [self.view addSubview:self.footerView];
        self.footerView.field=field;
        //加载第一页
        [self loadFirst];
    } failure:^(NSError * _Nonnull error) {
        NSLog(@"error:%@", error);
    }];
    MJRefreshNormalHeader *header =[MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(loadFirst)];
    header.lastUpdatedTimeLabel.hidden=YES;
    header.stateLabel.hidden=YES;
    self.scrollView.mj_header=header;
    self.scrollView.mj_footer=[MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMore)];
    _currentPage=1;
}
#pragma mark - 容器
-(UIScrollView *)scrollView{
    if (_scrollView==nil) {
        CGRect frame=CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height-70);//底部评论框h=80
        _scrollView = [[UIScrollView alloc] initWithFrame:frame];
        _scrollView.contentSize = CGSizeMake([UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height);
        _scrollView.backgroundColor = [UIColor whiteColor];
        _scrollView.delegate=self;
    }
    NSLog(@"_scrollView.contentSize:%f", _scrollView.contentSize.height);
    return _scrollView;
}
#pragma mark - 头部
-(ContentHeaderView *)headerView{
    if (_headerView==nil) {
        _headerView=[[ContentHeaderView alloc] init];
        _headerView.frame=CGRectMake(10, 10, CWScreenW-20, 50);
    }
    return _headerView;
}
-(void)createContent:(Joke *)field{
    NSLog(@"field.content:%@", field.content);
    if (![field.content isEqualToString:@""]) {
        //内容文本默认高度20
        UILabel *text=[[UILabel alloc] initWithFrame:CGRectMake(10, CGRectGetMaxY(_headerView.frame)+20, CWScreenW-20, 20)];
        text.text=field.content;
        text.font=[UIFont systemFontOfSize:14];
        text.numberOfLines=0;
        [text sizeToFit];
        [self.scrollView addSubview:text];
        self.contentLabel=text;
    }
    //图集 最小高度100
    self.gridLayout=[[GridLayout alloc] initWithFrame:CGRectMake(10, CGRectGetMaxY(_contentLabel.frame)+10, CWScreenW-20, 100)];
    self.gridLayout.images=[self _buildGridLayoutArgs:field];
    [self.scrollView addSubview:self.gridLayout];
    [self.gridLayout layoutIfNeeded];
    //设置gridLayout高度
    if (self.gridLayout.subviews.count>0) {
        UIImageView *img=self.gridLayout.subviews[self.gridLayout.subviews.count-1];
        self.gridLayout.height=CGRectGetMaxY(img.frame)+10;
        //NSLog(@"height origin=%f", self.gridLayout.height);
    }else self.gridLayout.height=0;
}
#pragma mark - 组合参数（栅格布局
-(NSMutableArray *)_buildGridLayoutArgs:(Joke *)field{
    NSMutableArray *arr=[[NSMutableArray alloc] init];
    if (![field.images isEqualToString:@""]) {
        //图集
        NSArray *images= [field.images componentsSeparatedByString:@","];
        for (int i=0; i<images.count; i++) {
            NSDictionary *dict=[NSDictionary dictionaryWithObjects:@[[NSString stringWithFormat:@"%zd", field.type], images[i], images[i]] forKeys:@[@"type", @"image", @"original"]];
            arr[i]=dict;
        }
    }else if(![field.image isEqualToString:@""]){
        //视频头图
        NSDictionary *dict=[NSDictionary dictionaryWithObjects:@[[NSString stringWithFormat:@"%zd", field.type], field.image, field.video] forKeys:@[@"type", @"image", @"original"]];
        arr[0]=dict;
    }
    return arr;
}
#pragma mark - 评论列表
-(UITableView *)tableView{
    if (_tableView==nil) {
        UILabel *commentTitle=[[UILabel alloc] initWithFrame:CGRectMake(0, 0, CWScreenW-10, 30)];
        commentTitle.text=@"评论列表";
        //NSLog(@"_contentLabel.height:%f", _contentLabel.height);
        //NSLog(@"_headerView.height:%f", _headerView.height);
        //NSLog(@"评论列表_gridLayout.height:%f", _gridLayout.height);
        _tableView=[[UITableView alloc] initWithFrame:CGRectMake(5, CGRectGetMaxY(_gridLayout.frame), CWScreenW-10, 360) style:(UITableViewStylePlain)];
        _tableView.tableHeaderView=commentTitle;
        _tableView.dataSource=self;
        _tableView.delegate=self;
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
    CommentCell *cell=[CommentCell cellWithTableView:tableView];
    Comment *field=self.fields[indexPath.row];
    cell.field=field;
    //取消选择cell颜色
    cell.selectionStyle=UITableViewCellSelectionStyleNone;
    return cell;
}
/**
 设置cell的真实高度
 */
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    Comment *field=self.fields[indexPath.row];
    //NSLog(@"field.cellHeight:%f", field.cellHeight);
    return field.cellHeight;
}
//每行的估计高度：用于性能优化，不设置的话 系统会先拿到所有cell的高度再渲染
//只要设置了 估计高度，就会先调用cellForRowAtIndexPath创建cell，再调用heightForRowAtIndexPath设置当前cell的实际高度
-(CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 100;
}
#pragma mark - 底部评论框
-(ContentFooterView *)footerView{
    if (_footerView==nil) {
        _footerView=[[ContentFooterView alloc] init];
        _footerView.frame=CGRectMake(0, CWScreenH-70, CWScreenW, 70);
        _footerView.backgroundColor=[UIColor colorWithHexString:@"f2f2f7"];
        
        //输入框
        _comment=[[UITextField alloc] initWithFrame:CGRectMake(20, 8, CWScreenW-100, 30)];
        _comment.backgroundColor=[UIColor whiteColor];
        _comment.placeholder = @"发表下你的看法";
        _comment.font=[UIFont systemFontOfSize:14];
        _comment.layer.cornerRadius = 5;
        _comment.borderStyle = UITextBorderStyleRoundedRect;
        _comment.delegate=self;
        [_footerView addSubview:_comment];
    }
    return _footerView;
}

#pragma mark - 避免底部评论框被键盘遮挡（开始输入
- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField{
    CGFloat keyboardHeight=216;
    if (CWISIphoneX) {
        keyboardHeight+=100;
    }else keyboardHeight+=10;
    CGFloat offset = self.view.frame.size.height - (self.footerView.height+self.footerView.y + textField.frame.size.height + keyboardHeight);
    //是否需要调整textField的y值
    if (offset <= 0){
        [UIView animateWithDuration:0.3 animations:^{
            CGRect frame = self.view.frame;
            frame.origin.y = offset;
            self.view.frame = frame;
        }];
    }
    return YES;
}
#pragma mark - 避免底部评论框被键盘遮挡（结束输入
- (BOOL)textFieldShouldEndEditing:(UITextField *)textField{
    [UIView animateWithDuration:0.1 animations:^{
        CGRect frame = self.view.frame;
        frame.origin.y = 0;
        self.view.frame = frame;
    }];
    return YES;
}
#pragma mark - 点击键盘done 隐藏键盘
-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    NSLog(@"value;%@", textField.text);
    if (![textField.text isEqualToString:@""]) {
        // 请求参数
        NSMutableDictionary *params = [NSMutableDictionary dictionary];
        //params[@"type"] = @"api";
        params[@"joke_id"] = [NSString stringWithFormat:@"%zd", self.id];
        //验证是否登录
        TokenModel *userDefaults = [[TokenModel alloc] init];
        NSMutableDictionary *data=[userDefaults getToken:@"user_cookie"];
        NSLog(@"见证奇迹getuserDefaults:%@", data);
        if (nil!=data) {
            params[@"user_id"] = data[@"user_id"];
            params[@"content"] = textField.text;

            CommentModel *obj=[[CommentModel alloc] init];
            [obj create:params successBlock:^(id  _Nonnull responseObject) {
                //NSLog(@"%@", responseObject);
                NSInteger err=[responseObject[@"err"] intValue];
                if (err==0) {
                    NSLog(@"提交成功");
                    textField.text=@"";
                    [self loadFirst];//刷新列表
                }else NSLog(@"提交失败");
            } failure:^(NSError * _Nonnull error) {
                NSLog(@"error:%@", error);
            }];
        }else{
            //提示先登录
            [SVProgressHUD showErrorWithStatus:@"请先登录"];
            [SVProgressHUD dismissWithDelay:1.0f];
        }
        
    }
    [_comment resignFirstResponder];
    return YES;
}
//#pragma mark - 点击空白区域隐藏键盘
-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    NSLog(@"点击空白区域隐藏键盘com in2222");
    [_comment resignFirstResponder];
}
-(void)loadFirst{
    [self loadData:YES];
}
-(void)loadMore{
    [self loadData:NO];
}
#pragma mark - 加载更多数据（仅评论列表
- (void)loadData:(BOOL)first{
    // 请求参数
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    if (first) {
        NSLog(@"loadFirst");
        _currentPage=1;
        [self.fields removeAllObjects];
        params[@"page"]=@1;
        //刷新时重新设置 mj_footer
        MJRefreshAutoNormalFooter *footer=[MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMore)];
        if (first){
            footer.stateLabel.hidden  = YES;
        }else{
            footer.stateLabel.hidden=NO;
        }
        self.scrollView.mj_footer=footer;
    }else{
        NSLog(@"loadMore...");
        params[@"page"]=@(++_currentPage);
    }
    params[@"max"]=@10;
    params[@"joke_id"] = [NSString stringWithFormat:@"%zd", self.id];
    CommentModel *obj=[[CommentModel alloc] init];
    [obj gets:params successBlock:^(id  _Nonnull responseObject) {
        NSMutableArray *more = [Joke mj_objectArrayWithKeyValuesArray:responseObject[@"list"]];
        [self.fields addObjectsFromArray:more];
        NSInteger count=[responseObject[@"count"] integerValue];
        NSLog(@"count: %zd", self.fields.count);
        [self.tableView reloadData];

        //todo 重新计算tableView高度
        CGFloat tableViewY=self.tableView.y;
        CGFloat cellsHeight=self.fields.count*90;//暂定self.cellHeight=100
        self.tableView.height=cellsHeight>self.tableView.height?cellsHeight:self.tableView.height;//如果cells的高度 A大于tableView的默认高度 B，height=A; 否则height=B
        self.scrollView.contentSize=CGSizeMake(CWScreenW, self.tableView.height+tableViewY);//底部评论框h=80
        [self.scrollView.mj_header endRefreshing];//结束刷新
        if (self.fields.count>=count) {
            //全部数据加载完毕
            [self.scrollView.mj_footer endRefreshingWithNoMoreData];
        }else{
            [self.scrollView.mj_footer endRefreshing];
        }
    } failure:^(NSError * _Nonnull error) {
        NSLog(@"error:%@", error);
        [self.scrollView.mj_footer endRefreshing];
    }];
}
@end
