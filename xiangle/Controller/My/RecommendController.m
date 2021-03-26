//
//  RecommendController.m
//  xiangle
//
//  Created by wei cui on 2020/9/30.
//  Copyright © 2020 wei cui. All rights reserved.
//

#import "RecommendController.h"

@interface RecommendController ()
/** 备注 */
@property (strong, nonatomic) UIView *containerView;
/** 备注 */
@property (strong, nonatomic) UILabel *tipView;
/** 备注 */
@property (strong, nonatomic) UIImageView *qrView;
@end

@implementation RecommendController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor=[UIColor whiteColor];
    self.title=@"推荐给朋友";
    
    [self.view addSubview:self.containerView];
    [self.containerView addSubview:self.qrView];
    [self.containerView addSubview:self.tipView];
}
-(UIView *)containerView{
    if (nil==_containerView) {
        _containerView=[[UIView alloc] initWithFrame:CGRectMake(10, kNavBarAndStatusBarHeight, CWScreenW-20, CWScreenH-kNavBarAndStatusBarHeight)];
    }
    return _containerView;
}
-(UIImageView *)qrView{
    if (nil==_qrView) {
        _qrView=[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"qrcode"]];
        _qrView.frame=CGRectMake((self.containerView.width-100)/2, 100, 100, 100);
    }
    return _qrView;
}
-(UILabel *)tipView{
    if (nil==_tipView) {
        _tipView=[[UILabel alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(_qrView.frame)+10, _containerView.width, 30)];
        _tipView.textAlignment=NSTextAlignmentCenter;
        _tipView.text=@"扫描二维码即可下载";
        _tipView.font=[UIFont systemFontOfSize:14];
    }
    return _tipView;
}

@end
