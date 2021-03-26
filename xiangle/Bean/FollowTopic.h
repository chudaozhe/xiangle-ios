//
//  FollowTopic.h
//  xiangle
//
//  Created by wei cui on 2020/9/23.
//  Copyright © 2020 wei cui. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface FollowTopic : NSObject
@property (assign, nonatomic) NSInteger id;
@property (assign, nonatomic) NSInteger user_id;

@property (assign, nonatomic) NSInteger to_user_id;

@property (assign, nonatomic) NSInteger topic_id;

@property (assign, nonatomic) NSInteger type;

@property (strong, nonatomic) NSString *name;
@property (strong, nonatomic) NSString *image;
@property (assign, nonatomic) NSInteger sum;
@end

NS_ASSUME_NONNULL_END
