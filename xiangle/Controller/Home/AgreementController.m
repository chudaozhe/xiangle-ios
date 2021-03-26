//
//  AgreementController.m
//  xiangle
//
//  Created by wei cui on 2020/5/27.
//  Copyright © 2020 wei cui. All rights reserved.
//

#import "AgreementController.h"
#import <Masonry/Masonry.h>
#import "WebViewController.h"
#import "UIColor+Hex.h"
#import "TabBarController.h"
#import <SVProgressHUD/SVProgressHUD.h>

@interface AgreementController ()<UITextViewDelegate>
/** 备注 */
@property (strong, nonatomic) UIImageView *logoView;
@end

@implementation AgreementController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor=[UIColor whiteColor];
    UILabel *title=[[UILabel alloc] init];
    title.frame=CGRectMake(10, kNavBarAndStatusBarHeight+20, CWScreenW-20, 20);
    title.text=@"温馨提示";
    title.textAlignment=NSTextAlignmentCenter;
    [self.view addSubview:title];
    
    [self createTips];
    
    [self setBottom];
    
    [self.view addSubview:self.logoView];
}
#pragma mark - logo
-(UIImageView *)logoView{
    if (nil==_logoView) {
        _logoView=[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"logo"]];
        _logoView.frame=CGRectMake((CWScreenW-60)/2, CWScreenH-100, 60, 60);
    }
    return _logoView;
}
-(void)setBottom{
    UIButton *leftBtn=[UIButton buttonWithType:UIButtonTypeCustom];
    leftBtn.backgroundColor=[UIColor grayColor];
    [leftBtn setImage:[UIImage imageNamed:@"mail"] forState:UIControlStateNormal];
    [leftBtn setTitle:@"不同意" forState:UIControlStateNormal];
    //设置圆角的大小
    leftBtn.layer.cornerRadius = 4;
    leftBtn.imageEdgeInsets = UIEdgeInsetsMake(0, 0, 0, 20);
    [leftBtn addTarget:self action:@selector(clickLeft) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:leftBtn];
    
    UIButton *rightBtn=[UIButton buttonWithType:UIButtonTypeCustom];
    rightBtn.backgroundColor=[UIColor orangeColor];
    [rightBtn setImage:[UIImage imageNamed:@"mail"] forState:UIControlStateNormal];
    [rightBtn setTitle:@"同意" forState:UIControlStateNormal];
    //设置圆角的大小
    rightBtn.layer.cornerRadius = 4;
    rightBtn.imageEdgeInsets = UIEdgeInsetsMake(0, 0, 0, 20);
    [rightBtn addTarget:self action:@selector(clickRight) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:rightBtn];
    //添加约束
    CGFloat margin=20;
    [leftBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.equalTo(@50);
        make.width.equalTo(rightBtn.mas_width);
        //注意right,bottom是负数
        make.left.equalTo(self.view.mas_left).offset(margin);
        make.top.equalTo(rightBtn.mas_top);
        make.right.equalTo(rightBtn.mas_left).offset(-margin);
        make.bottom.equalTo(self.view.mas_bottom).offset(-(margin+100));
        make.bottom.equalTo(rightBtn.mas_bottom);
    }];
    [rightBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.view.mas_right).offset(-margin);
    }];
}
-(void)clickLeft{
    [SVProgressHUD showErrorWithStatus:@"您必须同意，才能使用本APP"];
    [SVProgressHUD dismissWithDelay:3.0f];
}
-(void)clickRight{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setBool:YES forKey:@"firstLogin"];
    
    UIWindow* window = [UIApplication sharedApplication].keyWindow;
    //根控制器
    UITabBarController *tabBarController=[[TabBarController alloc] init];
    //当跳转了某个控制器隐藏TabBar，再返回，TabBar切换控制器的时候选中文字颜色竟然变蓝色了！
    tabBarController.tabBar.tintColor = [UIColor orangeColor];//设置一个默认色
    window.rootViewController=tabBarController;
    [window makeKeyAndVisible];
}
/**
 添加用户协议提示
 https://blog.csdn.net/Morris_/article/details/102605666
 */
-(void)createTips{
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:@"我们非常重视您的个人信息保护，依据最新的监管要求，特向您说明如下：\n 1.您在使用“相乐搞笑”软件及服务的过程中，为向您提供相关基本功能，我们将根据合法、正当、必要的原则，收集、使用必要的信息；\n2.基于您的授权，我们可能会获取你的地理位置、相机等相关软件权限；\n3.为帮助您发现更多优质的内容，会基于您的使用习惯推荐相关内容；\n4.我们会采取符合标准的技术措施和数据安全措施来保护您的个人信息安全；\n\n您选择【同意】即表示充分阅读、理解并接受《用户协议》与《隐私政策》的全部内容。"];
    //设置行间距以及字体大小、颜色
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    paragraphStyle.lineSpacing = 4;// 字体的行间距
    NSDictionary *attributes = @{NSFontAttributeName:[UIFont systemFontOfSize:12.0],
                                 NSForegroundColorAttributeName:[UIColor colorWithHexString:@"000000"],
                                 NSParagraphStyleAttributeName:paragraphStyle};
    [attributedString setAttributes:attributes range:NSMakeRange(0, attributedString.length)];
    
    [attributedString addAttribute:NSLinkAttributeName
                             value:@"https://www.cuiwei.net/agreement.html"
                             range:[[attributedString string] rangeOfString:@"《用户协议》"]];
    [attributedString addAttribute:NSLinkAttributeName value:@"https://www.cuiwei.net/private.html" range:[[attributedString string] rangeOfString:@"《隐私政策》"]];
    NSDictionary *linkAttributes = @{NSForegroundColorAttributeName:[UIColor colorWithHexString:@"113566"]};
    
    UITextView *textView = [[UITextView alloc] initWithFrame:CGRectMake(10, 160, CWScreenW-20, 120)];
    textView.backgroundColor = [UIColor clearColor];
    textView.linkTextAttributes = linkAttributes;
    textView.attributedText = attributedString;
    textView.scrollEnabled = NO;
    textView.font = [UIFont systemFontOfSize:12.0];
    textView.textAlignment = NSTextAlignmentLeft;

    [textView sizeToFit];
    textView.editable = NO;
    textView.delegate = self;
    [self.view addSubview:textView];
}
#pragma mark -
-(BOOL)textView:(UITextView *)textView shouldInteractWithURL:(NSURL *)URL inRange:(NSRange)characterRange{
    //非http开头，忽略
    if (![URL.absoluteString hasPrefix:@"https"]) return YES;
    NSLog(@"点击的url:%@", URL);
    WebViewController *vc=[[WebViewController alloc] init];
    vc.url=URL.absoluteString;
    NSRange range=[URL.absoluteString rangeOfString:@"agreement"];
    if (range.length>0) {
        vc.title=@"用户协议";
    }else{
        vc.title=@"隐私政策";
    }
    
    [self.navigationController pushViewController:vc animated:YES];
    return NO;
}

@end
