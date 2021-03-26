//
//  ContentHeaderView.h
//  xiangle
//
//  Created by wei cui on 2020/4/1.
//  Copyright © 2020 wei cui. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
@class Joke;
@interface ContentHeaderView : UIView
{
    UILabel *_nickname;
    UIImageView *_avatar;
}
//关注按钮
@property (strong, nonatomic) UIButton *follow;
@property (nonatomic, strong) Joke *field;
@end

NS_ASSUME_NONNULL_END
