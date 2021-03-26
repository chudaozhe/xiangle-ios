//
//  UIBarButtonItem+CWExtension.h
//  顶部 bar
//  包括左右按钮
//  Created by wei cui on 2019/12/3.
//  Copyright © 2019 wei cui. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIBarButtonItem (Extension)
+(instancetype) itemWithImage:(NSString *)image highImage:(NSString *)highImage target:(id)target action:(SEL)action;
@end

NS_ASSUME_NONNULL_END
