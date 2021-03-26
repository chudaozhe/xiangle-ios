//
//  LoginController.m
//  xiangle
//
//  Created by wei cui on 2020/2/26.
//  Copyright © 2020 wei cui. All rights reserved.
//

#import "LoginController.h"
#import "UIColor+Hex.h"
#import "RegisterController.h"
#import "UserModel.h"
#import "User.h"
#import <MJExtension/MJExtension.h>
#import "MyController.h"
#import "TokenModel.h"
#import "WebViewController.h"
#import "UIButton+CountDown.h"
#import <SVProgressHUD/SVProgressHUD.h>

@interface LoginController ()<UITextViewDelegate,UITextFieldDelegate,UINavigationControllerDelegate>
@property (strong, nonatomic) UIView *containerView;
/** 关闭按钮 */
@property (strong, nonatomic) UIButton *closeView;
/** 备注 */
@property (strong, nonatomic) UITextField *mobileText;
/** 备注 */
@property (strong, nonatomic) UITextField *passwdText;
/** 备注 */
@property (strong, nonatomic) UIButton *loginBtn;
/** 登录切换方式 按钮 */
@property (strong, nonatomic) UIButton *toggleView;
/** 计时器按钮 */
@property (strong, nonatomic) UIButton *countDownButton;
/** 备注 */
@property (assign, nonatomic) BOOL isCaptcha;//当前登录方式，默认验证码;
@end

@implementation LoginController

// 隐藏NavigationBar
- (void)navigationController:(UINavigationController *)navigationController willShowViewController:(UIViewController *)viewController animated:(BOOL)animated{
    // 判断要显示的控制器是否是自己
    BOOL isShowHomePage = [viewController isKindOfClass:[self class]];
    
    [self.navigationController setNavigationBarHidden:isShowHomePage animated:YES];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationController.delegate=self;
    self.isCaptcha=true;
    
    self.view.backgroundColor=[UIColor whiteColor];
    self.title=@"登录";
    //1创建scrollView，并添加到View
    [self.view addSubview:self.containerView];
    
    //关闭页面 按钮
    [self.view addSubview:self.closeView];
    
    //tip2
    UILabel *tip2=[self createLabel:@"手机号登录" labelY:0];
    tip2.font=[UIFont systemFontOfSize:24];
    
    //tip3
    UILabel *tip3=[self createLabel:@"未注册的手机号登录后将自动注册" labelY:CGRectGetMaxY(tip2.frame)];

    self.mobileText=[self createInput:@"请输入手机号" textFieldY:CGRectGetMaxY(tip3.frame)+10 isPwd:0];
    self.passwdText= [self createInput:@"请输入验证码" textFieldY:CGRectGetMaxY(self.mobileText.frame)+10 isPwd:1];
    
    //计时器按钮
    [self.containerView addSubview:self.countDownButton];

    //切换登录方式
    [_containerView addSubview:self.toggleView];
    
    //登录按钮
    _loginBtn=[self createBtn:self.mobileText];
    
    //同意协议 提示
    [self createTips:_loginBtn];
    
    _loginBtn.enabled=_mobileText.text.length && _passwdText.text.length;
    if (!_loginBtn.enabled) _loginBtn.backgroundColor = [[UIColor orangeColor] colorWithAlphaComponent:0.4];
}
//文本框内容改变时调用
-(void)textChange{
    _loginBtn.enabled=_mobileText.text.length && _passwdText.text.length;
    if (_loginBtn.enabled){
        _loginBtn.backgroundColor = [UIColor orangeColor];
    }else _loginBtn.backgroundColor = [[UIColor orangeColor] colorWithAlphaComponent:0.4];
    //NSLog(@"textChange: mobile=%@, pwd=%@", _mobileText.text, _passwdText.text);
}
-(void)startCountDown:(UIButton *)btn{
    //NSLog(@"btn:%@", btn);
    if ([self validatePhoneNumber:self.mobileText.text]) {
        [self.countDownButton startCountDownTime:10 withCountDownBlock:^{
            UserModel *obj=[[UserModel alloc] init];
            NSMutableDictionary *params = [NSMutableDictionary dictionary];
            params[@"mobile"] = self.mobileText.text;
            [obj sendCaptcha:params successBlock:^(id  _Nonnull responseObject) {
                if ([responseObject[@"err"] isEqual:@0]) {
                    [SVProgressHUD showErrorWithStatus:@"发送成功!"];
                }else{
                    [SVProgressHUD showErrorWithStatus:@"发送失败"];
                }
                [SVProgressHUD dismissWithDelay:2.0f];
            } failure:^(NSError * _Nonnull error) {
                NSLog(@"error:%@", error);
            }];
            //NSLog(@"开始倒计时");
        }];
    }else{
        [SVProgressHUD showErrorWithStatus:@"请输入正确的手机号！"];
        [SVProgressHUD dismissWithDelay:2.0f];
    }
}
- (BOOL)validatePhoneNumber:(NSString *)mobile{
    if ([mobile isEqual:@""]) return false;
    NSString *telRegex = @"^((13[0-9])|(15[^4])|(18[0-9])|(17[0-8])|(147,145))\\d{8}$";
    //NSPredicate *phoneTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", telRegex];
    return [[NSPredicate predicateWithFormat:@"SELF MATCHES %@", telRegex] evaluateWithObject:mobile];
}
/**
 关闭当前页面
 */
