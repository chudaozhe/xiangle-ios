//
//  Author.h
//  xiangle
//
//  Created by wei cui on 2020/9/29.
//  Copyright © 2020 wei cui. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface Author : NSObject
/** 备注 */
@property (assign, nonatomic) NSInteger id;
/** 备注 */
@property (strong, nonatomic) NSString *uname;
/** 备注 */
@property (strong, nonatomic) NSString *nickname;
/** 备注 */
@property (strong, nonatomic) NSString *avatar;
/** 备注 */
@property (strong, nonatomic) NSString *email;
/** 备注 */
@property (assign, nonatomic) NSInteger status;
/** 备注 */
@property (strong, nonatomic) NSString *welcome;
/** 名言 */
@property (strong, nonatomic) NSString *quotes;
/** 点赞数 */
@property (assign, nonatomic) NSInteger like;
/** 关注数 */
@property (assign, nonatomic) NSInteger following;
/** 粉丝数 */
@property (assign, nonatomic) NSInteger followers;
/** 段子数 */
@property (assign, nonatomic) NSInteger posts;
/** 备注 */
@property (assign, nonatomic) NSInteger is_follow;
/** 性别*/
@property (assign, nonatomic) NSInteger gender;
/** 生日*/
@property (strong, nonatomic) NSString *birthday;
/** 省 */
@property (strong, nonatomic) NSString *province;
/** 市 */
@property (strong, nonatomic) NSString *city;
@end

NS_ASSUME_NONNULL_END
