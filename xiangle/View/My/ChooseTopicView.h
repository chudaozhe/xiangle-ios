//
//  ChooseTopicView.h
//  xiangle
//
//  Created by wei cui on 2020/9/24.
//  Copyright © 2020 wei cui. All rights reserved.
//

#import <UIKit/UIKit.h>
@class Topic;
NS_ASSUME_NONNULL_BEGIN

@interface ChooseTopicView : UIView
{
    UIImageView *_leftIcon;
    UILabel *_title;
    UIImageView *_rightIcon;
}
@property (nonatomic, strong) Topic *field;
-(void)addTarget:target action:(SEL)action;
@end

NS_ASSUME_NONNULL_END
