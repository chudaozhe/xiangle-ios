//
//  PersonInfoController.m
//  xiangle
//
//  Created by wei cui on 2020/9/25.
//  Copyright © 2020 wei cui. All rights reserved.
//

#import "PersonInfoController.h"
#import "UserModel.h"
#import "TokenModel.h"
#import "User.h"
#import <MJExtension/MJExtension.h>
#import "BottomDialog.h"
#import "DivisionModel.h"
#import "PersonInfoFieldController.h"
#import "UIColor+Hex.h"
#import <SDWebImage/SDWebImage.h>

@interface PersonInfoController ()<UITableViewDelegate, UITableViewDataSource, UIPickerViewDelegate, UIPickerViewDataSource, PersonInfoFieldControllerDelegate>
/** 备注 */
@property (strong, nonatomic) UIView *containerView;
/** 备注 */
@property (strong, nonatomic) UIImageView *avatarView;
@property (strong, nonatomic) UITableView *tableView;
/** list数组 */
@property (strong, nonatomic) NSMutableArray *fields;
/** 备注 */
@property (strong, nonatomic) NSMutableDictionary *cache;
/** 备注 */
@property (strong, nonatomic) User *field;
/** 备注 */
@property (strong, nonatomic) BottomDialog *bottomDialogView;
/** 备注 */
@property (strong, nonatomic) UIPickerView *genderPickerView;
/** 备注 */
@property (strong, nonatomic) UIPickerView *birthdayPickerView;
/** 省份/城市 */
@property (strong, nonatomic) UIPickerView *divisionPickerView;
/** 备注 */
@property (strong, nonatomic) NSArray *genders;

@property(strong, nonatomic) NSArray *years;
@property(strong, nonatomic) NSArray *months;
@property(strong, nonatomic) NSArray *days;

/** 行政区规划*/
@property(strong, nonatomic) NSArray *divisions;
//二级
@property(strong, nonatomic) NSArray *divisionsChildren;
@end

@implementation PersonInfoController

