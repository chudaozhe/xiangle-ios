//
//  Like.h
//  xiangle
//
//  Created by wei cui on 2020/3/30.
//  Copyright © 2020 wei cui. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface Like : NSObject
@property (assign, nonatomic) NSInteger id;
@property (assign, nonatomic) NSInteger type;
@property (assign, nonatomic) NSInteger user_id;
@property (assign, nonatomic) NSInteger topic_id;
@property (assign, nonatomic) NSInteger joke_id;
@property (strong, nonatomic) NSString *content;
@property (strong, nonatomic) NSString *image;//视频缩略图
@property (strong, nonatomic) NSString *images;
@property (strong, nonatomic) NSString *video;
/** 每个cell高度 */
@property (nonatomic, assign) CGFloat cellHeight;

@end

NS_ASSUME_NONNULL_END