-(void) doClose{
//    [self dismissViewControllerAnimated:YES completion:nil];
    [self.navigationController popViewControllerAnimated:YES];
}
-(void) doToggle{
    if(self.isCaptcha){
        //切换的密码登录
        self.isCaptcha=false;
        [self.toggleView setTitle:@"验证码登录" forState:UIControlStateNormal];
        self.passwdText.text=@"";
        self.passwdText.placeholder=@"请输入密码";
        self.passwdText.secureTextEntry=YES;
        [self.countDownButton setHidden:YES];
    }else{
        //切换到验证码登录
        self.isCaptcha=true;
        [self.toggleView setTitle:@"密码登录" forState:UIControlStateNormal];
        self.passwdText.text=@"";
        self.passwdText.placeholder=@"请输入验证码";
        self.passwdText.secureTextEntry=NO;
        [self.countDownButton setHidden:NO];
    }
}
#pragma mark 计时器按钮
-(UIButton *)countDownButton{
    if (_countDownButton==nil) {
        _countDownButton=[[UIButton alloc] initWithFrame:CGRectMake(CWScreenW*0.8-120, CGRectGetMaxY(self.passwdText.frame)-55, 120, 50)];//CWScreenW*0.8-120, -5
        //[_countDownButton setBackgroundColor:[UIColor greenColor]];
        [_countDownButton setTitle:@"获取验证码" forState:UIControlStateNormal];
        [_countDownButton setContentHorizontalAlignment:UIControlContentHorizontalAlignmentRight];//文字居右
        [_countDownButton setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
        _countDownButton.titleLabel.font = [UIFont systemFontOfSize: 14.0 weight:UIFontWeightLight];
        [_countDownButton addTarget:self action:@selector(startCountDown:) forControlEvents:UIControlEventTouchUpInside];

        UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(0, _countDownButton.height+5 - 1, 120, 1)];
        lineView.backgroundColor = [UIColor orangeColor];
        [_countDownButton addSubview:lineView];
    }
    return _countDownButton;
}
#pragma mark 关闭页面 按钮
-(UIButton *)closeView{
    if (_closeView==nil) {
        _closeView=[UIButton buttonWithType:UIButtonTypeCustom];
        _closeView.frame=CGRectMake(10, kStatusBarHeight+20, 30, 20);
        [_closeView setImage:[UIImage imageNamed:@"cuowu2"] forState:UIControlStateNormal];
        [_closeView setImage:[UIImage imageNamed:@"cuowu"] forState:UIControlStateHighlighted];
        [_closeView addTarget:self action:@selector(doClose) forControlEvents:UIControlEventTouchUpInside];
    }
    return _closeView;
}
#pragma mark 切换登录方式
-(UIButton *)toggleView{
    if (_toggleView==nil) {
        _toggleView=[[UIButton alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(self.passwdText.frame)+10, 100, 30)];
        [_toggleView setTitle:@"密码登录" forState:UIControlStateNormal];
        [_toggleView setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [_toggleView setTitleColor:[UIColor grayColor] forState:UIControlStateHighlighted];
        [_toggleView setContentHorizontalAlignment:UIControlContentHorizontalAlignmentLeft];//文字居左
        _toggleView.titleLabel.font = [UIFont systemFontOfSize: 14.0 weight:UIFontWeightLight];
        [_toggleView addTarget:self action:@selector(doToggle) forControlEvents:UIControlEventTouchUpInside];
    }
    return _toggleView;
}
#pragma mark - 容器
-(UIView *)containerView{
    if (_containerView==nil) {
        CGRect frame=CGRectMake(CWScreenW*0.1, kStatusBarHeight+100, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height);
        _containerView = [[UIView alloc] initWithFrame:frame];
        _containerView.backgroundColor = [UIColor whiteColor];
    }
    return _containerView;
}
-(UILabel *)createLabel:(NSString *)text labelY:(CGFloat) y{
    UILabel *tip=[[UILabel alloc] initWithFrame:CGRectMake(0, y, CWScreenW-10, 30)];
    tip.text=text;
    tip.font=[UIFont systemFontOfSize:14 weight:UIFontWeightLight];//文字粗细
    [self.containerView addSubview:tip];
    return tip;
}
/**
 创建UITextField
 */
-(UITextField *)createInput:(NSString *)placeholder textFieldY:(CGFloat)textFieldY isPwd:(NSInteger)isPwd{
    UITextField *field=[[UITextField alloc] initWithFrame:CGRectMake(0, textFieldY, CWScreenW*0.8, 50)];
    field.placeholder=placeholder;
    if (isPwd) {
        field.width=CWScreenW*0.8-120;
        //field.secureTextEntry=YES;
    }
    //field.borderStyle=UITextBorderStyleRoundedRect;
    [field addTarget:self action:@selector(textChange) forControlEvents:UIControlEventEditingChanged];
    [self.containerView addSubview:field];
    //field.backgroundColor=[UIColor darkGrayColor];
    
    UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(0,field.height - 1, CWScreenW*0.8, 1)];
    lineView.backgroundColor = [UIColor orangeColor];
    [field addSubview:lineView];
    return field;
}
/**
 登录按钮
 */
