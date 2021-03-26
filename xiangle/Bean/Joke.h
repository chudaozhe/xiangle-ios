//
//  Joke.h

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface Joke : NSObject
@property (assign, nonatomic) NSInteger id;
@property (assign, nonatomic) NSInteger type;
@property (assign, nonatomic) NSInteger user_id;
@property (assign, nonatomic) NSInteger topic_id;
@property (strong, nonatomic) NSString *topic_name;//话题名称
@property (strong, nonatomic) NSString *content;
@property (strong, nonatomic) NSString *image;//视频缩略图
@property (strong, nonatomic) NSString *images;
@property (strong, nonatomic) NSString *video;

@property (strong, nonatomic) NSString *nickname;
@property (strong, nonatomic) NSString *avatar;
@property (strong, nonatomic) NSString *quotes;

//是否关注作者
@property (assign, nonatomic) NSInteger is_follow;
//是否点赞
@property (assign, nonatomic) NSInteger is_like;
//是否收藏
@property (assign, nonatomic) NSInteger is_favorite;

/** 每个cell高度 */
@property (nonatomic, assign) CGFloat cellHeight;
@end

NS_ASSUME_NONNULL_END
