//
//  FollowUserCell.h
//  xiangle
//
//  Created by wei cui on 2020/9/23.
//  Copyright © 2020 wei cui. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FollowUser.h"
NS_ASSUME_NONNULL_BEGIN

@interface FollowUserCell : UITableViewCell

@property (nonatomic, strong) FollowUser *field;
+(instancetype)cellWithTableView:(UITableView *)tableView;
@end

NS_ASSUME_NONNULL_END
