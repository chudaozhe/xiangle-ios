//
//  SZAddImage.m
//  addImage
//  https://www.cnblogs.com/dashunzi/p/3746445.html
//  Created by mac on 14-5-21.
//  Copyright (c) 2014年 shunzi. All rights reserved.
//

#define imageH 110 // 图片高度124
#define imageW 110 // 图片宽度
#define kMaxColumn 3 // 每行显示数量

#import "SZAddImage.h"
@interface SZAddImage()

@end

@implementation SZAddImage

#pragma mark - 对所有子控件进行布局
- (void)layoutSubviews{
    [super layoutSubviews];
    NSInteger count = self.subviews.count;
    NSLog(@"算上加号，几个图片：%zd", count);
    CGFloat btnW = imageW;
    CGFloat btnH = imageH;
    NSLog(@"容器宽度 self.frame.size.width:%f",self.frame.size.width);
    //self.backgroundColor=[UIColor greenColor];
    //指定列数1，容器宽度/图片宽=列数2。（400/75=5）自动向下取整
    //列数=列数1>列数2? 列数2: 列数1
    //间距
    CGFloat marginX = (self.frame.size.width - kMaxColumn * btnW) / (kMaxColumn - 1);
    NSLog(@"marginX:%f", marginX);
    CGFloat marginY = marginX;
    if (marginY>12.5) marginY=12.5;
    for (int i = 0; i < count; i++) {
        UIButton *btn = self.subviews[i];
        CGFloat btnX = (i % kMaxColumn) * (marginX + btnW);//3%3=0
        CGFloat btnY = (i / kMaxColumn) * (marginY + btnH);//3/3=1
        btn.imageView.contentMode = UIViewContentModeScaleAspectFill;
        btn.frame = CGRectMake(btnX, btnY, btnW, btnH);
    }
}



@end
