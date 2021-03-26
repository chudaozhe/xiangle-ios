//
//  Topic.h
//  xiangle
//
//  Created by wei cui on 2020/3/31.
//  Copyright © 2020 wei cui. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface Topic : NSObject
/** 备注 */
@property (assign, nonatomic) NSInteger id;
/** 备注 */
@property (strong, nonatomic) NSString *name;
/** 备注 */
@property (strong, nonatomic) NSString *image;
/** 段子总数 */
@property (assign, nonatomic) NSInteger sum;
/** 是否已关注 */
@property (assign, nonatomic) NSInteger is_follow;

- (Topic *)setTopic:(NSInteger) id name:(NSString *) name image:(NSString *) image sum:(NSInteger) sum;

@end

NS_ASSUME_NONNULL_END
