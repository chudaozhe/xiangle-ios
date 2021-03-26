//
//  ImageBrowser.h
//  xiangle
//
//  Created by wei cui on 2020/3/26.
//  Copyright © 2020 wei cui. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface ImageBrowser : NSObject
/** 备注 */
@property (strong, nonatomic) NSArray *data;
//当前第几张图片
+(void)showImage:(NSInteger)i;
+(void)setData:(NSArray *)data;

@end

NS_ASSUME_NONNULL_END
