//
//  Flash.h
//  ios_enterprise
//
//  Created by wei cui on 2020/2/8.
//  Copyright © 2020 wei cui. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface Flash : NSObject
/** 备注 */
@property (assign, nonatomic) NSInteger id;
/** 备注 */
@property (strong, nonatomic) NSString *title;
/** 备注 */
@property (strong, nonatomic) NSString *image;
/** 备注 */
@property (strong, nonatomic) NSString *url;
@end

NS_ASSUME_NONNULL_END
