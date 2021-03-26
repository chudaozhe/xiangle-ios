//
//  FlashView.h

//  Created by wei cui on 2019/11/3.
//  Copyright © 2019 wei cui. All rights reserved.
//

#import <UIKit/UIKit.h>
@class Flash;
NS_ASSUME_NONNULL_BEGIN

@interface FlashView : UIView
{
    UIImageView *_imageView;
}
/** 备注 */
@property (strong, nonatomic) Flash *field;
@end

NS_ASSUME_NONNULL_END
