//
//  AppDelegate.m
//  xiangle
//
//  Created by wei cui on 2020/2/23.
//  Copyright © 2020 wei cui. All rights reserved.
//

#import "AppDelegate.h"
#import "TabBarController.h"
#import "AgreementController.h"
#import "ContentController.h"

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    self.window=[[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    if(![defaults boolForKey:@"firstLogin"]){
        NSLog(@"firstLogin");
        
        AgreementController *ac=[[AgreementController alloc] init];
        UINavigationController *navVc=[[UINavigationController alloc] initWithRootViewController:ac];
        //设置窗口的根控制器
        self.window.rootViewController=navVc;
     }else{
         //跟控制器
         UITabBarController *tabBarController=[[TabBarController alloc] init];
         //当跳转了某个控制器隐藏TabBar，再返回，TabBar切换控制器的时候选中文字颜色竟然变蓝色了！
         tabBarController.tabBar.tintColor = [UIColor orangeColor];//设置一个默认色
         self.window.rootViewController=tabBarController;
     }
    [self.window makeKeyAndVisible];
    return YES;
}
#pragma mark Universal Link
- (BOOL)application:(UIApplication *)application continueUserActivity:(NSUserActivity *)userActivity restorationHandler:(void (^)(NSArray<id<UIUserActivityRestoring>> * _Nullable))restorationHandler {
    if ([userActivity.activityType isEqualToString:NSUserActivityTypeBrowsingWeb]) {
        NSURL *url = userActivity.webpageURL;
        NSLog(@"url:%@", url);//https://xiangle.cuiwei.net/detail/?id=123
        NSString *host = url.host;
        if ([host isEqualToString:@"xiangle.cuiwei.net"]) {
            //进行我们需要的处理
            ContentController *cc=[[ContentController alloc] init];
            cc.id=90;//解析url,得到帖子id=90
            UITabBarController *tabBarVc= [UIApplication sharedApplication].keyWindow.rootViewController;
            UINavigationController *nav= (UINavigationController *) tabBarVc.selectedViewController;
            [nav pushViewController:cc animated:YES];
            //NSLog(@"TODO....");
//            UINavigationController *nav (UINavigationController *) tab
        } else {
            //Objective-C
            NSDictionary *options = @{UIApplicationOpenURLOptionUniversalLinksOnly : @YES};
            [application openURL:url options:options completionHandler:nil];
            //Swift
            //let options = [UIApplicationOpenURLOptionUniversalLinksOnly : true]
            //UIApplication.shared.open(url, options: options, completionHandler: nil)
        }
    }
    return YES;
}
@end