-(void)initBirthdayData{
    //初始化数据
    _fields = [NSMutableArray array];
    _divisions = [NSMutableArray array];
    _divisionsChildren = [NSMutableArray array];
    NSMutableArray *multYears = [NSMutableArray array];//年
    for(int i=1900; i<2016; i++){
        NSString *year = [NSString stringWithFormat:@"%04d年",i];
        [multYears addObject:year];
    }
    self.years = multYears;

    NSMutableArray *multMonths = [NSMutableArray arrayWithCapacity:12];//月
    for(int i=1; i<=12; i++){
        NSString *month = [NSString stringWithFormat:@"%d月",i];
        [multMonths addObject:month];
    }
    self.months = multMonths;

    NSMutableArray *multDays = [NSMutableArray arrayWithCapacity:31];//日
    for(int i=1; i<=31; i++){
        NSString *day = [NSString stringWithFormat:@"%d日",i];
        [multDays addObject:day];
    }
    self.days = multDays;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title=@"编辑个人资料";
    self.view.backgroundColor=[UIColor whiteColor];
    //验证是否登录
    TokenModel *userDefaults = [[TokenModel alloc] init];
    _cache=[userDefaults getToken:@"user_cookie"];
    NSLog(@"见证奇迹getuserDefaults:%@", _cache);
    
    self.fields=[[NSMutableArray alloc] init];//初始化
    self.genders=@[@"男", @"女"];
    [self initBirthdayData];
    
    [self.view addSubview:self.containerView];
    [self.containerView addSubview:self.avatarView];
    [self.containerView addSubview:self.tableView];
    
    UserModel *model=[[UserModel alloc] init];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"user_id"]=nil!=_cache?_cache[@"user_id"]:@0;
    [model get:params successBlock:^(id  _Nonnull responseObject) {
        self.field = [User mj_objectWithKeyValues:responseObject];
        
        [self initFieldData];
        [self.tableView reloadData];
        //设置头像
        NSURL *url=[NSURL URLWithString:[NSString stringWithFormat:@"https://cw-test.oss-cn-hangzhou.aliyuncs.com/%@?x-oss-process=image/circle,r_80/format,png", self.field.avatar]];
        [self.avatarView sd_setImageWithURL:url placeholderImage:[UIImage imageNamed:@"user"]];
    } failure:^(NSError * _Nonnull error) {
        NSLog(@"error:%@", error);
    }];
    
    //省，市选择
    DivisionModel *model2=[[DivisionModel alloc] init];
    [model2 get:nil successBlock:^(id  _Nonnull responseObject) {
        //NSLog(@"responseObject:%@", responseObject);
        self.divisions=responseObject;
        self.divisionsChildren=self.divisions[0][@"children"];
        //NSLog(@"self.divisions:%@", self.divisions);
        //NSLog(@"self.divisionsChildren:%@", self.divisionsChildren);
    } failure:^(NSError * _Nonnull error) {
        NSLog(@"error:%@", error);
    }];
}
-(void)initFieldData{
    [self.fields removeAllObjects];
    NSString *gender=self.field.gender==1?@"男":(self.field.gender==2?@"女":@"");
    NSString *area=[NSString stringWithFormat:@"%@-%@", self.field.province, self.field.city];
    NSString *defaultBirthday=@"";
    if (![self.field.birthday isEqual:@"1970-01-01"]) defaultBirthday=self.field.birthday;
    NSDictionary *item1=@{@"id":@"0", @"key":@"昵称", @"value":self.field.nickname};
    NSDictionary *item2=@{@"id":@"1", @"key":@"性别", @"value":gender};
    NSDictionary *item3=@{@"id":@"2", @"key":@"生日", @"value":defaultBirthday};
    NSDictionary *item4=@{@"id":@"3", @"key":@"所在地", @"value":area};
    NSDictionary *item5=@{@"id":@"4", @"key":@"个性签名", @"value":self.field.quotes};
    [self.fields addObjectsFromArray:@[item1, item2, item3, item4, item5]];
}
-(BottomDialog *)bottomDialogView:(NSString *) name height:(CGFloat)height{
    [_bottomDialogView removeFromSuperview];
    _bottomDialogView=[[BottomDialog alloc] initWithFrame:CGRectMake(0, 0, 0, height)];
    //左上角
    UIButton *leftView = [UIButton buttonWithType:UIButtonTypeCustom];
    [leftView setTitle:@"取消" forState:UIControlStateNormal];
    [leftView setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    leftView.titleLabel.font=[UIFont systemFontOfSize:14];
    [leftView addTarget:self action:@selector(cancelDialog) forControlEvents:UIControlEventTouchUpInside];
    _bottomDialogView.leftView=leftView;
    //右上角
    UIButton *rightView = [UIButton buttonWithType:UIButtonTypeCustom];
    [rightView setTitle:@"确定" forState:UIControlStateNormal];
    [rightView setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    rightView.titleLabel.font=[UIFont systemFontOfSize:14];
    if ([name isEqual:@"gender"]) {
        [rightView addTarget:self action:@selector(genderConfirmDialog) forControlEvents:UIControlEventTouchUpInside];
    }else if([name isEqual:@"birthday"]){
        [rightView addTarget:self action:@selector(birthdayConfirmDialog) forControlEvents:UIControlEventTouchUpInside];
    }else if([name isEqual:@"division"]){
        [rightView addTarget:self action:@selector(divisionConfirmDialog) forControlEvents:UIControlEventTouchUpInside];
    }
    _bottomDialogView.rightView=rightView;
    return _bottomDialogView;
}
-(void)genderConfirmDialog{
    NSLog(@"genderConfirmDialog");
    NSInteger gender=[self.genderPickerView selectedRowInComponent:0];
    NSLog(@"row: %zd", gender);
    NSString *new=self.genders[gender];
    //更新到tableview
    NSDictionary *item=@{@"id":@"1", @"key":@"性别", @"value":new};
    [self.fields replaceObjectAtIndex:1 withObject:item];
    [self.tableView reloadData];
    
    //http
    UserModel *model=[[UserModel alloc] init];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"gender"]=[NSString stringWithFormat:@"%zd", gender+1];
    params[@"user_id"] = nil!=_cache?_cache[@"user_id"]:@0;
    [model put:params successBlock:^(id  _Nonnull responseObject) {
        NSLog(@"%@", responseObject);
    } failure:^(NSError * _Nonnull error) {
        NSLog(@"error:%@", error);
    }];
    //隐藏
    [_bottomDialogView disMissView];
}
-(void)birthdayConfirmDialog{
    NSLog(@"birthdayConfirmDialog");
    //1.确定是哪个view
    //2.是否改了某个值
    //3.更新到tableview
    NSInteger row=[self.birthdayPickerView selectedRowInComponent:0];
    NSInteger row1=[self.birthdayPickerView selectedRowInComponent:1];
    NSInteger row2=[self.birthdayPickerView selectedRowInComponent:2];
    NSLog(@"year: %zd", row);
    NSLog(@"month: %zd", row1);
    NSLog(@"day: %zd", row2);
    NSString *new=[NSString stringWithFormat:@"%zd-%02zd-%02zd", 1900+row, row1+1, row2+1];
    //更新到tableview
    NSDictionary *item=@{@"id":@"2", @"key":@"生日", @"value":new};
    [self.fields replaceObjectAtIndex:2 withObject:item];
    [self.tableView reloadData];
    
    //http
    UserModel *model=[[UserModel alloc] init];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"birthday"]=new;
    params[@"user_id"] = nil!=_cache?_cache[@"user_id"]:@0;
    [model put:params successBlock:^(id  _Nonnull responseObject) {
        NSLog(@"%@", responseObject);
    } failure:^(NSError * _Nonnull error) {
        NSLog(@"error:%@", error);
    }];
    //隐藏
    [_bottomDialogView disMissView];
}

