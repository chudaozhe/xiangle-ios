//
//  UIBarButtonItem+CWExtension.m
//  php
//
//  Created by wei cui on 2019/12/3.
//  Copyright © 2019 wei cui. All rights reserved.
//

#import "UIBarButtonItem+Extension.h"

@implementation UIBarButtonItem (CWExtension)
+(instancetype) itemWithImage:(NSString *)image highImage:(NSString *)highImage target:(id)target action:(SEL)action{
    UIButton *btn=[UIButton buttonWithType:UIButtonTypeCustom];
    [btn setBackgroundImage:[UIImage imageNamed:image] forState:UIControlStateNormal];
    [btn setBackgroundImage:[UIImage imageNamed:highImage] forState:UIControlStateHighlighted];
    btn.size=btn.currentBackgroundImage.size;
    [btn addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    return [[self alloc] initWithCustomView:btn];
}
@end
