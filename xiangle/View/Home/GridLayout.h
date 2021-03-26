//
//  GridLayout.h
//  xiangle
//  九宫格布局
//  Created by wei cui on 2020/4/9.
//  Copyright © 2020 wei cui. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface GridLayout : UIView
/**
 *  存储所有的照片images=[
 *  [type=1, image=111, original=11 ],
 *  [type=1, image=111, original=11],
 *  ];
 *
 *  type:只可能一种，要么图片，要么视频
 *  image:缩略图
 *  original原始的，可能是视频，或图片
 */
@property (nonatomic, strong) NSMutableArray *images;
/** 没起作用 */
@property (assign, nonatomic) CGFloat containerHeight;
@end

NS_ASSUME_NONNULL_END
