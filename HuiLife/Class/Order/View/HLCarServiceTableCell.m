//
//  HLCarServiceTableCell.m
//  iOS13test
//
//  Created by 雷清华 on 2019/11/18.
//  Copyright © 2019 雷清华. All rights reserved.
//

#import "HLCarServiceTableCell.h"
#import "HLOrderInfoViewCell.h"
#import "HLOrderCarTableCell.h"
#import "HLOrderContentsCell.h"
#import "HLOrderUserInfoViewCell.h"

@interface HLCarServiceTableCell ()

@property (nonatomic, strong) HLCarServiceLayout *carLayout;

@end

@implementation HLCarServiceTableCell

#pragma mark - getter
- (void)setOrderLayout:(HLCarServiceLayout *)orderLayout {
    [super setOrderLayout:orderLayout];
    _carLayout = orderLayout;
    [self.tableView reloadData];
}

#pragma mark - HLOrderCellDelegate

- (NSInteger)hl_numberOfSectionsInTableView:(UITableView *)tableView {
    return self.orderLayout.sectionCount;
}

- (NSInteger)hl_tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    if (section == self.orderLayout.stmDesSection ) {
        return self.orderLayout.stmRows;
    }
    return 1;
}

- (UITableViewCell *)hl_tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    HLBaseOrderModel *orderModel = self.orderLayout.orderModel;
    
    if (indexPath.section == 0) { //订单信息
        HLOrderInfoViewCell *cell = (HLOrderInfoViewCell *) [tableView hl_dequeueReusableCellWithIdentifier:@"HLOrderInfoViewCell" indexPath:indexPath];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.orderModel = orderModel;
        return cell;
    }
    
    if (indexPath.section == 1) { //用户信息
        HLOrderUserInfoViewCell *cell = (HLOrderUserInfoViewCell *) [tableView hl_dequeueReusableCellWithIdentifier:@"HLOrderUserInfoViewCell" indexPath:indexPath];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.orderModel = orderModel;
        return cell;
    }
    
    //商品部分
    if (indexPath.section == self.orderLayout.stmDesSection) {
        //显示商品
        HLOrderCarTableCell *cell = (HLOrderCarTableCell *) [tableView hl_dequeueReusableCellWithIdentifier:@"HLOrderCarTableCell" indexPath:indexPath];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.carModel = orderModel.Info[indexPath.row];
        return cell;
    }

    //最后一个 下单信息
    HLOrderContentsCell *cell = (HLOrderContentsCell *)[tableView hl_dequeueReusableCellWithIdentifier:@"HLOrderContentsCell" indexPath:indexPath];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.contents = orderModel.bottomContents;
    return cell;
}


- (CGFloat)hl_tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.section == 0) {
        return self.orderLayout.orderInfoHight;
    }
    
    if (indexPath.section == 1) {
        return self.orderLayout.userInfoHight;
    }
    
    if (indexPath.section == self.orderLayout.stmDesSection) {
        return self.orderLayout.goodsHight;
    }
    
    return self.orderLayout.bottomHight;
}


@end
