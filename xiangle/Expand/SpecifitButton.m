//
//  SpecifitButton.m
//  ios_enterprise
//
//  Created by wei cui on 2020/1/9.
//  Copyright © 2020 wei cui. All rights reserved.
//

#import "SpecifitButton.h"
#import <UIButton+WebCache.h>

@implementation SpecifitButton

- (void)setup{
    self.titleLabel.textAlignment = NSTextAlignmentCenter;
    [self setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    self.titleLabel.font=[UIFont systemFontOfSize:14];
}

- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        [self setup];
    }
    return self;
}

- (void)awakeFromNib{
    [super awakeFromNib];
    [self setup];
}

- (void)layoutSubviews{
    [super layoutSubviews];
    
    // 调整图片
    self.imageView.y = self.height * 0.2;
    self.imageView.width = self.width *0.5;
    self.imageView.height = self.imageView.width;
    self.imageView.centerX=self.width *0.5;
    // 调整文字
    self.titleLabel.x = 0;
    self.titleLabel.y = CGRectGetMaxY(self.imageView.frame);
    self.titleLabel.width = self.width;
    self.titleLabel.height = self.height - self.titleLabel.y;
    self.titleLabel.textColor=[UIColor blackColor];
}
-(void)setField:(NSDictionary *)field{
    [self setTitle:field[@"name"] forState:UIControlStateNormal];
    [self setImage:[UIImage imageNamed:field[@"image"]] forState:UIControlStateNormal];
}
@end
