//
//  FollowUser.h
//  xiangle
//
//  Created by wei cui on 2020/9/23.
//  Copyright © 2020 wei cui. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface FollowUser : NSObject
@property (assign, nonatomic) NSInteger id;
@property (assign, nonatomic) NSInteger user_id;

@property (assign, nonatomic) NSInteger to_user_id;

@property (assign, nonatomic) NSInteger topic_id;

@property (assign, nonatomic) NSInteger type;

@property (strong, nonatomic) NSString *nickname;
@property (strong, nonatomic) NSString *avatar;
@property (strong, nonatomic) NSString *quotes;
@end

NS_ASSUME_NONNULL_END
