//
//  NotifyCell.m
//  xiangle
//
//  Created by wei cui on 2020/3/29.
//  Copyright © 2020 wei cui. All rights reserved.
//

#import "NotifyCell.h"
#import "UIColor+Hex.h"

@implementation NotifyCell
/*
+ (instancetype)cellWithTableView:(UITableView *)tableView{
    static NSString *identifier = @"notify";
    // 1.缓存中取
    NotifyCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
//    NotifyCell *cell = nil;
    // 2.创建
    if (cell == nil) {
        cell = [[NotifyCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    return cell;
}
 */
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        //灰色的线
        _line=[[UIView alloc] init];
        _line.backgroundColor=[UIColor colorWithHexString:@"f2f2f7"];
        [self.contentView addSubview:_line];
        
        //通知标题
        _title=[[UILabel alloc] init];
        [self.contentView addSubview:_title];
        /*
        //通知时间
        _time=[[UILabel alloc] init];
        [self.contentView addSubview:_time];
         */
    }
    return self;
}
-(void)setField:(Notify *)field{
    _field=field;
    if (![field.content isEqualToString:@""]) {
        self.textLabel.text=field.content;
    }
    self.imageView.image=[UIImage imageNamed:@"system2"];
    _title.text=@"系统消息";
    //_time.text=[self timestamp2date:field.create_time format:@"YYYY-MM-dd HH:mm"];
//    [self layoutIfNeeded];
}
-(NSString *)timestamp2date:(NSString *)timestamp format:(NSString *)formatstr{
    NSTimeInterval time=[timestamp doubleValue];//传入的时间戳str如果是精确到毫秒的记得要/1000
    NSDate *detailDate=[NSDate dateWithTimeIntervalSince1970:time];
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init]; //实例化一个NSDateFormatter对象
    //设定时间格式,这里可以设置成自己需要的格式
    [dateFormatter setDateFormat:formatstr];
    return [dateFormatter stringFromDate: detailDate];
}
/**
 重新布局子view
 */
- (void)layoutSubviews{
    [super layoutSubviews];//继承父类
    self.imageView.frame=CGRectMake(10, 20, 50, 50);
    self.imageView.backgroundColor = [UIColor whiteColor];
    self.imageView.layer.masksToBounds = YES;
    self.imageView.layer.cornerRadius = CGRectGetHeight(self.imageView.bounds) / 2;
    self.imageView.layer.borderWidth = 2.0f;
    self.imageView.layer.borderColor = [[UIColor whiteColor] CGColor];
    
    _line.frame=CGRectMake(0, 0, CWScreenW, 10);
    _title.frame=CGRectMake(70, 26, CWScreenW-120, 20);
    self.textLabel.frame= CGRectMake(70, 50, CWScreenW-120, 20);
    //_time.frame=CGRectMake(CWScreenW-120, 40, 120, 20);
    
    _title.font=[UIFont systemFontOfSize:14 weight:1];
    //_time.font=[UIFont systemFontOfSize:12];
    self.textLabel.font=[UIFont systemFontOfSize:12];
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
