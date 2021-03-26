//
//  TopicHeaderView.m
//  xiangle
//
//  Created by wei cui on 2020/4/1.
//  Copyright © 2020 wei cui. All rights reserved.
//

#import "TopicHeaderView.h"
#import <SDWebImage/SDWebImage.h>
#import "Topic.h"
#import "UIColor+Hex.h"
@implementation TopicHeaderView

//1重写构造方法
-(instancetype)init{
    if (self =[super init]) {
        self.backgroundColor=[UIColor colorWithHexString:@"ffffff"];
        
        _imageView=[[UIImageView alloc] init];
        [self addSubview:_imageView];
        
        _title=[[UILabel alloc] init];
        [self addSubview:_title];
        
        _desc=[[UILabel alloc] init];
        [self addSubview:_desc];
    }
    
    return self;
}
-(void)setField:(Topic *)field{
    _imageView.image=[UIImage imageNamed:@"user"];
    if(field.image!=nil){
        NSURL *url=[NSURL URLWithString:[NSString stringWithFormat:@"https://cw-test.oss-cn-hangzhou.aliyuncs.com/%@?x-oss-process=image/resize,w_80", field.image]];
        [_imageView sd_setImageWithURL:url placeholderImage:[UIImage imageNamed:@"user"]];
    }
    _title.text=@"#...#";
    if (field.name!=nil) {
        _title.text=field.name;
    }
    _desc.text=@"段子数：0";
    if (field.sum) {
        _desc.text=[NSString stringWithFormat:@"段子数：%zd", field.sum];
    }
    
}
-(void)layoutSubviews{
    [super layoutSubviews];
    _imageView.frame=CGRectMake(10, 10, 80, 80);
    _title.frame=CGRectMake(_imageView.width+20, 20, 100, 30);
    _desc.frame=CGRectMake(_imageView.width+20, _title.height+20, 100, 30);
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
