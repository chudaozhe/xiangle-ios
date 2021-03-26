//
//  BottomDialog.m
//  xiangle
//
//  Created by wei cui on 2020/9/26.
//  Copyright © 2020 wei cui. All rights reserved.
//

#import "BottomDialog.h"
@implementation BottomDialog
- (void)setupContent:(CGFloat)height {
    self.frame = CGRectMake(0, 0, CWScreenW, CWScreenH);
    //alpha 0.0  白色   alpha 1 ：黑色   alpha 0～1 ：遮罩颜色，逐渐
    self.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.4];
    self.userInteractionEnabled = YES;
    [self addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(disMissView)]];
    if(_contentView == nil) {
        _contentView=[[UIView alloc] initWithFrame:CGRectMake(0, 0, CWScreenW, height)];//主要设置了width, 为了closeBtn可以确定位置
        _contentView.backgroundColor = [UIColor whiteColor];
        [self addSubview:_contentView];
        //右上角关闭按钮
        UIButton *rightView = [UIButton buttonWithType:UIButtonTypeCustom];
        [rightView setImage:[UIImage imageNamed:@"cuowu"] forState:UIControlStateNormal];
        [rightView addTarget:self action:@selector(disMissView) forControlEvents:UIControlEventTouchUpInside];
        //rightView.frame = CGRectMake(_contentView.frame.size.width - 20 - 15, 15, 20, 20);//距离上边，右边 各15
        _rightView=rightView;
        [_contentView addSubview:_rightView];
    }
}
- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        if (frame.size.height<1) frame.size.height=200;
        NSLog(@"frame.size.height:%f", frame.size.height);
        [self setupContent:frame.size.height];
    }
    return self;
}
-(void)setLeftView:(UIView *)leftView{
    _leftView=leftView;
    [_contentView addSubview:_leftView];
    [self setNeedsDisplay];
}
-(void)setRightView:(UIView *)rightView{
    [_rightView removeFromSuperview];
    _rightView=rightView;
    [_contentView addSubview:_rightView];
    [self setNeedsDisplay];
}
-(void)layoutSubviews{
    [super layoutSubviews];
    if(_leftView) _leftView.frame=CGRectMake(15, 15, 30, 20);//距离上边，右边 各15
    if (_rightView) _rightView.frame = CGRectMake(_contentView.frame.size.width - 20 - 15, 15, 30, 20);//距离上边，右边 各15
}
- (void)showInView:(UIView *)view {
    if (!view) return;
    [view addSubview:self];
    //NSLog(@"%@", self.subviews);
    [view addSubview:_contentView];
     
    [_contentView setFrame:CGRectMake(0, CWScreenH, CWScreenW, _contentView.height)];
     
    [UIView animateWithDuration:0.3 animations:^{
        self.alpha = 1.0;
        [self.contentView setFrame:CGRectMake(0, CWScreenH - self.contentView.height, CWScreenW, self.contentView.height)];
    } completion:nil];
}
- (void)disMissView {
    [_contentView setFrame:CGRectMake(0, CWScreenH - self.contentView.height, CWScreenW, self.contentView.height)];
    [UIView animateWithDuration:0.3f
                     animations:^{
                         self.alpha = 0.0;
                         [self.contentView setFrame:CGRectMake(0, CWScreenH, CWScreenW, self.contentView.height)];
                     }
                     completion:^(BOOL finished){
                         [self removeFromSuperview];
                         [self.contentView removeFromSuperview];
                     }];
}
@end
