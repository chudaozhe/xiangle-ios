//
//  ShortcutView.m
//  xiangle
//
//  Created by wei cui on 2020/2/29.
//  Copyright © 2020 wei cui. All rights reserved.
//

#import "ShortcutView.h"
#import "Shortcut.h"
@implementation ShortcutView

-(void)setup{
    self.numLabel=[[UILabel alloc] init];
    [self addSubview:self.numLabel];

    self.titleLabel=[[UILabel alloc] init];
    [self insertSubview:self.titleLabel belowSubview:self.numLabel];
    
    self.numLabel.textAlignment =self.titleLabel.textAlignment = NSTextAlignmentCenter;
    self.titleLabel.font=[UIFont systemFontOfSize:14];
}
- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        [self setup];
    }
    return self;
}
- (void)awakeFromNib
{
    [self setup];
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    // numLabel
    self.numLabel.y = 0;
    self.numLabel.width = self.width *0.5;
    self.numLabel.height = self.numLabel.width;
    self.numLabel.centerX=self.width *0.5;
    // 调整文字
    self.titleLabel.x = 0;
    self.titleLabel.y = 40;
    self.titleLabel.width = self.width;
    self.titleLabel.height = self.height - self.titleLabel.y;
    self.titleLabel.textColor=[UIColor blackColor];

}
-(void)setShortcut:(Shortcut *)shortcut
{
    _shortcut=shortcut;
    self.numLabel.text=[NSString stringWithFormat:@"%zd", shortcut.count];
    self.titleLabel.text=shortcut.title;
}

//-(void)click:(UITapGestureRecognizer *)tap{
//    NSLog(@"good:%@", tap);
//}
@end
