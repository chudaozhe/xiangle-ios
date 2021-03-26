//
//  WebViewController.m
//  xiangle
//
//  Created by wei cui on 2020/4/16.
//  Copyright © 2020 wei cui. All rights reserved.
//

#import "WebViewController.h"
#import <WebKit/WebKit.h>

@interface WebViewController ()<WKUIDelegate,WKNavigationDelegate>

@property (nonatomic, strong) WKWebViewConfiguration *wkConfig;
@property (nonatomic, strong) UIProgressView *progressView;

@property (nonatomic, strong) WKWebView *wkWebView;
@end

@implementation WebViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor=[UIColor whiteColor];
    /*
     *2.初始化progressView
     */
    self.progressView = [[UIProgressView alloc] initWithFrame:CGRectMake(0, 44, CWScreenW, 2)];
    self.progressView.backgroundColor = [UIColor whiteColor];
    //self.progressView.tintColor=[UIColor grayColor];
    //self.progressView.trackTintColor= [UIColor blackColor];//未过进度部分的颜色
    //已过进度颜色
    self.progressView.progressTintColor = [UIColor orangeColor];

    self.progressView.progressImage = [UIImage imageNamed:@"WKProgress"];
    //设置进度条的高度，下面这句代码表示进度条的宽度变为原来的1倍，高度变为原来的1.5倍.
    self.progressView.transform = CGAffineTransformMakeScale(1.0f, 1.5f);
    //[self.navigationController.navigationBar addSubview:self.progressView];
    [self.navigationController.navigationBar addSubview:self.progressView];
    /*
     *3.添加KVO，WKWebView有一个属性estimatedProgress，就是当前网页加载的进度，所以监听这个属性。
     */
    [self.wkWebView addObserver:self forKeyPath:@"estimatedProgress" options:NSKeyValueObservingOptionNew context:nil];
    
    [self loadWebViewWithUrl:self.url];
}
#pragma mark - 初始化wkWebView

- (WKWebViewConfiguration *)wkConfig {
    if (!_wkConfig) {
        _wkConfig = [[WKWebViewConfiguration alloc] init];
        _wkConfig.allowsInlineMediaPlayback = YES;
        if (@available(iOS 10.0, *)) {
            _wkConfig.allowsPictureInPictureMediaPlayback = YES;
        } else {
            // Fallback on earlier versions
        }
    }
    return _wkConfig;
}

- (WKWebView *)wkWebView {
    if (!_wkWebView) {
        _wkWebView = [[WKWebView alloc] initWithFrame:CGRectMake(0, kNavBarAndStatusBarHeight+ 2, CWScreenW, CWScreenH-kNavBarAndStatusBarHeight-2) configuration:self.wkConfig];
        _wkWebView.navigationDelegate = self;
        _wkWebView.UIDelegate = self;
        [self.view addSubview:_wkWebView];
    }
    return _wkWebView;
}

/*
 *6.在dealloc中取消监听
 */

- (void)dealloc {
    if (self.progressView) {
        [self.progressView removeFromSuperview];
        self.progressView = nil;
    }
    [self.wkWebView removeObserver:self forKeyPath:@"estimatedProgress"];
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [self.progressView removeFromSuperview];
    self.progressView = nil;
}

#pragma mark - start load web
- (void)loadWebViewWithUrl:(NSString *)url{
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:url]];
    request.timeoutInterval = 15.0f;
    [self.wkWebView loadRequest:request];
}

#pragma mark - 监听
/*
 *4.在监听方法中获取网页加载的进度，并将进度赋给progressView.progress
 */
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSString *,id> *)change context:(void *)context {
    if ([keyPath isEqualToString:@"estimatedProgress"]) {
        NSLog(@"%.2f,",self.wkWebView.estimatedProgress);
        self.progressView.progress = self.wkWebView.estimatedProgress;
        if (self.progressView.progress == 1) {
            /*
             *添加一个简单的动画，将progressView的Height变为1.4倍
             *动画时长0.25s，延时0.3s后开始动画
             *动画结束后将progressView隐藏
             */
            __weak typeof (self)weakSelf = self;
            [UIView animateWithDuration:0.25f delay:0.3f options:UIViewAnimationOptionCurveEaseOut animations:^{
                weakSelf.progressView.transform = CGAffineTransformMakeScale(1.0f, 1.4f);
            } completion:^(BOOL finished) {
                weakSelf.progressView.hidden = YES;
            }];
        }
    }else{
        [super observeValueForKeyPath:keyPath ofObject:object change:change context:context];
    }
}
#pragma mark - WKWKNavigationDelegate Methods
/*
 *5.在WKWebViewd的代理中展示进度条，加载完成后隐藏进度条
 */

//开始加载
- (void)webView:(WKWebView *)webView didStartProvisionalNavigation:(WKNavigation *)navigation {
    NSLog(@"开始加载网页");
    //开始加载网页时展示出progressView
    self.progressView.hidden = NO;
    //开始加载网页的时候将progressView的Height恢复为1.5倍
    self.progressView.transform = CGAffineTransformMakeScale(1.0f, 1.5f);
    //防止progressView被网页挡住
    [self.navigationController.navigationBar bringSubviewToFront:self.progressView];
}

//加载完成
- (void)webView:(WKWebView *)webView didFinishNavigation:(WKNavigation *)navigation {
    NSLog(@"加载完成");
    //加载完成后隐藏progressView
    //self.progressView.hidden = YES;
}

//加载失败
- (void)webView:(WKWebView *)webView didFailProvisionalNavigation:(WKNavigation *)navigation withError:(NSError *)error {
    NSLog(@"加载失败");
    //加载失败同样需要隐藏progressView
    self.progressView.hidden = YES;
}

//页面跳转
- (void)webView:(WKWebView *)webView decidePolicyForNavigationAction:(WKNavigationAction *)navigationAction decisionHandler:(void (^)(WKNavigationActionPolicy))decisionHandler {
    //允许页面跳转
    NSLog(@"%@",navigationAction.request.URL);
    decisionHandler(WKNavigationActionPolicyAllow);
}

@end
