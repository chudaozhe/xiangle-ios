//
//  FollowUserCell.m
//  xiangle
//
//  Created by wei cui on 2020/9/23.
//  Copyright © 2020 wei cui. All rights reserved.
//

#import "FollowUserCell.h"
#import <SDWebImage/SDWebImage.h>

@implementation FollowUserCell
+ (instancetype)cellWithTableView:(UITableView *)tableView{
    static NSString *identifier = @"followUserCell";
    // 1.缓存中取
    FollowUserCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
//    FollowUserCell *cell = nil;
    // 2.创建
    if (cell == nil) {
        cell = [[FollowUserCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:identifier];
    }
    return cell;
}
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
    }
    return self;
}
-(void)setField:(FollowUser *)field{
    _field=field;
    if (![field.nickname isEqualToString:@""]) {
        self.textLabel.text=field.nickname;
    }
    
    if (![field.avatar isEqualToString:@""]) {
        NSURL *url=[NSURL URLWithString:[NSString stringWithFormat:@"https://cw-test.oss-cn-hangzhou.aliyuncs.com/%@?x-oss-process=image/circle,r_60/format,png", field.avatar]];
        [self.imageView sd_setImageWithURL:url placeholderImage:[UIImage imageNamed:@"user"]];
    }
    NSString *quotes=[field.quotes isEqual:@""]?@"这家伙什么也没留下":field.quotes;
    self.detailTextLabel.text=quotes;
}
/**
 重新布局子view
 */
- (void)layoutSubviews{
    [super layoutSubviews];
    self.imageView.frame=CGRectMake(10, 10, 60, 60);
    self.textLabel.frame=CGRectMake(80, 20, 100, 20);
    self.detailTextLabel.frame=CGRectMake(80, 50, CWScreenW-80, 20);
}
- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
