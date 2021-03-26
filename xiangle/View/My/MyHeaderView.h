//
//  MyHeaderView.h
//  xiangle
//
//  Created by wei cui on 2020/4/4.
//  Copyright © 2020 wei cui. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
@class User;
@interface MyHeaderView : UIView
{
    UIImageView *_imageView;
    UIButton *_title;
    UIButton *_edit;
}

@property (nonatomic, strong) User *field;
@end

NS_ASSUME_NONNULL_END
