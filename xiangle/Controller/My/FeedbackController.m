//
//  FeedbackController.m
//  xiangle
//
//  Created by wei cui on 2020/3/2.
//  Copyright © 2020 wei cui. All rights reserved.
//

#import "FeedbackController.h"
#define TextViewDefaultText @"随便说点什么吧"
#import "FeedbackModel.h"
#import "TokenModel.h"

@interface FeedbackController ()<UITextViewDelegate>
/** 留言内容 */
@property (strong, nonatomic) UITextView *textView;
/** 联系方式 */
@property (strong, nonatomic) UITextField *textField;

@end

@implementation FeedbackController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title=@"意见反馈";
    self.view.backgroundColor=[UIColor whiteColor];
    self.navigationItem.rightBarButtonItem=[[UIBarButtonItem alloc] initWithTitle:@"提交" style:UIBarButtonItemStyleDone target:self action:@selector(doPublish)];
    self.navigationItem.rightBarButtonItem.tintColor=[UIColor orangeColor];
    [self createTextarea];
    [self createInput];
    if ([self.textField.text isEqualToString:@""] || [self.textView.text isEqualToString:@""] || [self.textView.text isEqualToString:TextViewDefaultText]) {
        self.navigationItem.rightBarButtonItem.enabled=NO;
    }
}
-(void)doPublish{
    NSLog(@"push...");
    // 请求参数
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    //验证是否登录
    TokenModel *userDefaults = [[TokenModel alloc] init];
    NSMutableDictionary *data=[userDefaults getToken:@"user_cookie"];
    NSLog(@"见证奇迹getuserDefaults:%@", data);
    params[@"user_id"] = nil!=data?data[@"user_id"]:@0;
    params[@"content"]=self.textView.text;
    params[@"contact"]=self.textField.text;
    FeedbackModel *obj=[[FeedbackModel alloc] init];
    [obj create:params successBlock:^(id  _Nonnull responseObject) {
        NSLog(@"result: %@", responseObject);
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"" message:@"谢谢反馈" preferredStyle:UIAlertControllerStyleAlert];
         [self presentViewController:alert animated:YES completion:nil];
        //控制提示框显示的时间为2秒
         [self performSelector:@selector(dismiss:) withObject:alert afterDelay:2.0];
        
    } failure:^(NSError * _Nonnull error) {
        NSLog(@"error:%@", error);
    }];
}
- (void)dismiss:(UIAlertController *)alert{
    [alert dismissViewControllerAnimated:YES completion:nil];
    //返回上一层
    [self.navigationController popViewControllerAnimated:YES];
}
-(void)createTextarea{
    UITextView *textView=[[UITextView alloc] initWithFrame:CGRectMake(10, 100, CWScreenW-20, 200)];
    //边框
    textView.layer.backgroundColor = [[UIColor clearColor] CGColor];
    textView.layer.borderColor = [[UIColor lightGrayColor] CGColor];
    textView.layer.borderWidth = 1.0;
    textView.delegate=self;

    textView.text = TextViewDefaultText;
    textView.font=[UIFont systemFontOfSize:12];

    [textView.layer setMasksToBounds:YES];
    [self.view addSubview:textView];
    self.textView=textView;
}
-(BOOL)textViewShouldBeginEditing:(UITextView *)textView{
    if ([textView.text isEqualToString:TextViewDefaultText]) {
        textView.text = @"";
    }
    textView.textColor = [UIColor blackColor];
    return YES;
}
-(BOOL)textViewShouldEndEditing:(UITextView *)textView{
    NSString *str = [textView.text stringByReplacingOccurrencesOfString:@" " withString:@""];
    if ([str isEqualToString:@""]) {
        textView.text = TextViewDefaultText;
        textView.textColor = [UIColor lightGrayColor];
    }
    return YES;
}
#pragma mark - textView改变内容后(一般用于计算文本的高度)
-(void)textViewDidChange:(UITextView *)textView{
    self.navigationItem.rightBarButtonItem.enabled=![textView.text isEqualToString:@""];
}
-(void)createInput{
    UITextField *textField=[[UITextField alloc] initWithFrame:CGRectMake(10, 340, CWScreenW-20, 40)];
    textField.backgroundColor = [UIColor whiteColor];
    textField.placeholder=@"    请输入qq号";
    //边框
    textField.borderStyle = UITextBorderStyleNone;
    textField.layer.borderWidth= 1.0;
    textField.layer.borderColor= [UIColor lightGrayColor].CGColor;
    //内边距
    //[textField setValue:[NSNumber numberWithInt:10] forKey:@"paddingTop"];
    [textField setValue:[NSNumber numberWithInt:10] forKey:@"paddingLeft"];
    //[textField setValue:[NSNumber numberWithInt:10] forKey:@"paddingBottom"];
    //[textField setValue:[NSNumber numberWithInt:10] forKey:@"paddingRight"];
    //文字垂直居中
    textField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    textField.font=[UIFont systemFontOfSize:12];

    [self.view addSubview:textField];
    self.textField=textField;
}

@end
