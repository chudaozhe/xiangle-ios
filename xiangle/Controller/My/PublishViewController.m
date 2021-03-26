//
//  PublishViewController.m
//  xiangle
//
//  Created by wei cui on 2020/3/5.
//  Copyright © 2020 wei cui. All rights reserved.
//

#import "PublishViewController.h"
#import "SZAddImage.h"
#import <AVFoundation/AVFoundation.h>
#import <AVKit/AVKit.h>
#import "JokeModel.h"
#import "OSS.h"
#import <AssetsLibrary/AssetsLibrary.h>
#import "TokenModel.h"
#import <SVProgressHUD/SVProgressHUD.h>
#import "ChooseTopicView.h"
#import "ChooseTopicController.h"
#import "Topic.h"

#define TextViewDefaultText @"随便说点什么吧"
#define MaxImageCount 9 // 最多显示图片个数

@interface PublishViewController ()<UITextViewDelegate,UINavigationControllerDelegate, UIImagePickerControllerDelegate, ChooseTopicControllerDelegate>
/** 文本框 */
@property (strong, nonatomic) UITextView *textView;
/** 备注 */
@property (strong, nonatomic) ChooseTopicView *chooseTopicView;
@property (strong, nonatomic) SZAddImage *imgBox;
/** 相册视频url */
@property (strong, nonatomic) NSURL *videoUrl;
/** 备注 */
@property (strong, nonatomic) NSMutableArray *images;//图片集

@property (strong, nonatomic) NSString *video;//视频url
/** 视频缩略图url */
@property (strong, nonatomic) NSString *video_thumbnail;
/** 备注 */
@property (strong, nonatomic) NSMutableDictionary *cache;
/** 发布所需的参数 */
@property (strong, nonatomic) NSMutableDictionary *params;
@end