-(void)divisionConfirmDialog{
    NSLog(@"divisionConfirmDialog");
    NSInteger row=[self.divisionPickerView selectedRowInComponent:0];
    NSInteger row1=[self.divisionPickerView selectedRowInComponent:1];
    NSLog(@"省: %zd", row);
    NSLog(@"市: %zd", row1);
    NSString *new=self.divisions[row][@"name"];
    NSString *new1=@"";
    if (![self.divisionsChildren isEqualToArray:@[]]) new1=self.divisionsChildren[row1][@"name"];
    
    //更新到tableview
    NSString *area=[NSString stringWithFormat:@"%@-%@", new, new1];
    NSDictionary *item=@{@"id":@"3", @"key":@"所在地", @"value":area};
    [self.fields replaceObjectAtIndex:3 withObject:item];
    [self.tableView reloadData];
    
    //http
    UserModel *model=[[UserModel alloc] init];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"province"]=new;
    params[@"city"]=new1;
    params[@"user_id"] = nil!=_cache?_cache[@"user_id"]:@0;
    [model put:params successBlock:^(id  _Nonnull responseObject) {
        NSLog(@"%@", responseObject);
    } failure:^(NSError * _Nonnull error) {
        NSLog(@"error:%@", error);
    }];
    //隐藏
    [_bottomDialogView disMissView];
}

