//
//  CWCategoryCell.m
//
//  Created by wei cui on 2019/12/17.
//  Copyright © 2019 wei cui. All rights reserved.
//

#import "CategoryCell.h"
#import "UIColor+Hex.h"
@implementation CategoryCell
+ (instancetype)cellWithTableView:(UITableView *)tableView{
    static NSString *identifier = @"categoryCell";
    // 1.缓存中取
    CategoryCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
//    CategoryCell *cell = nil;
    // 2.创建
    if (cell == nil) {
        cell = [[CategoryCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    return cell;
}
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        //灰色的线
        //_line=[[UIView alloc] init];
        //_line.backgroundColor=CWGlobalBgColor;
        //[self.contentView addSubview:_line];
    }
    return self;
}
-(void)setField:(Category1 *)field{
    _field=field;
    if (![field.name isEqualToString:@""]) {
        self.textLabel.text=field.name;
    }
    //[self layoutIfNeeded];
}
/**
 重新布局子view
 */
- (void)layoutSubviews{
    [super layoutSubviews];//继承父类
    self.textLabel.font=[UIFont systemFontOfSize:14];
    [self.textLabel setTextAlignment:NSTextAlignmentCenter];
    //_line.frame=CGRectMake(0, 0, CWScreenW, 1);
}
- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
    self.backgroundColor = [UIColor colorWithHexString:@"f6f6f6"];
    if (selected) {
        self.backgroundColor = [UIColor whiteColor];
    }
    /*
    if (selected) {
        self.textLabel.textColor = [UIColor greenColor];
    }
    else {
        self.textLabel.textColor = [UIColor redColor];
    }
     */
}

- (void)setHighlighted:(BOOL)highlighted animated:(BOOL)animated{
    [super setHighlighted:highlighted animated:animated];
    /*
    if (highlighted) {
        self.textLabel.textColor = [UIColor purpleColor];
    }
    else {
        self.textLabel.textColor = [UIColor brownColor];
    }
     */
}

@end