@implementation PublishViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor=CWGlobalBgColor;
    self.title=@"发布";
    self.params = [NSMutableDictionary dictionary];
    //验证是否登录
    TokenModel *userDefaults = [[TokenModel alloc] init];
    _cache=[userDefaults getToken:@"user_cookie"];
    NSLog(@"见证奇迹getuserDefaults:%@", _cache);
    
    self.navigationItem.rightBarButtonItem=[[UIBarButtonItem alloc] initWithTitle:@"提交" style:UIBarButtonItemStyleDone target:self action:@selector(doPublish)];
    self.navigationItem.rightBarButtonItem.tintColor=[UIColor orangeColor];
    
    self.images=[NSMutableArray array];
    NSLog(@"is_album:%zd", self.is_album);
    if (_is_album) {
        [self.view addSubview:self.textView];
        //一个demo
         self.imgBox= [[SZAddImage alloc] init];
         self.imgBox.frame=CGRectMake(10, CGRectGetMaxY(self.textView.frame)+10, CWScreenW-20, (110+12.5));//图片110*110，间距12.5
         [self.view addSubview:self.imgBox];
        //初始化一个 加号
        UIButton *btn=[self createButtonWithImage:@"add" andSeletor:@selector(callImagePicker)];
        [self.imgBox addSubview:btn];
        [btn sendActionsForControlEvents:UIControlEventTouchUpInside];//模拟点击
    }else{
        [self.view addSubview:self.textView];
    }
    
    [self.view addSubview:self.chooseTopicView];
    
    if ([self.textView.text isEqualToString:@""] || [self.textView.text isEqualToString:TextViewDefaultText]) {
        self.navigationItem.rightBarButtonItem.enabled=NO;
    }else self.navigationItem.rightBarButtonItem.enabled=YES;
    NSLog(@"self.images.count:%zd", self.images.count);
    
    if (self.images.count>0 || self.video !=nil) self.navigationItem.rightBarButtonItem.enabled=YES;//从缓存里读取才起作用，暂时没有
}
//#pragma mark - 点击空白区域隐藏键盘
-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    //点击空白区域隐藏键盘
    //[self.view resignFirstResponder];
    [self.view endEditing:YES];
}
-(void)doPublish{
    NSLog(@"push...");
    // 请求参数
    if ([self.textView.text isEqualToString:TextViewDefaultText]) {
        self.textView.text = @"";
    }
    NSLog(@"imgs:%@", self.images);
    
    if (nil!=_cache) {
        _params[@"user_id"]=_cache[@"user_id"];
        _params[@"type"] = [NSString stringWithFormat:@"%i", 1];
        //_params[@"topic_id"] = [NSString stringWithFormat:@"%i", 1];
        //_params[@"title"] = @"标题";//用不到
        _params[@"content"] = self.textView.text;
        if (self.images.count>0) {
            _params[@"type"] = [NSString stringWithFormat:@"%i", 2];
            _params[@"images"] = [self.images componentsJoinedByString:@","];
        }
        if (self.video){
            _params[@"type"] = [NSString stringWithFormat:@"%i", 3];
            _params[@"video"] = self.video;
        }
        if (nil!=self.video_thumbnail) _params[@"image"] = self.video_thumbnail;//视频缩略图
        _params[@"keywords"] = @"测试";
        _params[@"status"] = [NSString stringWithFormat:@"%i", 1];
        NSLog(@"params:%@", _params);
        /* */
        JokeModel *obj=[JokeModel alloc];
        [obj addJoke:_params successBlock:^(id  _Nonnull responseObject) {
            NSLog(@"result:%@", responseObject);
            UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"" message:@"发表成功" preferredStyle:UIAlertControllerStyleAlert];
             [self presentViewController:alert animated:YES completion:nil];
            //控制提示框显示的时间为2秒
             [self performSelector:@selector(dismiss:) withObject:alert afterDelay:2.0];
        } failure:^(NSError * _Nonnull error) {
            NSLog(@"error:%@", error);
        }];
    }else{
        //提示先登录
        [SVProgressHUD showErrorWithStatus:@"请先登录"];
        [SVProgressHUD dismissWithDelay:1.0f];
    }
}
- (void)dismiss:(UIAlertController *)alert{
    [alert dismissViewControllerAnimated:YES completion:nil];
    //返回上一层
    [self.navigationController popViewControllerAnimated:YES];
}
#pragma mark - 文本输入框
-(UITextView *)textView{
    if (nil==_textView) {
        _textView=[[UITextView alloc] initWithFrame:CGRectMake(10, 100, CWScreenW-20, 30)];
        _textView.delegate=self;
        _textView.text = TextViewDefaultText;
        _textView.font=[UIFont systemFontOfSize:14];
        _textView.height=50;
        _textView.layer.masksToBounds=YES;
        _textView.layer.borderColor = [UIColor whiteColor].CGColor;
        _textView.layer.cornerRadius = 4;
        _textView.layer.borderWidth = 0.5;
    }
    return _textView;
}
-(ChooseTopicView *)chooseTopicView{
    if (nil==_chooseTopicView) {
        _chooseTopicView=[[ChooseTopicView alloc] initWithFrame:CGRectMake(10, CGRectGetMaxY(_textView.frame)+20, CWScreenW-20, 40)];
        _chooseTopicView.layer.masksToBounds=YES;
        _chooseTopicView.layer.borderColor = [UIColor whiteColor].CGColor;
        _chooseTopicView.layer.cornerRadius = 4;
        _chooseTopicView.layer.borderWidth = 0.5;
        if (_is_album) {
            _chooseTopicView.y=CGRectGetMaxY(self.imgBox.frame)+20;
        }
        _chooseTopicView.backgroundColor=[UIColor whiteColor];
        [_chooseTopicView addTarget:self action:@selector(doIt:)];
    }
    return _chooseTopicView;
}
-(void)doIt:(ChooseTopicView *)chooseTopicView{
    ChooseTopicController *vc=[[ChooseTopicController alloc] init];
    vc.delegate=self;
    [self.navigationController pushViewController:vc animated:YES];
}
#pragma mark - 开始输入
-(BOOL)textViewShouldBeginEditing:(UITextView *)textView{
    if ([textView.text isEqualToString:TextViewDefaultText]) {
        textView.text = @"";
    }
    textView.textColor = [UIColor blackColor];
    return YES;
}
#pragma mark - 结束输入
-(BOOL)textViewShouldEndEditing:(UITextView *)textView{
    NSString *str = [textView.text stringByReplacingOccurrencesOfString:@" " withString:@""];
    if ([str isEqualToString:@""]) {
        textView.text = TextViewDefaultText;
        textView.textColor = [UIColor lightGrayColor];
    }
    return YES;
}
#pragma mark - textView改变内容后(一般用于计算文本的高度)
-(void)textViewDidChange:(UITextView *)textView{
    //动态计算其高度
    float textHeight = [self heightForString:textView.text fontSize:14 andWidth:textView.frame.size.width];
    if (textHeight<50) textHeight=50;
    if(textHeight<300){
        self.textView.height = textHeight;
        self.imgBox.y=CGRectGetMaxY(_textView.frame)+10;
        _chooseTopicView.y=CGRectGetMaxY(_textView.frame)+20;
        if (_is_album) {
            //_chooseTopicView.y+=self.imgBox.y;
            _chooseTopicView.y=CGRectGetMaxY(self.textView.frame)+_imgBox.height+30;
        }
        
    }
    self.navigationItem.rightBarButtonItem.enabled=![textView.text isEqualToString:@""];
    
}
#pragma mark - 动态计算textView的高度
-(float)heightForString:(NSString *)value fontSize:(float)fontSize andWidth:(float)width{
    UITextView *detailTextView = [[UITextView alloc]initWithFrame:CGRectMake(0, 0, width, 0)];
    detailTextView.font = [UIFont systemFontOfSize:fontSize];
    detailTextView.text = value;
    CGSize deSize = [detailTextView sizeThatFits:CGSizeMake(width,CGFLOAT_MAX)];
    return deSize.height;
}

