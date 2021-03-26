//
//  BannerCell.h
//  此cell暂时没用到，等确认要加ad时在用；调用文档见Evernote “google广告 横幅广告”

#import <UIKit/UIKit.h>
NS_ASSUME_NONNULL_BEGIN

@interface BannerCell : UITableViewCell

+(instancetype)cellWithTableView:(UITableView *)tableView indexPath:(NSIndexPath *)indexPath;
@end

NS_ASSUME_NONNULL_END
