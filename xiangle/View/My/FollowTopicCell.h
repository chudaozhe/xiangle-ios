//
//  FollowTopicCell.h
//  xiangle
//
//  Created by wei cui on 2020/9/23.
//  Copyright © 2020 wei cui. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FollowTopic.h"
NS_ASSUME_NONNULL_BEGIN

@interface FollowTopicCell : UITableViewCell

@property (nonatomic, strong) FollowTopic *field;
+(instancetype)cellWithTableView:(UITableView *)tableView;
@end

NS_ASSUME_NONNULL_END
