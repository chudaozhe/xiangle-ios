//
//  ChooseTopicController.h
//  xiangle
//
//  Created by wei cui on 2020/9/24.
//  Copyright © 2020 wei cui. All rights reserved.
//

#import <UIKit/UIKit.h>
@class Topic;
NS_ASSUME_NONNULL_BEGIN
//协议
@protocol ChooseTopicControllerDelegate <NSObject>

@optional
-(void)onControllerResult:(Topic *)topic;

@end


@interface ChooseTopicController : UIViewController
@property (nonatomic, weak) id delegate;
@end

NS_ASSUME_NONNULL_END