//取消（公用
-(void)cancelDialog{
    NSLog(@"cancel");
    //隐藏
    [_bottomDialogView disMissView];
}
-(UIPickerView *)genderPickerView{
    if (nil==_genderPickerView) {
        _genderPickerView=[[UIPickerView alloc] initWithFrame:CGRectMake(0, 50, CWScreenW, 150)];
        _genderPickerView.delegate=self;
        _genderPickerView.dataSource=self;
    }
    return _genderPickerView;
}
-(UIPickerView *)birthdayPickerView{
    if (nil==_birthdayPickerView) {
        _birthdayPickerView=[[UIPickerView alloc] initWithFrame:CGRectMake(0, 50, CWScreenW, 250)];
        _birthdayPickerView.delegate=self;
        _birthdayPickerView.dataSource=self;
    }
    return _birthdayPickerView;
}
-(UIPickerView *)divisionPickerView{
    if (nil==_divisionPickerView) {
        _divisionPickerView=[[UIPickerView alloc] initWithFrame:CGRectMake(0, 40, CWScreenW, 250)];
        _divisionPickerView.delegate=self;
        _divisionPickerView.dataSource=self;
        //_divisionPickerView.backgroundColor=[UIColor redColor];
    }
    return _divisionPickerView;
}
//选择器列数
-(NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView{
    if (pickerView==self.genderPickerView) {
        return 1;
    }else if (pickerView==self.birthdayPickerView){
        return 3;
    }else if (pickerView==self.divisionPickerView){
        return 2;
    }
    return 1;
}
-(NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component{
    if (pickerView==self.genderPickerView) {
        return self.genders.count;//只有一列
    }else if (pickerView==self.birthdayPickerView){
        switch (component) {
            case 0:
                return self.years.count;
                break;
            case 1:
                return self.months.count;
                break;
            case 2:
                return self.days.count;
                break;
            default:
                return 0;
                break;
        }
    }else if (pickerView==self.divisionPickerView){
        //todo
        switch (component) {
            case 0:
                return self.divisions.count;
                break;
            case 1:
                return self.divisionsChildren.count;
                break;
            default:
                return 0;
                break;
        }
    }
    return 0;
    
}
-(NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component{
    if (pickerView==self.genderPickerView) {
        return self.genders[row];
    }else if (pickerView==self.birthdayPickerView){
        NSString *title;
        switch (component) {
            case 0:
                title=self.years[row];
                break;
            case 1:
                title=self.months[row];
                break;
            case 2:
                title=self.days[row];
                break;
            default:
                break;
        }
        return title;
    }else if (pickerView==self.divisionPickerView){
        //todo
        NSString *title;
        NSString *childrenTitle=@"";
        switch (component) {
            case 0:
                title=self.divisions[row][@"name"];
                break;
            case 1:
                if (![self.divisionsChildren isEqualToArray:@[]]) {
                    childrenTitle=self.divisionsChildren[row][@"name"];
                }
                title=childrenTitle;
                break;
            default:
                break;
        }
        return title;
    }
    return @"";
}
-(void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component{
    if (pickerView==self.genderPickerView) {
        //NSLog(@"选择了：%@", self.genders[row]);//只有一列
    }else if (pickerView==self.birthdayPickerView){
//        switch (component) {
//            case 0:
//                NSLog(@"选择了：%@", self.years[row]);
//                break;
//            case 1:
//                NSLog(@"选择了：%@", self.months[row]);
//                break;
//            case 2:
//                NSLog(@"选择了：%@", self.days[row]);
//                break;
//            default:
//                break;
//        }
    }else if (pickerView==self.divisionPickerView){
        switch (component) {
            case 0:
                //当第一列变化时，重新设置第二列的数据
                self.divisionsChildren=self.divisions[row][@"children"];
                [self.divisionPickerView reloadComponent:1];
                //自动选中第二列的第一行
                [self.divisionPickerView selectRow:0 inComponent:1 animated:YES];
                
//                NSLog(@"选择了：%@", self.divisions[row][@"name"]);
//                if (![self.divisionsChildren isEqualToArray:@[]]) {
//                    NSLog(@"选择了：%@", self.divisionsChildren[0][@"name"]);;
//                }
                break;
            case 1:
//                if (![self.divisionsChildren isEqualToArray:@[]]) {
//                    NSLog(@"选择了：%@", self.divisionsChildren[row][@"name"]);
//                }
                break;
            default:
                break;
        }
    }
}
-(UIView *)containerView{
    if (nil==_containerView) {
        _containerView=[[UIView alloc] initWithFrame:CGRectMake(0, kNavBarAndStatusBarHeight, CWScreenW-20, CWScreenH)];
        //_containerView.backgroundColor=[UIColor whiteColor];
    }
    return _containerView;
}
-(UIImageView *)avatarView{
    if (nil==_avatarView) {
        _avatarView=[[UIImageView alloc] initWithFrame:CGRectMake((self.view.width-80)/2, 50, 80, 80)];
        _avatarView.image=[UIImage imageNamed:@"avatar2"];
    }
    return _avatarView;
}
-(UITableView *)tableView{
    if (nil==_tableView) {
        UIView *line=[[UIView alloc] initWithFrame:CGRectMake(0, kNavBarAndStatusBarHeight+CGRectGetMaxY(_avatarView.frame)+50, CWScreenW, 10)];
        line.backgroundColor=[UIColor colorWithHexString:@"eeeeee"];
        [self.view addSubview:line];
        
        _tableView=[[UITableView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(_avatarView.frame)+50, CWScreenW, 300) style:(UITableViewStylePlain)];
        _tableView.dataSource=self;
        _tableView.delegate=self;
        //_tableView.rowHeight=100;
        //数据如果为空，不展示分割线；有数据才展示分割线
        _tableView.tableFooterView=[[UIView alloc] init];
        _tableView.rowHeight = 60;
        _tableView.bounces=NO;//禁止弹簧效果
    }
    return _tableView;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    //NSLog(@"count:%zd", self.fields.count);
    return self.fields.count;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell=[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:nil];
    NSDictionary *field=self.fields[indexPath.row];
    //NSLog(@"field:%@", field);
    cell.textLabel.text=field[@"key"];
    cell.textLabel.font=[UIFont systemFontOfSize:14];
    cell.detailTextLabel.text=field[@"value"];
    cell.detailTextLabel.font=[UIFont systemFontOfSize:14];
    cell.accessoryType=UITableViewCellAccessoryDisclosureIndicator;
    //取消选择cell颜色
    cell.selectionStyle=UITableViewCellSelectionStyleNone;
    return cell;
}
//点击某个cell时调用
- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row==0) {
        //设置昵称
        PersonInfoFieldController *vc=[[PersonInfoFieldController alloc] init];
        vc.nickname=self.field.nickname;
        vc.code=1;
        vc.delegate=self;
        [self.navigationController pushViewController:vc animated:YES];
    }else if (indexPath.row==1) {
        [[self bottomDialogView:@"gender" height:200] showInView:self.view];
        //清除现有的
        [self.birthdayPickerView removeFromSuperview];
        [self.divisionPickerView removeFromSuperview];
        [_bottomDialogView.contentView addSubview:self.genderPickerView];
        //默认选择 未知
        [self.genderPickerView selectRow:0 inComponent:0 animated:YES];
        if (self.field.gender>0) {
            [self.genderPickerView selectRow:self.field.gender-1 inComponent:0 animated:YES];
        }
    }else if (indexPath.row==2){
        [[self bottomDialogView:@"birthday" height:300] showInView:self.view];
        //清除现有的
        [self.genderPickerView removeFromSuperview];
        [self.divisionPickerView removeFromSuperview];
        [_bottomDialogView.contentView addSubview:self.birthdayPickerView];
        //默认选择1995
        [self.birthdayPickerView selectRow:95 inComponent:0 animated:YES];
        if (![self.field.birthday isEqual:@"1970-01-01"]) {
            NSArray *birthday=[self.field.birthday componentsSeparatedByString:@"-"];
            int year=[birthday[0] intValue];
            int month=[birthday[1] intValue];
            int day=[birthday[2] intValue];
            [self.birthdayPickerView selectRow:year-1900 inComponent:0 animated:YES];
            [self.birthdayPickerView selectRow:month-1 inComponent:1 animated:YES];
            [self.birthdayPickerView selectRow:day-1 inComponent:2 animated:YES];
        }
        
    }else if (indexPath.row==3){
        [[self bottomDialogView:@"division" height:300] showInView:self.view];
        //清除现有的
        [self.genderPickerView removeFromSuperview];
        [self.birthdayPickerView removeFromSuperview];
        [_bottomDialogView.contentView addSubview:self.divisionPickerView];
        //设置省，默认值
        for (int i=0; i<self.divisions.count; i++) {
            if (![self.field.province isEqual:@""] && [self.field.province isEqualToString:self.divisions[i][@"name"]]){
                [self.divisionPickerView selectRow:i inComponent:0 animated:YES];
                NSLog(@"i:%i", i);
                //市，重新设置一下第二列的数据
                self.divisionsChildren=self.divisions[i][@"children"];
                [self.divisionPickerView reloadComponent:1];
                
                for (int j=0; j<self.divisionsChildren.count; j++) {
                    if (![self.field.city isEqual:@""] && [self.field.city isEqualToString:self.divisionsChildren[j][@"name"]]){
                        NSLog(@"j:%i", j);
                        [self.divisionPickerView selectRow:j inComponent:1 animated:YES];
                    }
                }
            }
        }
        
    }else if(indexPath.row==4){
        //设置个性签名
        PersonInfoFieldController *vc=[[PersonInfoFieldController alloc] init];
        vc.quotes=self.field.quotes;
        vc.code=2;
        vc.delegate=self;
        [self.navigationController pushViewController:vc animated:YES];
    }

    //NSLog(@"点击了id：%zd", field.id);
}
-(void)onControllerResult:(NSString *)value code:(NSInteger)code{
    NSLog(@"来了。。code:%zd value:%@", code, value);
    //code: 1nickname 2quotes
    if (code==1) {
        self.field.nickname=value;
    }else{
        self.field.quotes=value;
    }
    [self initFieldData];
    [self.tableView reloadData];
}

@end
