//
//  Notify.h
//  xiangle
//
//  Created by wei cui on 2020/3/31.
//  Copyright © 2020 wei cui. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface Notify : NSObject
/** 备注 */
@property (assign, nonatomic) NSInteger id;
/** 备注 */
@property (strong, nonatomic) NSString *content;
/** 备注 */
@property (strong, nonatomic) NSString *url;
/** 备注 */
@property (strong, nonatomic) NSString *create_time;
@end

NS_ASSUME_NONNULL_END
