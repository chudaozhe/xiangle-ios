//
//  LikeCell.h
//  xiangle
//
//  Created by wei cui on 2020/3/29.
//  Copyright © 2020 wei cui. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Like.h"

NS_ASSUME_NONNULL_BEGIN

@interface LikeCell : UITableViewCell
{
    UIView *_line;
}
@property (nonatomic, strong) Like *field;
+(instancetype)cellWithTableView:(UITableView *)tableView;
@end

NS_ASSUME_NONNULL_END
