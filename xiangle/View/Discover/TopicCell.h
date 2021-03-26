//
//  TopicCell.h
//  xiangle
//
//  Created by wei cui on 2020/9/22.
//  Copyright © 2020 wei cui. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Topic.h"
NS_ASSUME_NONNULL_BEGIN

@interface TopicCell : UITableViewCell
{
    UIView *_line;
    UILabel *_desc;
}
//关注按钮
@property (strong, nonatomic) UIButton *follow;
@property (nonatomic, strong) Topic *field;
+(instancetype)cellWithTableView:(UITableView *)tableView;
@end

NS_ASSUME_NONNULL_END
