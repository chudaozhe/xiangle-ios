//
//  FlashView.m
//
//  Created by wei cui on 2019/11/3.
//  Copyright © 2019 wei cui. All rights reserved.
//

#import "FlashView.h"
#import "Flash.h"
#import <SDWebImage/SDWebImage.h>

@implementation FlashView

//1重写构造方法
-(instancetype)init{
    if (self =[super init]) {
        _imageView=[[UIImageView alloc] init];
        [self addSubview:_imageView];
    }
    return self;
}
-(void)setField:(Flash *)field{
    NSURL *url=[NSURL URLWithString:@"https://cw-test.oss-cn-hangzhou.aliyuncs.com/flash/1.jpg"];
    [_imageView sd_setImageWithURL:url placeholderImage:[UIImage imageNamed:@"agent"]];
}
/**
 设置子控件
 */
-(void)layoutSubviews{
    [super layoutSubviews];
    _imageView.frame=CGRectMake(0, 0, self.width, self.height);
}
@end
