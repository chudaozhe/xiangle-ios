//
//  AuthorHeaderView.h
//  xiangle
//
//  Created by wei cui on 2020/6/10.
//  Copyright © 2020 wei cui. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
@class Author;
@interface AuthorHeaderView : UIView
{
    UILabel *_nickname;
    UIImageView *_avatar;
    //简介
    UILabel *_quotes;
    //关注数
    UILabel *_following;
    //粉丝数
    UILabel *_followers;
}
//关注按钮
@property (strong, nonatomic) UIButton *follow;

@property (nonatomic, strong) Author *field;
@end

NS_ASSUME_NONNULL_END