-(UIButton *)createBtn:(UITextField *)textField{
    UIButton *btn=[[UIButton alloc] initWithFrame:textField.frame];
    btn.y=CGRectGetMaxY(textField.frame)+120;
    btn.backgroundColor = [UIColor orangeColor];
    //设置圆角的大小
    btn.layer.cornerRadius = 4;
    [btn setTitle:@"登录" forState:UIControlStateNormal];
    //默认红底白字
    //按下时绿底黑字
    [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];//默认白色
    [btn addTarget:self action:@selector(doLogin:) forControlEvents:UIControlEventTouchUpInside];//抬起时 红色
    [btn addTarget:self action:@selector(btnTouchDown:) forControlEvents:UIControlEventTouchDown];//按下时 灰色
    [btn addTarget:self action:@selector(btnDragExit:) forControlEvents:UIControlEventTouchDragExit];//拖拽时 红色
    [self.containerView addSubview:btn];
    return btn;
}
-(void) doLogin:(UIButton *)btn {
    btn.backgroundColor = [UIColor orangeColor];
    // 请求参数
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"mobile"] = self.mobileText.text;
    if ([self validatePhoneNumber:self.mobileText.text]) {
        if (_isCaptcha) {
            params[@"captcha"] = self.passwdText.text;
            params[@"type"] = @1;
            //[params removeObjectForKey:@"password"];
        }else{
            params[@"password"] = self.passwdText.text;
            params[@"type"] = @0;
        }
        //NSLog(@"收到params=%@", params);
        UserModel *obj=[[UserModel alloc] init];
        [obj mobileLogin:params successBlock:^(id  _Nonnull responseObject) {
            if ([responseObject[@"err"] isEqual:@0]) {
                User *user = [User mj_objectWithKeyValues:responseObject[@"data"]];
                //NSLog(@"user:%@", user);
                [[NSNotificationCenter defaultCenter] postNotificationName:@"RefreshMyControllerNotify" object:nil];
                
                NSMutableDictionary *user_cookie = [NSMutableDictionary dictionary];
                user_cookie[@"user_id"] = [NSString stringWithFormat:@"%zd", user.id];
                user_cookie[@"token"] = user.token;
                TokenModel *userDefaults = [[TokenModel alloc] init];
                [userDefaults createToken:@"user_cookie" value:user_cookie];
                //返回我的
                //[self.view resignFirstResponder];//隐藏键盘
                [self.navigationController popViewControllerAnimated:YES];
            }else{
                if (self.isCaptcha) {
                    [SVProgressHUD showErrorWithStatus:@"验证码错误，请重试!"];
                }else{
                    [SVProgressHUD showErrorWithStatus:@"手机号/密码错误！"];
                }
                [SVProgressHUD dismissWithDelay:2.0f];
            }
        } failure:^(NSError * _Nonnull error) {
            NSLog(@"error:%@", error);
        }];
    }else{
        [SVProgressHUD showErrorWithStatus:@"请输入正确的手机号！"];
        [SVProgressHUD dismissWithDelay:2.0f];
    }
}
-(void) btnTouchDown:(UIButton *)btn {
    btn.backgroundColor = [[UIColor orangeColor] colorWithAlphaComponent:0.4];
}
-(void)btnDragExit:(UIButton *)btn{
    btn.backgroundColor = [UIColor orangeColor];
}
/**
 添加用户协议提示
 https://blog.csdn.net/Morris_/article/details/102605666
 */
