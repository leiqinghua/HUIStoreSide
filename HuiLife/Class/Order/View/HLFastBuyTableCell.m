//
//  HLFastBuyTableCell.m
//  iOS13test
//
//  Created by 雷清华 on 2019/11/18.
//  Copyright © 2019 雷清华. All rights reserved.
//

#import "HLFastBuyTableCell.h"
#import "HLOrderPriceDescView.h"
#import "HLOrderInfoViewCell.h"
#import "HLOrderUserInfoViewCell.h"
#import "HLOrderLRTableCell.h"
#import "HLGoodTableCell.h"
#import "HLOrderContentsCell.h"

@interface HLFastBuyTableCell () <HLOrderOpetionDelegate>

@property (nonatomic, strong) HLFastBuyLayout *fastLayout;

@end

@implementation HLFastBuyTableCell

- (void)initSubView {
    [super initSubView];
    [self.tableView registerClass:[HLOrderPriceDescView class] forHeaderFooterViewReuseIdentifier:@"HLOrderPriceDescView"];
}

#pragma mark - getter
- (void)setOrderLayout:(HLFastBuyLayout *)orderLayout {
    [super setOrderLayout:orderLayout];
    _fastLayout = orderLayout;
    [self.tableView reloadData];
}

#pragma mark - HLOrderOpetionDelegate
- (void)hl_footerViewWithOpenClick:(BOOL)open {
    self.orderLayout.open = open;
    NSIndexSet *set = [[NSIndexSet alloc]initWithIndex:self.orderLayout.stmDesSection];
    
    [UIView animateWithDuration:0 animations:^{
        dispatch_main_async_safe(^{
            [self.tableView reloadSections:set withRowAnimation:UITableViewRowAnimationFade];
        });

    } completion:^(BOOL finished) {
        dispatch_main_async_safe(^{
            if ([self.delegate respondsToSelector:@selector(hl_reloadOrderViewCellHightWithLayout:)]) {
                [self.delegate hl_reloadOrderViewCellHightWithLayout:self.orderLayout];
            }
        });
    }];
}

#pragma mark - HLOrderCellDelegate

- (NSInteger)hl_numberOfSectionsInTableView:(UITableView *)tableView {
    return self.orderLayout.sectionCount;
}

- (NSInteger)hl_tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    if (section == self.orderLayout.stmDesSection ) {
        return self.orderLayout.open ? self.orderLayout.stmRows : 0;
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
       HLOrderUserInfoViewCell  *cell = (HLOrderUserInfoViewCell *) [tableView hl_dequeueReusableCellWithIdentifier:@"HLOrderUserInfoViewCell" indexPath:indexPath];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.orderModel = orderModel;
        return cell;
    }
    
    //商品部分
    if (indexPath.section == self.fastLayout.stmDesSection) {
        //展示 价格说明
        if (orderModel.settlementDes.count && indexPath.row == self.fastLayout.stmRows - 1) {
            HLOrderLRTableCell *cell = (HLOrderLRTableCell *) [tableView hl_dequeueReusableCellWithIdentifier:@"HLOrderLRTableCell" indexPath:indexPath];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.contents = orderModel.settlementDes;
            return cell;
        }
        //显示商品
        HLGoodTableCell *cell = (HLGoodTableCell *) [tableView hl_dequeueReusableCellWithIdentifier:@"HLGoodTableCell" indexPath:indexPath];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.goodModel = orderModel.Info[indexPath.row];
        return cell;
    }
    
    //最后一个 下单信息
    HLOrderContentsCell *cell = (HLOrderContentsCell *)[tableView hl_dequeueReusableCellWithIdentifier:@"HLOrderContentsCell" indexPath:indexPath];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.contents = orderModel.bottomContents;
    return cell;
}


- (CGFloat)hl_tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    HLBaseOrderModel *orderModel = self.orderLayout.orderModel;;
    
    if (indexPath.section == 0) {
        return self.fastLayout.orderInfoHight;
    }
    
    if (indexPath.section == 1) {
        return self.fastLayout.userInfoHight;
    }
    
    if (indexPath.section == self.fastLayout.stmDesSection) {
        //展示 价格说明
        if (orderModel.settlementDes.count && indexPath.row == self.fastLayout.stmRows - 1) {
            return [self.fastLayout calculatePriceDescHight];
        }
        return self.fastLayout.goodsHight;
    }

    return self.fastLayout.bottomHight;
}


- (UIView *)hl_tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    if (section == self.fastLayout.stmDesSection) {
        HLOrderPriceDescView *footer = [tableView dequeueReusableHeaderFooterViewWithIdentifier:@"HLOrderPriceDescView"];
        footer.delegate = self;
        footer.type = HLOrderPriceDescSettleType;
        footer.open = self.orderLayout.open;
        footer.money = self.orderLayout.orderModel.chengjiao_price;
        return footer;
    }
    return nil;
}

- (CGFloat)hl_tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    if (section == self.fastLayout.stmDesSection) {
        return self.fastLayout.footerHight;
    }
    return 0.0;
}

@end