#pragma mark - 调用图片选择器
- (void)callImagePicker{
    UIImagePickerController *pc = [[UIImagePickerController alloc] init];
    //设置来源类型
    pc.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    if (self.imgBox.subviews.count>=2) {
        pc.mediaTypes = @[@"public.image"];
    }else pc.mediaTypes = @[@"public.image", @"public.movie"];
    pc.allowsEditing = YES;
    pc.delegate = self;
    [self presentViewController:pc animated:YES completion:nil];
}
#pragma mark - 根据图片名称或者图片创建一个新的显示控件
- (UIButton *)createButtonWithImage:(id)imageNameOrImage andSeletor : (SEL)selector{
    UIImage *addImage = nil;
    if ([imageNameOrImage isKindOfClass:[NSString class]]) {
       addImage = [UIImage imageNamed:imageNameOrImage];
    }else if([imageNameOrImage isKindOfClass:[UIImage class]]){
        addImage = imageNameOrImage;
    }
    UIButton *addBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [addBtn setImage:addImage forState:UIControlStateNormal];
    [addBtn addTarget:self action:selector forControlEvents:UIControlEventTouchUpInside];
    return addBtn;
}

#pragma mark - UIImagePickerController 代理方法
-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info{
    NSString *mediaType = info[UIImagePickerControllerMediaType];
    //判断是照片or视频
    //文件path Y-m-d/timestamp.jpg
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];// 创建一个时间格式化对象
    [dateFormatter setDateFormat:@"YYYY-MM-dd"];//设定时间格式,这里可以设置成自己需要的格式
    if ([mediaType isEqualToString:@"public.image"]) {
        UIImage *image = info[UIImagePickerControllerOriginalImage];//UIImagePickerControllerEditedImage
        NSString *filepath=[NSString stringWithFormat:@"joke/%@/%@.jpg", [dateFormatter stringFromDate:[NSDate date]], [NSString stringWithFormat:@"%.0f", [[NSDate date] timeIntervalSince1970]]];
        UIImage *newImg=[self thumbnailImg:image];//压缩
        NSData *fileData=UIImageJPEGRepresentation(newImg, 0.6);
        //压缩
        NSString *path= [[OSS sharedManager] uploadJokeImage:filepath data:fileData];
        if ([path isEqualToString:@""]) {
            NSLog(@"err");
        }else{
            NSLog(@"good:%@", path);
            [self.images addObject:path];
            self.navigationItem.rightBarButtonItem.enabled=YES;
        }
        // 创建一个新的控件
        UIButton *btn = [self createButtonWithImage:image andSeletor:@selector(preview:)];
        [self.imgBox insertSubview:btn atIndex:self.imgBox.subviews.count - 1];//btn添加到+号前面
        //隐藏加号
        if (self.imgBox.subviews.count - 1 == MaxImageCount) {
            [[self.imgBox.subviews lastObject] setHidden:YES];
        }
        //重新设置chooseTopicView的位置Y
        NSInteger count=self.imgBox.subviews.count;
        if (count>9) count=9;
        CGFloat imgBoxheight=ceil((CGFloat)count/3)*(110+12.5);//每行3个，行数*格子高度; 间距是12.5
        self.imgBox.height=imgBoxheight;
        //NSLog(@"图片_imgBox.height:%f", _imgBox.height);
        _chooseTopicView.y=CGRectGetMaxY(self.imgBox.frame)+20;//CGRectGetMaxY(self.textView.frame)+
    }else if ([mediaType isEqualToString:@"public.movie"]){
        self.videoUrl = info[UIImagePickerControllerMediaURL];
        NSLog(@"movieURL:%@", self.videoUrl);
        //判断文件大小
        NSLog(@"[self.videoUrl absoluteString]:%@", [[self.videoUrl absoluteString] substringFromIndex:16]);
        unsigned long long fileSize=[self getVideoInfoWithSourcePath:[[self.videoUrl absoluteString] substringFromIndex:16]];
        NSLog(@"fileSize:%llu", fileSize);
        if (fileSize>0 && fileSize<10*1024*1024) {
            //这里通过视频的url可以做很多事情，比如转化成NSData数据保存、上传等等，不赘述！
            NSString *filepath=[NSString stringWithFormat:@"joke/%@/%@.mp4", [dateFormatter stringFromDate:[NSDate date]], [NSString stringWithFormat:@"%.0f", [[NSDate date] timeIntervalSince1970]]];
            NSString *path= [[OSS sharedManager] uploadJokeVideo:filepath data:self.videoUrl];
            if ([path isEqualToString:@""]) {
                NSLog(@"err");
            }else{
                NSLog(@"good:%@", path);
                self.video=path;
                self.navigationItem.rightBarButtonItem.enabled=YES;
            }
            
            AVAsset *set=[AVAsset assetWithURL:self.videoUrl];//其实是AVURLAsset *set=[AVURLAsset assetWithURL:url]; AVAsset是一个抽象类,不能直接被实例化
            
            //缩略图
            [self thumbnail:set];
            [[self.imgBox.subviews lastObject] setHidden:YES];
        }else{
            //提示
            [SVProgressHUD showErrorWithStatus:@"视频文件不得大于10M"];
            [SVProgressHUD dismissWithDelay:1.0f];
        }
        
    }
    // 退出图片选择控制器
    [picker dismissViewControllerAnimated:YES completion:nil];
}
- (NSInteger)getVideoInfoWithSourcePath:(NSString *)path{
    NSInteger fileSize = [[NSFileManager defaultManager] attributesOfItemAtPath:path error:nil].fileSize;
    return fileSize;
}
/**
 * 图片压缩
 * 宽最大1024，高不限
 * @param original 源图片
 * @return 目标图片
 */