-(void)createTips:(UIButton *)btn{
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:@"登录/注册表示您已同意《用户协议》"];
        //设置行间距以及字体大小、颜色
        NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
        paragraphStyle.lineSpacing = 4;// 字体的行间距
        NSDictionary *attributes = @{NSFontAttributeName:[UIFont systemFontOfSize:12.0],
                                     NSForegroundColorAttributeName:[UIColor colorWithHexString:@"9b9c9d"],
                                     NSParagraphStyleAttributeName:paragraphStyle};
        [attributedString setAttributes:attributes range:NSMakeRange(0, attributedString.length)];
        
        [attributedString addAttribute:NSLinkAttributeName
                                 value:@"https://www.cuiwei.net/agreement.html"
                                 range:[[attributedString string] rangeOfString:@"《用户协议》"]];
        NSDictionary *linkAttributes = @{NSForegroundColorAttributeName:[UIColor colorWithHexString:@"113566"]};
        
        UITextView *textView = [[UITextView alloc] initWithFrame:btn.frame];
        textView.y=CGRectGetMaxY(btn.frame)+10;
        textView.backgroundColor = [UIColor clearColor];
        textView.linkTextAttributes = linkAttributes;
        textView.attributedText = attributedString;
        textView.scrollEnabled = NO;
        textView.font = [UIFont systemFontOfSize:12.0];
        textView.textAlignment = NSTextAlignmentCenter;
        textView.editable = NO;
        textView.delegate = self;
        [self.containerView addSubview:textView];
}
#pragma mark -
-(BOOL)textView:(UITextView *)textView shouldInteractWithURL:(NSURL *)URL inRange:(NSRange)characterRange{
    //非http开头，忽略
    if (![URL.absoluteString hasPrefix:@"https"]) return YES;
    NSLog(@"点击的url:%@", URL);
    //NSLog(@"characterRange:%@", NSStringFromRange(characterRange));
    WebViewController *vc=[[WebViewController alloc] init];
    vc.url=URL.absoluteString;
    vc.title=@"用户协议";
    [self.navigationController pushViewController:vc animated:YES];
    return NO;
}
@end
