//
//  RegisterController.m
//  xiangle
//
//  Created by wei cui on 2020/2/27.
//  Copyright © 2020 wei cui. All rights reserved.
//

#import "RegisterController.h"
#import "UIColor+Hex.h"
#import "UserModel.h"
#import "User.h"
#import <MJExtension/MJExtension.h>
#import "HomeController.h"
#import "TokenModel.h"
#import "WebViewController.h"

@interface RegisterController ()<UITextViewDelegate>
/** 备注 */
@property (strong, nonatomic) UITextField *usernameText;
/** 备注 */
@property (strong, nonatomic) UITextField *passwdText;
/** 备注 */
@property (strong, nonatomic) UITextField *passwd2Text;

@end

@implementation RegisterController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor=[UIColor whiteColor];
    self.title=@"注册";
    
    self.usernameText=[self createInput:@"请输入用户名" textField:nil isPwd:0];
    self.passwdText= [self createInput:@"请输入密码" textField:self.usernameText isPwd:1];
    self.passwd2Text= [self createInput:@"请再次确认您的密码" textField:self.passwdText isPwd:1];
    
    UIButton *btn=[self createBtn:self.passwd2Text];
    [self createTips:btn];
}

/**
 创建UITextField
 */
-(UITextField *)createInput:(NSString *)placeholder textField:(UITextField * _Nullable)textField isPwd:(NSInteger)isPwd{
    CGFloat yy=100;
    if (textField!=nil) yy=CGRectGetMaxY(textField.frame)+20;
    UITextField *field=[[UITextField alloc] initWithFrame:CGRectMake(CWScreenW*0.1, yy, CWScreenW*0.8, 50)];
    field.placeholder=placeholder;
    if (isPwd) field.secureTextEntry=YES;
    //field.borderStyle=UITextBorderStyleRoundedRect;
    [self.view addSubview:field];
    
    UIView *lineView = [[UIView alloc]initWithFrame:CGRectMake(0,field.height - 1, field.width, 1)];
    lineView.backgroundColor = [UIColor orangeColor];
    [field addSubview:lineView];
    return field;
}
/**
 登录按钮
 */
-(UIButton *)createBtn:(UITextField *)textField{
    UIButton *btn=[[UIButton alloc] initWithFrame:textField.frame];
    btn.y=CGRectGetMaxY(textField.frame)+60;
    btn.backgroundColor = [UIColor orangeColor];
    //设置圆角的大小
    btn.layer.cornerRadius = 4;
    [btn setTitle:@"注册" forState:UIControlStateNormal];
    //默认红底白字
    //按下时绿底黑字
    [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];//默认白色
    
    [btn addTarget:self action:@selector(btnTouchUpInside:) forControlEvents:UIControlEventTouchUpInside];//抬起时 红色
    [btn addTarget:self action:@selector(btnTouchDown:) forControlEvents:UIControlEventTouchDown];//按下时 灰色
    [btn addTarget:self action:@selector(btnDragExit:) forControlEvents:UIControlEventTouchDragExit];//拖拽时 红色
    [self.view addSubview:btn];
    return btn;
}
-(void) btnTouchUpInside:(UIButton *)btn {
    NSLog(@"doRegister..");
    btn.backgroundColor = [UIColor orangeColor];
    
    // 请求参数
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"username"] = self.usernameText.text;
    params[@"password"] = self.passwdText.text;
    UserModel *obj=[[UserModel alloc] init];
    [obj reg:params successBlock:^(id _Nonnull responseObject) {
        if (nil==responseObject) {
            NSLog(@"参数错误");
        }else{
            User *info = [User mj_objectWithKeyValues:responseObject];
            NSLog(@"logined:%@", info.token);
            
            [[NSNotificationCenter defaultCenter] postNotificationName:@"RefreshMyControllerNotify" object:nil];
            NSMutableDictionary *user_cookie = [NSMutableDictionary dictionary];
            user_cookie[@"user_id"] = [NSString stringWithFormat:@"%zd", info.id];
            user_cookie[@"token"] = info.token;
            TokenModel *userDefaults = [[TokenModel alloc] init];
            [userDefaults createToken:@"user_cookie" value:user_cookie];
            //返回我的
            //[self.view resignFirstResponder];
            //当前：我的1->登录2->注册3，点注册按钮返回1 = pushVC.count-3
            NSArray *pushVC=[self.navigationController viewControllers];//[MyController, LoginController, RegisterController]
            //NSLog(@"pushVC:%@", pushVC);
            UIViewController *popVC=[pushVC objectAtIndex:pushVC.count-3];
            [self.navigationController popToViewController:popVC animated:YES];
        }
        
    } failure:^(NSError * _Nonnull error) {
        NSLog(@"error:%@", error);
    }];
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
    [self.view addSubview:textView];
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
