//
//  Comment.h
//  xiangle
//
//  Created by wei cui on 2020/3/21.
//  Copyright © 2020 wei cui. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface Comment : NSObject
//评论id
@property (assign, nonatomic) NSInteger id;
/** 评论内容 */
@property (strong, nonatomic) NSString *content;
/** 评论人id */
@property (assign, nonatomic) NSInteger user_id;
/** 昵称 */
@property (strong, nonatomic) NSString *nickname;
/** 头像 */
@property (strong, nonatomic) NSString *avatar;

/** 段子id */
@property (assign, nonatomic) NSInteger joke_id;
@property (assign, nonatomic) NSInteger type;
@property (assign, nonatomic) NSInteger topic_id;
@property (strong, nonatomic) NSString *joke_content;
@property (strong, nonatomic) NSString *image;//视频缩略图
@property (strong, nonatomic) NSString *images;
@property (strong, nonatomic) NSString *video;

/** 每个cell高度 */
@property (nonatomic, assign) CGFloat cellHeight;
@end

NS_ASSUME_NONNULL_END
