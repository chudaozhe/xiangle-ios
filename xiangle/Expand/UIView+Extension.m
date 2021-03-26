//
//  UIView+Extension.m
//  ios_enterprise
//
//  Created by wei cui on 2020/1/7.
//  Copyright © 2020 wei cui. All rights reserved.
//

#import "UIView+Extension.h"

@implementation UIView (Extension)


-(void)setWidth:(CGFloat)width
{
    CGRect frame=self.frame;
    frame.size.width=width;
    self.frame=frame;
}
-(void)setHeight:(CGFloat)height
{
    CGRect frame=self.frame;
    frame.size.height=height;
    self.frame=frame;
}
-(void)setX:(CGFloat)x
{
    CGRect frame=self.frame;
    frame.origin.x=x;
    self.frame=frame;
}
-(void)setY:(CGFloat)y
{
    CGRect frame=self.frame;
    frame.origin.y=y;
    self.frame=frame;
}
-(void)setCenterX:(CGFloat)centerX
{
    CGPoint center=self.center;
    center.x=centerX;
    self.center=center;
}
-(void)setCenterY:(CGFloat)centerY
{
    CGPoint center=self.center;
    center.y=centerY;
    self.center=center;
}


-(void)setSize:(CGSize)size
{
    CGRect frame=self.frame;
    frame.size=size;
    self.frame=frame;
}
-(CGFloat)width
{
    return self.frame.size.width;
}
-(CGFloat)height
{
    return self.frame.size.height;
}
-(CGFloat)x
{
    return self.frame.origin.x;
}
-(CGFloat)y
{
    return self.frame.origin.y;
}
-(CGFloat)centerX
{
    return self.center.x;
}
-(CGFloat)centerY
{
    return self.center.y;
}
-(CGSize)size
{
    return self.frame.size;
}
@end
