//
//  ContentFooterView.h
//  xiangle
//
//  Created by wei cui on 2020/4/12.
//  Copyright © 2020 wei cui. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
@class Joke;
@interface ContentFooterView : UIView
{
    //评论框
    //UITextField *_comment;
}
//点赞按钮
@property (strong, nonatomic) UIButton *like;
//收藏按钮
@property (strong, nonatomic) UIButton *favorite;
@property (nonatomic, strong) Joke *field;
@end

NS_ASSUME_NONNULL_END
