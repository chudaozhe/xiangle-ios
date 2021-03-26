//
//  PublishViewController.h
//  xiangle
//
//  Created by wei cui on 2020/3/5.
//  Copyright © 2020 wei cui. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface PublishViewController : UIViewController
/** 文字or 相册（视频/图片） */
@property (assign, nonatomic) NSInteger is_album;
@end

NS_ASSUME_NONNULL_END
