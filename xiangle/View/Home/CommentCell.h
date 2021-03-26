//
//  CommentCell.h
//  xiangle
//
//  Created by wei cui on 2020/3/21.
//  Copyright © 2020 wei cui. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Comment.h"
NS_ASSUME_NONNULL_BEGIN

@interface CommentCell : UITableViewCell
{
    UILabel *_content;
    UIImageView *_avatarImageView;
    UILabel *_nickname;
    //UIView *_line;
}

@property (nonatomic, strong) Comment *field;
+(instancetype)cellWithTableView:(UITableView *)tableView;
@end

NS_ASSUME_NONNULL_END
