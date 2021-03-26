//
//  CWHomeCell.m
//  php
//
//  Created by wei cui on 2019/12/4.
//  Copyright © 2019 wei cui. All rights reserved.
//

#import "HomeCell.h"
#import "Joke.h"
#import <SDWebImage/SDWebImage.h>
#import "LikeModel.h"
#import "FavoriteModel.h"
#import <SVProgressHUD/SVProgressHUD.h>
#import "TokenModel.h"
#import "ContentController.h"
#import "UIColor+Hex.h"
#import "TopicController.h"

@implementation HomeCell

+ (instancetype)cellWithTableView:(UITableView *)tableView{
    static NSString *identifier = @"joke";
    // 1.缓存中取
    //HomeCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    HomeCell *cell = nil;
    // 2.创建
    if (cell == nil) {
        cell = [[HomeCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    return cell;
}
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        //顶栏
        _topBar=[[UIView alloc] init];
        //_topBar.backgroundColor=[UIColor redColor];
        [self.contentView addSubview:_topBar];
        _avatar=[[UIImageView alloc] init];
        _avatar.userInteractionEnabled=YES;
//        UITapGestureRecognizer *ges = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(btnClick:)];
//        [_avatar addGestureRecognizer:ges];
        [_topBar addSubview:_avatar];
        
        _nickname=[[UILabel alloc] init];
        _nickname.font=[UIFont systemFontOfSize:14];
        _nickname.userInteractionEnabled=YES;
        //UITapGestureRecognizer *ges2 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(btnClick:)];
        //[_nickname addGestureRecognizer:ges2];
        [_topBar addSubview:_nickname];
        
        //文本内容
        _content=[[UILabel alloc] init];
        _content.font=[UIFont systemFontOfSize:14];
        [self.contentView addSubview:_content];

        //图集 最小高度100
        _gridLayout=[[GridLayout alloc] init];
        [self.contentView addSubview:_gridLayout];
        
        //话题名称
        _topic=[UIButton buttonWithType:UIButtonTypeCustom];
        _topic.titleLabel.font=[UIFont systemFontOfSize:14];
        [_topic setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        //_topic.backgroundColor=[UIColor redColor];
        [_topic setContentHorizontalAlignment:UIControlContentHorizontalAlignmentLeft];
        
        [_topic setTitleColor:[UIColor orangeColor] forState:UIControlStateNormal];
        [_topic.layer setBorderColor:[UIColor orangeColor].CGColor];
        //设置圆角的大小
        _topic.layer.cornerRadius = 6;
        //设置边框的粗细
        [_topic.layer setBorderWidth:1.0];
        //设置对应的边距,上，左，下，右
        _topic.titleEdgeInsets = UIEdgeInsetsMake(0, 5, 0, 5);

        [_topic addTarget:self action:@selector(doJumpTopic:) forControlEvents:UIControlEventTouchUpInside];
        [self.contentView addSubview:_topic];
        
        //底栏
        _bottomBar=[[UIView alloc] init];
        //阴影 start
        _bottomBar.backgroundColor=[UIColor whiteColor];
        CALayer *layer = [_bottomBar layer];
        layer.masksToBounds = NO;//必须要等于NO否则会把阴影切割隐藏掉
        layer.shadowOffset = CGSizeMake(0, 0); //(0,0)时是四周都有阴影
        layer.shadowRadius = 5;
        layer.shadowColor = [UIColor blackColor].CGColor;
        layer.shadowOpacity = 0.2;
        
        // 单边阴影 顶边
        float shadowPathWidth = layer.shadowRadius;
        CGRect shadowRect = CGRectMake(0, 0, CWScreenW, shadowPathWidth);
        UIBezierPath *path = [UIBezierPath bezierPathWithRect:shadowRect];
        layer.shadowPath = path.CGPath;
        //阴影 end
        [self.contentView addSubview:_bottomBar];
        
        CGFloat interval=(CWScreenW-80*3)/4;
        _likeButton=[self createButton:@"点赞" image:@"zan" highlightedImage:@"zan2"];
        _likeButton.frame = CGRectMake(interval, 0, 80, 30);
        [_likeButton addTarget:self action:@selector(doLike:) forControlEvents:UIControlEventTouchUpInside];
        [_bottomBar addSubview:_likeButton];
        _commentButton=[self createButton:@"评论" image:@"pinglun" highlightedImage:@"pinglun2"];
        _commentButton.frame = CGRectMake(interval*2+80, 0, 80, 30);
        [_commentButton addTarget:self action:@selector(doComment:) forControlEvents:UIControlEventTouchUpInside];
        [_bottomBar addSubview:_commentButton];
        _favoriteButton=[self createButton:@"收藏" image:@"shoucang" highlightedImage:@"shoucang2"];
        _favoriteButton.frame = CGRectMake(interval*3+80*2, 0, 80, 30);
        [_favoriteButton addTarget:self action:@selector(doFavorite:) forControlEvents:UIControlEventTouchUpInside];
        [_bottomBar addSubview:_favoriteButton];
        //灰色的线
        _line=[[UIView alloc] init];
        _line.backgroundColor=[UIColor colorWithHexString:@"f2f2f7"];
        [self.contentView addSubview:_line];
    }
    return self;
}
-(void)doJumpTopic:(UIButton *)button{
    TopicController *vc=[[TopicController alloc] init];
    vc.id=button.tag;
    //[self.navigationController pushViewController:vc animated:YES];
    UITabBarController *tabBarVc= [UIApplication sharedApplication].keyWindow.rootViewController;
    UINavigationController *nav= (UINavigationController *) tabBarVc.selectedViewController;
    [nav pushViewController:vc animated:YES];
}
-(void)setField:(Joke *)field{
    _field=field;
    _avatar.image=[UIImage imageNamed:@"user"];
    if(field.avatar!=nil){
        NSURL *url=[NSURL URLWithString:[NSString stringWithFormat:@"https://cw-test.oss-cn-hangzhou.aliyuncs.com/%@?x-oss-process=image/resize,w_80", field.avatar]];
        [_avatar sd_setImageWithURL:url placeholderImage:[UIImage imageNamed:@"user"]];
        _avatar.tag=field.user_id;
    }
    _nickname.text=@"...";
    if (field.nickname!=nil) {
        _nickname.text=field.nickname;
        _nickname.tag=field.user_id;
    }
    
    if (![field.content isEqualToString:@""]) {
        _content.text=field.content;
    }

    [_likeButton setImage:[UIImage imageNamed:@"zan"] forState:UIControlStateNormal];
    if (field.is_like) {
        [_likeButton setImage:[UIImage imageNamed:@"zan2"] forState:UIControlStateNormal];
    }
    
    [_favoriteButton setImage:[UIImage imageNamed:@"shoucang"] forState:UIControlStateNormal];
    if (field.is_favorite) {
        [_favoriteButton setImage:[UIImage imageNamed:@"shoucang2"] forState:UIControlStateNormal];
    }
    
    _gridLayout.images=[self _buildGridLayoutArgs:field];
    [_gridLayout layoutIfNeeded];
    [self layoutIfNeeded];
    
    if (field.topic_id>0) {
        [_topic setTitle:[NSString stringWithFormat:@"#%@#", field.topic_name] forState:UIControlStateNormal];
        _topic.titleLabel.adjustsFontSizeToFitWidth = YES;
        _topic.tag=field.topic_id;
    }
    if (field.type==1) {
        //无图
        CGFloat contentHeight=CGRectGetMaxY(_content.frame);
        field.cellHeight=contentHeight+10+20+30;//计算cell的高度
        //NSLog(@"无图图field.cellHeight:%f", field.cellHeight);
    }else{
        //有图
        CGFloat imgBoxHeight=CGRectGetMaxY(_gridLayout.frame);
        field.cellHeight=imgBoxHeight+20+30;//计算cell的高度
        //NSLog(@"有图field.cellHeight:%f", field.cellHeight);
    }
    if (field.topic_id>0) {
        field.cellHeight+=30;
    }else _topic.hidden=YES;
}
/**
 重新布局子view
 */
- (void)layoutSubviews{
    //顶栏
    _topBar.frame=CGRectMake(0, 0, CWScreenW, 60);
    _avatar.frame=CGRectMake(10, 10, 50, 50);
    _avatar.backgroundColor = [UIColor whiteColor];
    _avatar.layer.masksToBounds = YES;
    _avatar.layer.cornerRadius = CGRectGetHeight(_avatar.bounds) / 2;
    _avatar.layer.borderWidth = 2.0f;
    _avatar.layer.borderColor = [[UIColor whiteColor] CGColor];
    
    _nickname.frame=CGRectMake(70, 20, 100, 30);
    
    //文本的frame;
    _content.frame=CGRectMake(10, 70, CWScreenW-20, 20);
    _content.numberOfLines=0;
    [_content sizeToFit];
    _gridLayout.frame=CGRectMake(10, CGRectGetMaxY(_content.frame)+10, CWScreenW-20, 0);
    //设置gridLayout高度
    if (_gridLayout.subviews.count>0) {
        UIImageView *img=_gridLayout.subviews[_gridLayout.subviews.count-1];
        _gridLayout.height=CGRectGetMaxY(img.frame)+10;
        //NSLog(@"height origin=%f", _gridLayout.height);
    }else _gridLayout.height=0;
    //[self layoutIfNeeded];
    //话题
    _topic.x=10;
    _topic.y=CGRectGetMaxY(_gridLayout.frame);
//    _topic.height=20;
    [_topic sizeToFit];
    //底栏
    _bottomBar.frame=CGRectMake(0, CGRectGetMaxY(_gridLayout.frame)+10, CWScreenW, 30);
    if (_field.topic_id>0) _bottomBar.y+=30;
    //分割线
    _line.frame=CGRectMake(0, CGRectGetMaxY(_bottomBar.frame), CWScreenW, 10);
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
#pragma mark - 组合参数（栅格布局
-(NSMutableArray *)_buildGridLayoutArgs:(Joke *)field{
    NSMutableArray *arr=[[NSMutableArray alloc] init];
    if (![field.images isEqualToString:@""]) {
        //图集
        NSArray *images= [field.images componentsSeparatedByString:@","];
        for (int i=0; i<images.count; i++) {
            NSDictionary *dict=[NSDictionary dictionaryWithObjects:@[[NSString stringWithFormat:@"%zd", field.type], images[i], images[i]] forKeys:@[@"type", @"image", @"original"]];
            arr[i]=dict;
        }
    }else if(![field.image isEqualToString:@""]){
        //视频头图
        NSDictionary *dict=[NSDictionary dictionaryWithObjects:@[[NSString stringWithFormat:@"%zd", field.type], field.image, field.video] forKeys:@[@"type", @"image", @"original"]];
        arr[0]=dict;
    }
    return arr;
}
-(UIButton *)createButton:(NSString *)title image:(NSString *)image highlightedImage:(NSString *)highlightedImage{
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.backgroundColor = [UIColor clearColor];
    //设置button正常状态下的图片
    [button setImage:[UIImage imageNamed:image] forState:UIControlStateNormal];
    //设置button高亮状态下的图片
    [button setImage:[UIImage imageNamed:highlightedImage] forState:UIControlStateHighlighted];
    //设置button正常状态下的背景图
    //[button setBackgroundImage:[UIImage imageNamed:@"_normal.png"] forState:UIControlStateNormal];
    //设置button高亮状态下的背景图
    //[button setBackgroundImage:[UIImage imageNamed:@"_highlighted.png"] forState:UIControlStateHighlighted];
    //button图片的偏移量，距上左下右分别(10, 10, 10, 60)像素点
    button.imageEdgeInsets = UIEdgeInsetsMake(3, 0, 3, 0);
    button.imageView.contentMode = UIViewContentModeScaleAspectFit;//等比例缩放icon


    [button setTitle:title forState:UIControlStateNormal];
    //button标题的偏移量，这个偏移量是相对于图片的
    button.titleEdgeInsets = UIEdgeInsetsMake(0, 5, 0, 0);
    //设置button正常状态下的标题颜色
    [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    //设置button高亮状态下的标题颜色
    //[button setTitleColor:[UIColor greenColor] forState:UIControlStateHighlighted];
    button.titleLabel.font = [UIFont systemFontOfSize:14];
    //button.backgroundColor=[UIColor greenColor];
    return button;
}
-(void)doLike:(UIButton *)btn{
    //NSLog(@"zan... id:%zd", _field.id);
    //验证是否登录
    TokenModel *userDefaults = [[TokenModel alloc] init];
    NSMutableDictionary *data=[userDefaults getToken:@"user_cookie"];
    NSLog(@"见证奇迹getuserDefaults:%@", data);
    if (nil!=data) {
        NSString *method=@"PUT";
        if (_field.is_like==1) method=@"DELETE";
        LikeModel *obj=[[LikeModel alloc] init];
        NSMutableDictionary *params = [NSMutableDictionary dictionary];
        params[@"user_id"] = data[@"user_id"];//当前登录用户的user_id
        params[@"joke_id"] = [NSString stringWithFormat:@"%zd", _field.id];
        [obj run:params method:method successBlock:^(id  _Nonnull responseObject) {
            //NSLog(@"result: %@", responseObject);
            NSDictionary *field=responseObject;
            NSLog(@"field:%@", field);
            
            //切换按钮状态
            if (self.field.is_like) {//取反
                [self.likeButton setImage:[UIImage imageNamed:@"zan"] forState:UIControlStateNormal];
            }else{
                [self.likeButton setImage:[UIImage imageNamed:@"zan2"] forState:UIControlStateNormal];
            }
            self.likeButton.enabled=NO;
        } failure:^(NSError * _Nonnull error) {
            NSLog(@"error:%@", error);
        }];
    }else{
        //提示先登录
        [SVProgressHUD showErrorWithStatus:@"请先登录"];
        [SVProgressHUD dismissWithDelay:1.0f];
    }
}
-(void)doComment:(UIButton *)btn{
    //NSLog(@"pinglun... id2:%zd", _field.id);
    ContentController *vc=[[ContentController alloc] init];
    vc.id=_field.id;
    //[self.navigationController pushViewController:vc animated:YES];
    UITabBarController *tabBarVc= [UIApplication sharedApplication].keyWindow.rootViewController;
    UINavigationController *nav= (UINavigationController *) tabBarVc.selectedViewController;
    [nav pushViewController:vc animated:YES];
}
-(void)doFavorite:(UIButton *)btn{
    //NSLog(@"shoucang... id3:%zd", _field.id);
    //验证是否登录
    TokenModel *userDefaults = [[TokenModel alloc] init];
    NSMutableDictionary *data=[userDefaults getToken:@"user_cookie"];
    NSLog(@"见证奇迹getuserDefaults:%@", data);
    if (nil!=data) {
        NSString *method=@"PUT";
        if (_field.is_favorite==1) method=@"DELETE";
        FavoriteModel *obj=[[FavoriteModel alloc] init];
        NSMutableDictionary *params = [NSMutableDictionary dictionary];
        params[@"user_id"] = data[@"user_id"];//当前登录用户的user_id
        params[@"joke_id"] = [NSString stringWithFormat:@"%zd", _field.id];
        [obj run:params method:method successBlock:^(id  _Nonnull responseObject) {
            //NSLog(@"result: %@", responseObject);
            NSDictionary *field=responseObject;
            NSLog(@"field:%@", field);
            
            //切换按钮状态
            if (self.field.is_favorite) {//取反
                [self.favoriteButton setImage:[UIImage imageNamed:@"shoucang"] forState:UIControlStateNormal];
            }else{
                [self.favoriteButton setImage:[UIImage imageNamed:@"shoucang2"] forState:UIControlStateNormal];
            }
            self.favoriteButton.enabled=NO;
        } failure:^(NSError * _Nonnull error) {
            NSLog(@"error:%@", error);
        }];
    }else{
        //提示先登录
        [SVProgressHUD showErrorWithStatus:@"请先登录"];
        [SVProgressHUD dismissWithDelay:1.0f];
    }
}
@end
