//
//  TopicHeaderView.h
//  xiangle
//
//  Created by wei cui on 2020/4/1.
//  Copyright © 2020 wei cui. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
@class Topic;
@interface TopicHeaderView : UIView
{
    UIImageView *_imageView;
    UILabel *_title;
    UILabel *_desc;
}

@property (nonatomic, strong) Topic *field;
@end

NS_ASSUME_NONNULL_END
