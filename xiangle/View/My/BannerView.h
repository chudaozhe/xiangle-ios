//
//  BannerView.h
//  xiangle
//
//  Created by wei cui on 2020/11/29.
//  Copyright © 2020 wei cui. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface BannerView : UIView
{
    UIImageView *_imageView;
}
@property (strong, nonatomic) NSString *field;
@end

NS_ASSUME_NONNULL_END
