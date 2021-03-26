//
//  SearchController.m
//  xiangle
//
//  Created by wei cui on 2020/3/10.
//  Copyright © 2020 wei cui. All rights reserved.
//

#import "SearchController.h"
#import "ContentController.h"
#import <MJExtension/MJExtension.h>
#import "JokeModel.h"
#import "Favorite.h"
#import "FavoriteCell.h"

@interface SearchController ()<UITextFieldDelegate, UITableViewDelegate, UITableViewDataSource>
/** 备注 */
@property (strong, nonatomic) UITableView *tableView;
/** 备注 */
@property (strong, nonatomic) UITextField *searchView;
/** list数组 */
@property (strong, nonatomic) NSArray *fields;
@end

@implementation SearchController
- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor=CWGlobalBgColor;
    self.title=@"搜索";
    [self.view addSubview:self.searchView];
    //获取焦点
    [self.searchView becomeFirstResponder];
    
}

-(UITableView *)tableView{
    if (nil==_tableView) {
        _tableView=[[UITableView alloc] initWithFrame:CGRectMake(0, kNavBarAndStatusBarHeight+self.searchView.height+20, CWScreenW, 800) style:(UITableViewStylePlain)];
        _tableView.dataSource=self;
        _tableView.delegate=self;
        //_tableView.rowHeight=100;
        //数据如果为空，不展示分割线；有数据才展示分割线
        _tableView.tableFooterView=[[UIView alloc] init];
        _tableView.sectionHeaderHeight = 0.01;//只要直接随便设置下面两个属性值后, -(CGFloat)tableView: heightForHeaderInSection:才生效
    }
    return _tableView;
}
-(UITextField *)searchView{
    if (nil==_searchView) {
        _searchView=[[UITextField alloc] initWithFrame:CGRectMake(10, kNavBarAndStatusBarHeight+10, CWScreenW-20, 40)];
        _searchView.backgroundColor = [UIColor whiteColor];
        _searchView.placeholder=@"请输入关键字";
        UIImageView *searchIcon=[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"search"]];
        //虽然LeftView坐标不能改,但是LeftView的子控件坐标可以随意改动
        //首先设置LeftView是一个UIView,UIView里添加一UIImageView,UIImageView在UIView里的位置还不随你动?
        UIView *searchIconView=[[UIView alloc] initWithFrame:CGRectMake(0, 0, 28, 32)];
        [searchIconView addSubview:searchIcon];
        _searchView.leftView=searchIconView;
        searchIcon.frame=CGRectMake(2, 2, 32, 32);
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
/**
 键盘return变搜索
 */
-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    NSLog(@"搜索key:%@", self.searchView.text);
    self.tableView=nil;
    // 请求参数
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"topic_id"] = @0;
    params[@"user_id"] = @0;
    params[@"keyword"] = self.searchView.text;
    JokeModel *obj=[[JokeModel alloc] init];
    [obj gets:params successBlock:^(id  _Nonnull responseObject) {
        //NSLog(@"result: %@", responseObject);

        [self.view addSubview:self.tableView];
        self.fields = [Favorite mj_objectArrayWithKeyValuesArray:responseObject[@"list"]];
        [self.tableView reloadData];
    } failure:^(NSError * _Nonnull error) {
        NSLog(@"error:%@", error);
    }];
    
    [self.searchView resignFirstResponder];
    return YES;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.fields.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    //cellWithTableView
//    FavoriteCell *cell=[[FavoriteCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:nil];
    FavoriteCell *cell=[FavoriteCell cellWithTableView:tableView];
    Favorite *field=self.fields[indexPath.row];
    cell.field=field;
    //取消选择cell颜色
    cell.selectionStyle=UITableViewCellSelectionStyleNone;
    return cell;
}
//点击某个cell时调用
- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    ContentController *vc=[[ContentController alloc] init];
    Favorite *field=self.fields[indexPath.row];
    vc.id=field.id;//此id非彼id，但可用
    [self.navigationController pushViewController:vc animated:YES];
}
/**
 设置cell的真实高度
 */
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    Favorite *field=self.fields[indexPath.row];

    NSLog(@"article_id:%zd", field.id);
    NSLog(@"field.cellHeight:%f", field.cellHeight);
    return field.cellHeight;
}
@end
