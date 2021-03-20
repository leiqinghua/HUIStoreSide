//
//  HLOrderPartRefundCell.m
//  iOS13test
//
//  Created by 雷清华 on 2019/10/30.
//  Copyright © 2019 雷清华. All rights reserved.
//

#import "HLOrderPartRefundCell.h"
#import "HLOrderContentsCell.h"
#import "HLGoodTableCell.h"
#import "HLOrderPriceDescCell.h"

@interface HLOrderPartRefundCell () <UITableViewDelegate, UITableViewDataSource>

@property(nonatomic, strong) UITableView *tableView;

@property(nonatomic, assign) NSInteger rows;

@end

@implementation HLOrderPartRefundCell

- (void)initSubView {
    [super initSubView];
    [self showArrow:false];
    [self.bagView addSubview:self.tableView];
    [self.tableView makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.bagView);
    }];
}

- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc]init];
        _tableView.dataSource = self;
        _tableView.delegate = self;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.showsVerticalScrollIndicator = false;
    }
    return _tableView;
}

- (void)setOrderRefund:(HLOrderPartRefund *)orderRefund {
    _orderRefund = orderRefund;
    _rows = orderRefund.pro.count + 2;
    [self.tableView reloadData];
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _rows;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == _rows -1) {
        HLOrderContentsCell *cell = (HLOrderContentsCell *)[tableView hl_dequeueReusableCellWithIdentifier:@"HLOrderContentsCell" indexPath:indexPath];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.contents = _orderRefund.contents;
        return cell;
    }
    
    if (indexPath.row == _rows - 2) {
        HLOrderPriceDescCell *cell = (HLOrderPriceDescCell *) [tableView hl_dequeueReusableCellWithIdentifier:@"HLOrderPriceDescCell" indexPath:indexPath];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        [cell configUserPrice:_orderRefund.amount store:_orderRefund.s_amount];
        return cell;
    }
    
    HLGoodTableCell *cell = (HLGoodTableCell *)[tableView hl_dequeueReusableCellWithIdentifier:@"HLGoodTableCell" indexPath:indexPath];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.goodModel = _orderRefund.pro[indexPath.row];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == _rows -1) {
        return _orderRefund.contentHight;
    }
    
    if (indexPath.row == _rows - 2) {
        return _orderRefund.priceDesHight;
    }
    
    return _orderRefund.goodHight;
}

@end

