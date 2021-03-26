//
//  BannerCell.m
//

#import "BannerCell.h"

@implementation BannerCell

+ (instancetype)cellWithTableView:(UITableView *)tableView indexPath:(NSIndexPath *)indexPath{
    static NSString *identifier = @"banner";
    // 1.缓存中取
    //BannerCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];//改为以下的方法
    BannerCell *cell = [tableView cellForRowAtIndexPath:indexPath]; //根据indexPath准确地取出一行，而不是从cell重用队列中取出;
    // 2.创建
    if (cell == nil) {
        cell = [[BannerCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    return cell;
}
//- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
//    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
//
//    return self;
//}

- (void)awakeFromNib {
    [super awakeFromNib];
}
@end
