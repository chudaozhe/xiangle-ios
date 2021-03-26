//
//  TopicController.h
//  xiangle
//
//  Created by wei cui on 2020/3/12.
//  Copyright © 2020 wei cui. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
@class Topic;
@interface TopicController : UIViewController
/** 话题id */
@property (assign, nonatomic) NSInteger id;
/** 备注 */
@property (strong, nonatomic) Topic *topic;
@end

NS_ASSUME_NONNULL_END
