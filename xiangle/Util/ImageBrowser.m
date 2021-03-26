//
//  ImageBrowser.m
//  xiangle
//
//  Created by wei cui on 2020/3/26.
//  Copyright © 2020 wei cui. All rights reserved.
//

#import "ImageBrowser.h"
#import <SDWebImage/SDWebImage.h>

static NSArray *_data;
@implementation ImageBrowser
+ (void)initialize{
     _data = [[NSArray alloc] init];
}
+(void)setData:(NSArray *)data{
    _data=data;
}
+(void)showImage:(NSInteger)i{
    NSLog(@"点击了第%ld张图片", i);
    //2个数据：图片url数组, i
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    UIView *backgroundView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height)];

    backgroundView.backgroundColor = [UIColor blackColor];
    backgroundView.alpha = 0;

    UIImageView *imageView2 = [[UIImageView alloc] init];//点击后的大图

    NSURL *url=[NSURL URLWithString:[NSString stringWithFormat:@"https://cw-test.oss-cn-hangzhou.aliyuncs.com/%@", _data[i]]];//原图
    [imageView2 sd_setImageWithURL:url placeholderImage:nil completed:^(UIImage * _Nullable image, NSError * _Nullable error, SDImageCacheType cacheType, NSURL * _Nullable imageURL) {
        [backgroundView addSubview:imageView2];
        [window addSubview:backgroundView];

        [UIView animateWithDuration:0.2 animations:^{
           imageView2.frame = CGRectMake(0,(CWScreenH - image.size.height * CWScreenW / image.size.width) / 2, CWScreenW, image.size.height * CWScreenW / image.size.width);
           backgroundView.alpha = 1;
        } completion:^(BOOL finished) {

        }];
    }];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hideImage:)];
    backgroundView.userInteractionEnabled=YES;
    [backgroundView addGestureRecognizer: tap];
}

+(void)hideImage:(UITapGestureRecognizer *)tap{
    UIView *backgroundView = tap.view;
    [UIView animateWithDuration:0.2 animations:^{
        backgroundView.alpha = 0;
    } completion:^(BOOL finished) {
        [backgroundView removeFromSuperview];
    }];
}

@end
