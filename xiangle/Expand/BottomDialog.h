//
//  BottomDialog.h
//  temp
//
//  Created by wei cui on 2020/9/26.
//  Copyright © 2020 wei cui. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface BottomDialog : UIView
/** 备注 */
@property (strong, nonatomic) UIView *contentView;
/** 备注 */
@property (strong, nonatomic) UIView *leftView;
@property (strong, nonatomic) UIView *rightView;
//展示从底部向上弹出的UIView（包含遮罩）
- (void)showInView:(UIView *)view;
- (void)disMissView;
@end

NS_ASSUME_NONNULL_END
