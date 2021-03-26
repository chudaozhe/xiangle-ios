//
//  Shortcut.h
//  ios_enterprise
//
//  Created by wei cui on 2020/1/9.
//  Copyright © 2020 wei cui. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface Shortcut : NSObject
/** 备注 */
@property (assign, nonatomic) NSInteger id;
/** 备注 */
@property (assign, nonatomic) NSInteger type;
/** 备注 */
@property (strong, nonatomic) NSString *title;
/** 备注 */
@property (strong, nonatomic) NSString *link;
/** 备注 */
@property (strong, nonatomic) NSString *icon;
/** 备注 */
@property (assign, nonatomic) NSInteger count;
@end

NS_ASSUME_NONNULL_END
