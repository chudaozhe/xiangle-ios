//
//  PersonInfoFieldController.m
//  xiangle 设置个人资料的某个字段
//
//  Created by wei cui on 2020/9/25.
//  Copyright © 2020 wei cui. All rights reserved.
//

#import "PersonInfoFieldController.h"
#import "UserModel.h"
#import "TokenModel.h"

@interface PersonInfoFieldController ()
/** 基础textField */
@property (strong, nonatomic) UITextField *textFieldView;

@property (strong, nonatomic) UITextField *nicknameView;
@property (strong, nonatomic) UITextField *quotesView;
//
/** 备注 */
@property (strong, nonatomic) NSMutableDictionary *cache;
@end

@implementation PersonInfoFieldController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor=CWGlobalBgColor;
    self.navigationItem.rightBarButtonItem=[[UIBarButtonItem alloc] initWithTitle:@"完成" style:UIBarButtonItemStyleDone target:self action:@selector(doPush)];
    self.navigationItem.rightBarButtonItem.tintColor=[UIColor orangeColor];
    
    //验证是否登录
    TokenModel *userDefaults = [[TokenModel alloc] init];
    _cache=[userDefaults getToken:@"user_cookie"];
    NSLog(@"见证奇迹getuserDefaults:%@", _cache);
    //区分控件
    if (self.code==1) {
        NSLog(@"nickname...");
        self.title=@"设置昵称";
        self.nicknameView=self.textFieldView;
        [self.view addSubview:self.nicknameView];
        //当前值
        self.nicknameView.text=self.nickname;
        if ([self.nicknameView.text isEqual:self.nickname]) self.navigationItem.rightBarButtonItem.enabled=NO;
    }else{
        NSLog(@"quotes...");
        self.title=@"设置个性签名";
        self.quotesView=self.textFieldView;
        [self.view addSubview:self.quotesView];
        //当前值
        self.quotesView.text=self.quotes;
        if ([self.quotesView.text isEqual:self.quotes]) self.navigationItem.rightBarButtonItem.enabled=NO;
        self.quotesView.placeholder=@"请输入个性签名, 20个字符以内";
    }
    
    [self.textFieldView addTarget:self action:@selector(textFieldChanged:) forControlEvents:UIControlEventEditingChanged];
    //获取焦点
    [self.textFieldView becomeFirstResponder];
    
    if ([self.textFieldView.text isEqualToString:@""]) self.navigationItem.rightBarButtonItem.enabled=NO;
}
-(void)textFieldChanged:(UITextField *)textField{
    NSLog(@"change..");
    self.navigationItem.rightBarButtonItem.enabled=YES;
    if ([self.textFieldView.text isEqualToString:@""]) self.navigationItem.rightBarButtonItem.enabled=NO;
    //区分控件
    if (self.code==1) {
        if(self.nicknameView.text.length>12 || [self.nicknameView.text isEqual:self.nickname]) self.navigationItem.rightBarButtonItem.enabled=NO;
    }else{
        if(self.quotesView.text.length>20 || [self.quotesView.text isEqual:self.quotes]) self.navigationItem.rightBarButtonItem.enabled=NO;
    }
}
-(void)doPush{
    UserModel *model=[[UserModel alloc] init];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    //区分控件
    if(self.code==1) params[@"nickname"]=self.nicknameView.text;
    if(self.code==2) params[@"quotes"]=self.quotesView.text;
    params[@"user_id"] = nil!=_cache?_cache[@"user_id"]:@0;
    [model put:params successBlock:^(id  _Nonnull responseObject) {
        NSLog(@"%@", responseObject);
    } failure:^(NSError * _Nonnull error) {
        NSLog(@"error:%@", error);
    }];
    //2代理通知list控制器刷新表格，或block
    if ([_delegate respondsToSelector:@selector(onControllerResult:code:)]) {
        //区分控件
        if(self.code==1){
            [_delegate onControllerResult:_nicknameView.text code:1];
        }else{
            [_delegate onControllerResult:_quotesView.text code:2];
        }
    }
    //[self.view resignFirstResponder];//隐藏键盘
    [self.navigationController popViewControllerAnimated:YES];
}

-(UITextField *)textFieldView{
    if (nil==_textFieldView) {
        _textFieldView=[[UITextField alloc] initWithFrame:CGRectMake(10, kNavBarAndStatusBarHeight+10, CWScreenW-20, 40)];
        _textFieldView.backgroundColor = [UIColor whiteColor];
        _textFieldView.placeholder=@"请输入昵称, 12个字符以内";
        _textFieldView.leftView=[[UIView alloc] init];
        
        //清空输入图标
        _textFieldView.clearButtonMode = UITextFieldViewModeWhileEditing;
        //边框
        _textFieldView.borderStyle = UITextBorderStyleRoundedRect;
        //内边距
        [_textFieldView setValue:[NSNumber numberWithInt:0] forKey:@"paddingLeft"];//光标距离左边的位置
        //文字垂直居中
        _textFieldView.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
        _textFieldView.font=[UIFont systemFontOfSize:12];
    }
    return _textFieldView;
}

@end
