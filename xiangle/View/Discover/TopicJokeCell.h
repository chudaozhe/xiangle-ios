//
//  TopicJokeCell.h
//  和HomeCell的区别，仅仅是移除了话题名称的按钮

#import <UIKit/UIKit.h>
#import "Joke.h"
#import "GridLayout.h"
NS_ASSUME_NONNULL_BEGIN

@interface TopicJokeCell : UITableViewCell
{
    //顶栏
    UIView *_topBar;
    UIImageView *_avatar;
    UILabel *_nickname;
    //话题名称
//    UIButton *_topic;
    UILabel *_content;
    UIView *_line;
    /** 九宫格布局 */
    GridLayout *_gridLayout;
    //底栏
    UIView *_bottomBar;
    //UIButton *_likeButton;
    UIButton *_commentButton;
    //UIButton *_favoriteButton;
}
/** 备注 */
@property (strong, nonatomic) UIButton *likeButton;
/** 备注 */
@property (strong, nonatomic) UIButton *favoriteButton;
/** 备注 */
@property (nonatomic, strong) Joke *field;
+(instancetype)cellWithTableView:(UITableView *)tableView;
@end

NS_ASSUME_NONNULL_END
