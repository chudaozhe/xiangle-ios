//
//  BannerView.m
//  xiangle
//
//  Created by wei cui on 2020/11/29.
//  Copyright © 2020 wei cui. All rights reserved.
//

#import "BannerView.h"
#import <SDWebImage/SDWebImage.h>

@implementation BannerView

//1重写构造方法
-(instancetype)init{
    if (self =[super init]) {
        _imageView=[[UIImageView alloc] init];
        [self addSubview:_imageView];
    }
    return self;
}
-(void)setField:(NSString *)field{
    NSURL *url=[NSURL URLWithString:@"https://cw-test.oss-cn-hangzhou.aliyuncs.com/banner/my_banner.jpg"];
    [_imageView sd_setImageWithURL:url placeholderImage:[UIImage imageNamed:@"agent"]];
    //等比例缩放
    _imageView.contentMode=UIViewContentModeScaleAspectFit;
    _imageView.clipsToBounds = true;
}
/**
 设置子控件
 */
-(void)layoutSubviews{
    [super layoutSubviews];
    _imageView.frame=CGRectMake(0, 0, self.width, self.height);
}

@end
