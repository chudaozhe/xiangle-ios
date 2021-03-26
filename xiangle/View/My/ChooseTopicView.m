//
//  ChooseTopicView.m
//  xiangle
//
//  Created by wei cui on 2020/9/24.
//  Copyright © 2020 wei cui. All rights reserved.
//

#import "ChooseTopicView.h"
#import "Topic.h"

@interface ChooseTopicView()
/** target */
@property(nonatomic, weak) id target;
/** action */
@property(nonatomic, assign) SEL action;
@end
@implementation ChooseTopicView

-(void)setup{
    _leftIcon=[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"huati"]];
    [self addSubview:_leftIcon];
    
    _title=[[UILabel alloc] init];
    [self addSubview:_title];
    
    _rightIcon=[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"jiantou"]];
    [self addSubview:_rightIcon];
}
- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        [self setup];
    }
    return self;
}
-(void)setField:(Topic *)field{
    _title.text=field.name;
}
-(void)layoutSubviews{
    [super layoutSubviews];
    _leftIcon.frame=CGRectMake(0, 5, 30, 30);
    _title.frame=CGRectMake(30, 5, 100, 30);
    _title.font=[UIFont systemFontOfSize:14];
    _rightIcon.frame=CGRectMake(self.width-20, 10, 20, 20);
    _title.text=@"选择话题";
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
-(void)addTarget:(id)target action:(SEL)action{
    self.target= target;
    self.action= action;
}

-(void)touchesEnded:(NSSet *) touches withEvent:(UIEvent*) event{
    //获取触摸对象
    UITouch *touche = [touches anyObject];
    //获取touche的位置
    CGPoint point = [touche locationInView: self];
    //判断点是否在button中
    if(CGRectContainsPoint(self.bounds, point)) {
        //执行action
        [self.target performSelector: self.action withObject: self];
    }
}

@end
