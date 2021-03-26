//
//  TableViewDataSource.h
//  TableViewDataSource
//
//  Created by hibo on 2019/6/10.
//  Copyright © 2019 hibo. All rights reserved.
//

#import "TableViewDataSource.h"


@interface TableViewDataSource ()

@property(nonatomic, strong) NSArray* cells;
@property(nonatomic, copy) NSString* identifier;
@property(nonatomic, copy) TableViewCellBlock cellBlock;
@property(nonatomic, assign) BOOL isGrouped;//是否为数组样式

@end

@implementation TableViewDataSource

#pragma mark - source初始化将主要参数引出在主视图中处理数据展示
-(instancetype)initWithData:(NSArray *)data identifier:(NSString *)identifier cellBlock:(TableViewCellBlock)cellBlock {
    self = [super init];
    if (self) {
        self.data = data;
        self.identifier = identifier;
        self.cellBlock = cellBlock;
    }
    return self;
}
-(void)setData:(NSArray *)data{
    _data = data;
    self.isGrouped = NO;
    if (data.firstObject) {
        if ([data.firstObject isKindOfClass:[NSArray class]]) {
            self.isGrouped = YES;
        }
    }
}

#pragma mark - 实现代理方法
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    if (self.data.count==0) {
        return 0;
    }else{
        return self.isGrouped?self.data.count:1;
    }
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.isGrouped?[self.data[section] count]:self.data.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:self.identifier];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    id field = self.data[indexPath.row];
    //NSLog(@"cell1 subviews:%@", cell.contentView.subviews);
    self.cellBlock(cell, field, indexPath);
    //NSLog(@"cell2 subviews:%@", cell.contentView.subviews);
    return cell;
}
@end

#pragma mark - 实现头视图、尾视图、头视图高度、尾视图高度的代理方法，将参数引出在主视图中获取
@interface TableViewDelegate ()
@property(nonatomic, copy) TableViewRowHeightBlock rowHeightBlock;
@property(nonatomic, copy) TableViewHeaderHeightBlock headerHeightBlock;
@property(nonatomic, copy) TableViewFooterHeightBlock footerHeightBlock;
@property(nonatomic, copy) TableViewHeaderBlock headerBlock;
@property(nonatomic, copy) TableViewFooterBlock footerBlock;

@property(nonatomic, copy) TableViewDidBlock didSelect;
@end

@implementation TableViewDelegate

//初始化行高、组高、头视图、尾部视图
-(instancetype)initWithRowHeight:(TableViewRowHeightBlock) rowHeightBlock
                    headerHeight:(TableViewHeaderHeightBlock)headerHeightBlock
                    footerHeight:(TableViewFooterHeightBlock)footerHeightBlock
                          header:(TableViewHeaderBlock)headerBlock
                          footer:(TableViewFooterBlock)footerBlock
                       didSelect:(TableViewDidBlock)didSelect{
    self = [super init];
    if (self) {
        self.rowHeightBlock = rowHeightBlock;
        self.headerHeightBlock = headerHeightBlock;
        self.footerHeightBlock = footerHeightBlock;
        self.headerBlock = headerBlock;
        self.footerBlock = footerBlock;
        self.didSelect = didSelect;
    }
    return self;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (self.rowHeightBlock) {
        return self.rowHeightBlock(indexPath);
    }
    return 0;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (self.headerHeightBlock) {
        return self.headerHeightBlock(section);
    }
    return 0;
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    if (self.footerHeightBlock) {
        return self.footerHeightBlock(section);
    }
    return 0;
}
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    if (self.headerBlock) {
        return self.headerBlock(section);
    }
    return nil;
}
-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    if (self.footerBlock) {
        return self.footerBlock(section);
    }
    return nil;
}
#pragma mark - 点击某个cell时调用
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (self.didSelect) {
        UIViewController *vc=[[UIViewController alloc] init];
        self.didSelect(vc, indexPath);
    }
}
@end
