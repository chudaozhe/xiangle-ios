//
//  NotifyCell.h
//  xiangle
//
//  Created by wei cui on 2020/3/29.
//  Copyright © 2020 wei cui. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Notify.h"

NS_ASSUME_NONNULL_BEGIN

@interface NotifyCell : UITableViewCell
{
    UIView *_line;
    UILabel *_title;
    UILabel *_time;
}
@property (nonatomic, strong) Notify *field;
//+(instancetype)cellWithTableView:(UITableView *)tableView;
@end

NS_ASSUME_NONNULL_END
