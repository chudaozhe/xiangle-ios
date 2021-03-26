//
//  VideoBrowser.m
//  xiangle
//
//  Created by wei cui on 2020/3/27.
//  Copyright © 2020 wei cui. All rights reserved.
//

#import "VideoBrowser.h"
#import <AVFoundation/AVFoundation.h>
#import <AVKit/AVKit.h>

@implementation VideoBrowser
#pragma mark 播放视频
-(void)playVideo:(NSURL *)url{
    //2.创建待view的播放器
    AVPlayerViewController *playVC=[[AVPlayerViewController alloc] init];
    //3.player，基本上什么操作都要使用它
    playVC.player=[AVPlayer playerWithURL:url];
    //4.播放视频
    [playVC.player play];
    //视频的填充模式
    //AVLayerVideoGravityResizeAspect 是按原视频比例显示，是竖屏的就显示出竖屏的，两边留黑；
    //AVLayerVideoGravityResizeAspectFill 是以原比例拉伸视频，直到两边屏幕都占满，但视频内容有部分就被切割了
    //AVLayerVideoGravityResize 是拉伸视频内容达到边框占满，但不按原比例拉伸，这里明显可以看出宽度被拉伸了。
    playVC.videoGravity = AVLayerVideoGravityResizeAspect;
    //是否显示播放控制条
    playVC.showsPlaybackControls = YES;
    //若想监听视频的操作，设置代理
    //playVC.delegate=self;
    [self showVideoModal:playVC];
}
#pragma mark 展示播放器1:模态对话框,即全屏，不需要frame
-(void)showVideoModal:(AVPlayerViewController *)playVC{
    UITabBarController *tabBarVc= [UIApplication sharedApplication].keyWindow.rootViewController;
    UINavigationController *nav= (UINavigationController *) tabBarVc.selectedViewController;
    [nav presentViewController:playVC animated:YES completion:nil];
}
@end
