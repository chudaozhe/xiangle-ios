//
//  SettingController.m
//  xiangle
//
//  Created by wei cui on 2020/2/29.
//  Copyright © 2020 wei cui. All rights reserved.
//

#import "SettingController.h"
#import "WebViewController.h"
#import "TokenModel.h"

@interface SettingController ()<UITableViewDataSource, UITableViewDelegate>
/** 备注 */
@property (strong, nonatomic) UITableView *tableView;
/** 备注 */
@property (strong, nonatomic) NSArray *fields;

@end

@implementation SettingController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title=@"设置";
    _fields=@[@[@"用户协议", @"隐私政策"]];//@"清理缓存", @"社区公约"
    //验证是否登录
    TokenModel *userDefaults = [[TokenModel alloc] init];
    NSMutableDictionary *data=[userDefaults getToken:@"user_cookie"];
    NSString *user_id = nil!=data?data[@"user_id"]:@0;
    if ([user_id integerValue] >0) {
        _fields=@[@[@"用户协议", @"隐私政策"], @[@"退出"]];
    }
    self.tableView=[[UITableView alloc] initWithFrame:self.view.frame style:UITableViewStyleGrouped];
    self.tableView.dataSource=self;
    self.tableView.delegate=self;
    self.tableView.rowHeight=60;
    UILabel *copyright=[[UILabel alloc] initWithFrame:CGRectMake(0, 0, CWScreenW, 100)];
    NSDictionary *version=[[NSBundle mainBundle] infoDictionary];
    copyright.text= [NSString stringWithFormat:@"当前版本%@(%@)\nAll Rights Reserved By xiangle", [version objectForKey:@"CFBundleShortVersionString"], [version objectForKey:@"CFBundleVersion"]];
    copyright.textAlignment=NSTextAlignmentCenter;
    copyright.numberOfLines = 0;
    copyright.font=[UIFont systemFontOfSize:12];
    self.tableView.tableFooterView=copyright;
    [self.view addSubview:self.tableView];
    
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return self.fields.count;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.fields[section] count];
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell=[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:nil];
    cell.textLabel.text=self.fields[indexPath.section][indexPath.row];//[NSString stringWithFormat:@"%zd", indexPath.row];
    cell.textLabel.font=[UIFont systemFontOfSize:15];
    //右侧指示器
    cell.accessoryType=UITableViewCellAccessoryDisclosureIndicator;
    //取消选择cell颜色
    cell.selectionStyle=UITableViewCellSelectionStyleNone;
    return cell;
}
//点击某个cell时调用
- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    NSLog(@"section:%zd row:%zd", indexPath.section, indexPath.row);
    if (indexPath.section==0 && indexPath.row==0){
        WebViewController *vc=[[WebViewController alloc] init];
        vc.url=@"https://www.cuiwei.net/agreement.html";
        vc.title=@"用户协议";
        [self.navigationController pushViewController:vc animated:YES];
    }else if(indexPath.section==0 && indexPath.row==1){
        WebViewController *vc=[[WebViewController alloc] init];
        vc.url=@"https://www.cuiwei.net/private.html";
        vc.title=@"隐私政策";
        [self.navigationController pushViewController:vc animated:YES];
    }else if (indexPath.section==1 && indexPath.row==0) {
        //退出
        NSUserDefaults *userDefaults=[NSUserDefaults standardUserDefaults];
        [userDefaults removeObjectForKey:@"user_cookie"];
        //[self.view resignFirstResponder];
        [self.navigationController popViewControllerAnimated:YES];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"RefreshMyControllerNotify" object:nil];
    }
}
@end