- (UIImage*)thumbnailImg:(UIImage *)original{
    CGSize targetSize=original.size;
    if (original.size.width>1024){
        targetSize.width=1024;
        targetSize.height=(targetSize.width/original.size.width)*original.size.height;
    }
    UIGraphicsBeginImageContext(targetSize); // this will crop
    [original drawInRect:CGRectMake(0, 0, targetSize.width, targetSize.height)];
    UIImage *newImg = UIGraphicsGetImageFromCurrentImageContext();
    if(newImg == nil) NSLog(@"thumbnail生成失败");
    //pop the context to get back to the default
    UIGraphicsEndImageContext();
    return newImg;
}
/**
 imgBtn 视频缩略图
 */
#pragma mark -给缩略图加播放按钮
-(void)createVideoPlayBtn:(UIButton *)imgBtn{
    //播放按钮,缩略图宽高124，这里先写死
    UIButton *btn=[[UIButton alloc] initWithFrame:CGRectMake((110/2)-22, (110/2)-22, 44, 44)];
    [btn setImage:[UIImage imageNamed:@"play"] forState:UIControlStateNormal];

    [btn addTarget:self action:@selector(playVideo) forControlEvents:UIControlEventTouchUpInside];
    //[btn setTitle:@"播放" forState:UIControlStateNormal];
    //btn.backgroundColor=[UIColor lightGrayColor];
    [imgBtn addSubview:btn];//缩略图上添加
}
#pragma mark 播放视频
-(void)playVideo{
    //2.创建待view的播放器
    AVPlayerViewController *playVC=[[AVPlayerViewController alloc] init];
    //3.player，基本上什么操作都要使用它
    playVC.player=[AVPlayer playerWithURL:self.videoUrl];
    //4.播放视频
    [playVC.player play];
    //视频的填充模式
    //AVLayerVideoGravityResizeAspect 是按原视频比例显示，是竖屏的就显示出竖屏的，两边留黑；
    //AVLayerVideoGravityResizeAspectFill 是以原比例拉伸视频，直到两边屏幕都占满，但视频内容有部分就被切割了
    //AVLayerVideoGravityResize 是拉伸视频内容达到边框占满，但不按原比例拉伸，这里明显可以看出宽度被拉伸了。
    playVC.videoGravity = AVLayerVideoGravityResizeAspect;
    //是否显示播放控制条
    playVC.showsPlaybackControls = YES;
    //若想监听视频的操作，设置代理
    //playVC.delegate=self;
    [self showVideoModal:playVC];
}
#pragma mark 展示播放器1:模态对话框,即全屏，不需要frame
-(void)showVideoModal:(AVPlayerViewController *)playVC{
    [self presentViewController:playVC animated:YES completion:nil];
}
#pragma mark 获取视频第一帧
-(void)thumbnail:(AVAsset *)set{
    //3.创建图像生成器
    AVAssetImageGenerator *generator=[[AVAssetImageGenerator alloc] initWithAsset:set];
    //4.生成图像
    /**
        Times:用来表示影片的时间值
        value:帧数
        timescale:当前视频的每秒帧数
     */
    CMTime time=CMTimeMake(5, 1);//每秒1帧，第5帧
    NSValue *value=[NSValue valueWithCMTime:time];
    [generator generateCGImagesAsynchronouslyForTimes:@[value] completionHandler:^(CMTime requestedTime, CGImageRef  _Nullable image, CMTime actualTime, AVAssetImageGeneratorResult result, NSError * _Nullable error) {
        //注意，一定要回到主线程更新ui
        dispatch_sync(dispatch_get_main_queue(), ^{
            UIButton *btn = [self createButtonWithImage:[UIImage imageWithCGImage:image] andSeletor:@selector(preview:)];
            NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];// 创建一个时间格式化对象
            [dateFormatter setDateFormat:@"YYYY-MM-dd"];//设定时间格式,这里可以设置成自己需要的格式
            NSString *path= [[OSS sharedManager] uploadJokeImage:[NSString stringWithFormat:@"joke/%@/%@.jpg", [dateFormatter stringFromDate:[NSDate date]], [NSString stringWithFormat:@"%.0f", [[NSDate date] timeIntervalSince1970]]] data:UIImageJPEGRepresentation([UIImage imageWithCGImage:image], 0.8)];
            if ([path isEqualToString:@""]) {
                NSLog(@"err");
            }else{
                NSLog(@"good:%@", path);
                //[self.images addObject:path];
                self.navigationItem.rightBarButtonItem.enabled=YES;
            }
            
            self.video_thumbnail=path;
            [self.imgBox insertSubview:btn atIndex:self.imgBox.subviews.count - 1];//btn添加到+号前面
            [self createVideoPlayBtn:btn];//给缩略图加播放按钮
        });
    }];
}
-(void)preview:(UIButton *)btn{
    NSLog(@"点击图片预览？");
}
-(void)onControllerResult:(Topic *)field{
    //NSLog(@"来了。。:%@", field);
    _chooseTopicView.field=field;
    self.params[@"topic_id"]=[NSString stringWithFormat:@"%zd", field.id];
}

@end
