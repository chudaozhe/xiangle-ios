//
//  TableViewDataSource.h
//  TableViewDataSource
//
//  Created by hibo on 2019/6/10.
//  Copyright © 2019 hibo. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

typedef void (^TableViewCellBlock)(id _Nonnull cell, id _Nullable field, NSIndexPath *_Nullable indexPath);

typedef void (^TableViewDidBlock)(id _Nonnull vc, NSIndexPath *_Nullable indexPath);
NS_ASSUME_NONNULL_BEGIN

#pragma mark - 数据源
@interface TableViewDataSource : NSObject<UITableViewDataSource>
@property (nonatomic,strong)NSArray *data;//数据源

#pragma mark - source初始化将主要参数引出在主视图中处理数据展示
-(instancetype)initWithData:(NSArray *)dataArr identifier:(NSString *)identifier cellBlock:(TableViewCellBlock)cellBlock;
@end

NS_ASSUME_NONNULL_END

//获取行高
typedef CGFloat (^TableViewRowHeightBlock)(NSIndexPath *_Nullable indexPath);
//获取头视图高
typedef CGFloat (^TableViewHeaderHeightBlock)(NSInteger section);
//获取尾视图高
typedef CGFloat (^TableViewFooterHeightBlock)(NSInteger section);
//获取头视图view
typedef UIView *_Nullable(^TableViewHeaderBlock)(NSInteger section);
//获取尾部试图view
typedef UIView *_Nullable(^TableViewFooterBlock)(NSInteger section);

#pragma mark - 代理
@interface TableViewDelegate : NSObject<UITableViewDelegate>

//初始化行高、组高、头视图、尾部视图
-(_Nonnull instancetype)initWithRowHeight:(_Nonnull TableViewRowHeightBlock) rowHeightBlock
                    headerHeight:(_Nullable TableViewHeaderHeightBlock) headerHeightBlock
                    footerHeight:(_Nullable TableViewFooterHeightBlock) footerHeightBlock
                          header:(_Nullable TableViewHeaderBlock) headerBlock
                          footer:(_Nullable TableViewFooterBlock) footerBlock
                       didSelect:(_Nullable TableViewDidBlock) didSelect;
@end
