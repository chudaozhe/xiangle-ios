//
//  CommentCell.m
//  xiangle
//
//  Created by wei cui on 2020/3/21.
//  Copyright © 2020 wei cui. All rights reserved.
//

#import "CommentCell.h"
#import "Comment.h"
#import <SDWebImage/SDWebImage.h>

@implementation CommentCell

+ (instancetype)cellWithTableView:(UITableView *)tableView{
    static NSString *identifier = @"comment";
    // 1.缓存中取
    //CommentCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    CommentCell *cell = nil;
    // 2.创建
    if (cell == nil) {
        cell = [[CommentCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    return cell;
}
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        _avatarImageView = [[UIImageView alloc] init];
        [self.contentView addSubview:_avatarImageView];
        
        _nickname=[[UILabel alloc] init];
        _nickname.text=@"...";
        _nickname.font=[UIFont systemFontOfSize:14];
        [self.contentView addSubview:_nickname];
        
        _content=[[UILabel alloc] init];
        _content.font=[UIFont systemFontOfSize:14];
        [self.contentView addSubview:_content];
        
        //灰色的线
        //_line=[[UIView alloc] init];
        //_line.backgroundColor=CWGlobalBgColor;
        //[self.contentView addSubview:_line];
    }
    return self;
}
-(void)setField:(Comment *)field{
    _field=field;
    if (![field.content isEqualToString:@""]) {
        _content.text=field.content;
    }
    if (![field.avatar isEqualToString:@""]) {
     NSURL *url=[NSURL URLWithString:[NSString stringWithFormat:@"https://cw-test.oss-cn-hangzhou.aliyuncs.com/%@?x-oss-process=image/resize,w_202", field.avatar]];
     [_avatarImageView sd_setImageWithURL:url placeholderImage:[UIImage imageNamed:@"user"]];
    }
    if (![field.nickname isEqualToString:@""]) {
        _nickname.text=field.nickname;
    }
    [self layoutIfNeeded];
    field.cellHeight=CGRectGetMaxY(_content.frame);//计算cell的高度
}
/**
 重新布局子view
 */
- (void)layoutSubviews{
    //3.设置每个imageView的frame;
    _content.frame=CGRectMake(40, 50, CWScreenW-60, 100);
    _content.numberOfLines=0;
    _content.textAlignment=NSTextAlignmentLeft;
    [_content sizeToFit];
    
    _nickname.frame=CGRectMake(44, 20, 100, 30);
    //_line.frame=CGRectMake(0, 0, CWScreenW, 10);

    _avatarImageView.frame=CGRectMake(10, 20, 30, 30);
    _avatarImageView.backgroundColor = [UIColor whiteColor];
    _avatarImageView.layer.masksToBounds = YES;
    _avatarImageView.layer.cornerRadius = CGRectGetHeight(_avatarImageView.bounds) / 2;
    _avatarImageView.layer.borderWidth = 2.0f;
    _avatarImageView.layer.borderColor = [[UIColor whiteColor]CGColor];
}
- (void)awakeFromNib {
    [super awakeFromNib];
    //设置contentLabel最大宽度
    _content.preferredMaxLayoutWidth=[UIScreen mainScreen].bounds.size.width -20;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    // Configure the view for the selected state
}

@end
