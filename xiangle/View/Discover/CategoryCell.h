//
//  CWCategoryCell.h
//
//  Created by wei cui on 2019/12/17.
//  Copyright © 2019 wei cui. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Category1.h"
NS_ASSUME_NONNULL_BEGIN

@interface CategoryCell : UITableViewCell
{
    //UIView *_line;
}
/** 备注 */
@property (nonatomic, strong) Category1 *field;
+(instancetype)cellWithTableView:(UITableView *)tableView;
@end

NS_ASSUME_NONNULL_END
