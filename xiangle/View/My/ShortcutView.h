//
//  ShortcutView.h
//  xiangle
//
//  Created by wei cui on 2020/2/29.
//  Copyright © 2020 wei cui. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
@class Shortcut;
@interface ShortcutView : UIView
/** 备注 */
@property (strong, nonatomic) Shortcut *shortcut;

/** 备注 */
@property (strong, nonatomic) UILabel *numLabel;
/** 备注 */
@property (strong, nonatomic) UILabel *titleLabel;
@end

NS_ASSUME_NONNULL_END
