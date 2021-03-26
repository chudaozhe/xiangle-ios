//
//  GridLayout.m
//  xiangle
//
//  Created by wei cui on 2020/4/9.
//  Copyright © 2020 wei cui. All rights reserved.
//

#import "GridLayout.h"
#import <SDWebImage/SDWebImage.h>
#import "ImageBrowser.h"
#import "VideoBrowser.h"

@interface GridLayout ()

/** imgBox里面图片的path数组 */
@property (strong, nonatomic) NSMutableArray *imgBoxImagePaths;
/** 视频文件url */
@property (strong, nonatomic) NSURL *videoUrl;
@end
@implementation GridLayout

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        //_imgBox子view已存在，清空子view
        if (self.subviews.count>0) {
            [self clearImgBoxSubviews];
        }
        [self layoutIfNeeded];
    }
    return self;
}
-(void)setImages:(NSMutableArray *)imgs{
    self.imgBoxImagePaths=[[NSMutableArray alloc] init];//初始化
   for (int i=0; i<imgs.count; i++) {
       NSDictionary *image=imgs[i];
       if ([image[@"type"] integerValue]==3){//如果是视频就添加播放按钮
           UIImageView *imageView=[self createImageView:image[@"image"] i:i isVideo:YES];//添加视频说略图，无点击事件
           [self addSubview:imageView];
           self.videoUrl=[NSURL URLWithString:[NSString stringWithFormat:@"https://cw-test.oss-cn-hangzhou.aliyuncs.com/%@", image[@"original"]]];//用于播放
       }else{
           UIImageView *imageView=[self createImageView:image[@"image"] i:i isVideo:NO];//添加图片，有点击事件
           [self.imgBoxImagePaths addObject:image[@"original"]];
           [self addSubview:imageView];
       }
   }
}
-(UIImageView *)createImageView:(NSString *)path i:(NSInteger)i isVideo:(BOOL)isVideo{
    UIImageView *imageView=[[UIImageView alloc] init];
    //imageView.frame=CGRectMake(0, 0, CWScreenW-20, 200);
    NSURL *url=[NSURL URLWithString:[NSString stringWithFormat:@"https://cw-test.oss-cn-hangzhou.aliyuncs.com/%@?x-oss-process=image/resize,w_600", path]];
    [imageView sd_setImageWithURL:url placeholderImage:[UIImage imageNamed:@"picture2"] completed:^(UIImage * _Nullable image, NSError * _Nullable error, SDImageCacheType cacheType, NSURL * _Nullable imageURL) {
       //NSLog(@"宽：%f, 高：%f", image.size.width, image.size.height);
//       CGFloat width=image.size.width>(CWScreenW-20)?(CWScreenW-20):image.size.width;
//       CGFloat height=image.size.height>480?480:image.size.height;//图片最大高度480
//       imageView.width=width;
//       imageView.height=height;
        if (isVideo) {
            [self createPlayBtn:imageView];//播放按钮
        }
    }];
    imageView.userInteractionEnabled=YES;
    imageView.tag=i; //set tag value
    if (!isVideo) {
        //图片，没有播放按钮
        UITapGestureRecognizer *singleTap =[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(showImage:)];
        [imageView addGestureRecognizer:singleTap];
    }
    [self addSubview:imageView];
    return imageView;
}
// 对所有子控件进行布局
- (void)layoutSubviews{
    [super layoutSubviews];
    //设置frame
    for (int i=0; i<self.subviews.count; i++) {
        UIImageView *imageView=self.subviews[i];
        //等比例缩放
        //UIViewContentModeScaleAspectFit 样式如下，能看出来图片上下有黑色空白
        //UIViewContentModeScaleAspectFill 样式如下，能看出来图片左右有部分没有显示出来
        imageView.contentMode=UIViewContentModeScaleAspectFill;//UIViewContentModeTopLeft
        imageView.clipsToBounds = true;
        switch (self.subviews.count) {
          case 1:
                imageView.frame=[self oneFrame];
                //imageView.frame=CGRectMake(0, 0, imageView.width, imageView.height);
              break;
          case 2:
              imageView.frame=[self twoFrame:i];
              break;
          default:
              imageView.frame=[self threeFrame:i];
              break;
        }
    }
}
-(CGRect)oneFrame{
    //self.containerHeight=350+10;
    CGFloat w=CWScreenW-20;
    return CGRectMake(0, 0, w, (w/16)*9);//一排1张
}
-(CGRect)twoFrame:(int)i{
    CGFloat width=floor((CWScreenW-20-10)/2);//一排2张
    //self.containerHeight=width+10;
    return CGRectMake(i*(width+10), 0, width, width);
}
-(CGRect)threeFrame:(int)i{
    CGFloat width=floor((CWScreenW-20-20)/3);//一排3张
    CGFloat height=width;
    CGFloat row = (int)(i / 3);//列号 0开始;
    CGFloat x=(i % 3) * (width + 10);
    CGFloat y = row * (height + 10);
    //self.containerHeight=(row+1)*(height+20);
    return CGRectMake(x, y, width, height);
}

-(void)showImage:(UIGestureRecognizer *)sender{
    NSInteger i=sender.view.tag;
    [ImageBrowser setData:self.imgBoxImagePaths];
    [ImageBrowser showImage:i];
}
-(void)clearImgBoxSubviews{
    for(UIImageView *imgv in self.subviews){
        [imgv removeFromSuperview];
    }
}
//给视频缩略图添加播放按钮
-(void)createPlayBtn:(UIImageView*)imageView{
    CGFloat w=CWScreenW-20;
    UIButton *btn=[[UIButton alloc] initWithFrame:CGRectMake((w/2)-32, ((w/16)*9/2)-32, 64, 64)];
    [btn setImage:[UIImage imageNamed:@"play"] forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(play) forControlEvents:UIControlEventTouchUpInside];
    //[btn setTitle:@"播放" forState:UIControlStateNormal];
    //btn.backgroundColor=[UIColor grayColor];
    [imageView addSubview:btn];//缩略图上添加
}
#pragma mark - 播放视频
-(void)play{
    VideoBrowser *vb=[[VideoBrowser alloc] init];
    [vb playVideo: self.videoUrl];
}

@end
