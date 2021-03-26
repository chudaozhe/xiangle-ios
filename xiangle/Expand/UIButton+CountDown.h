//
//  UIButton+CountDown.h
//  xiangle
//
//  Created by wei cui on 2020/9/20.
//  Copyright © 2020 wei cui. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIButton (CountDown)
- (void)startCountDownTime:(int)time withCountDownBlock:(void(^)(void))countDownBlock;
@end

NS_ASSUME_NONNULL_END
