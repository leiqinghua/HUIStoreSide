//
//  HLOrderScanTableCell.m
//  iOS13test
//
//  Created by 雷清华 on 2019/10/27.
//  Copyright © 2019 雷清华. All rights reserved.
//

#import "HLOrderScanTableCell.h"
#import "HLOrderInfoViewCell.h"
#import "HLOrderUserInfoViewCell.h"
#import "HLGoodTableCell.h"
#import "HLOrderLRTableCell.h"
#import "HLOrderContentsCell.h"
#import "HLOrderPartRefundCell.h"
#import "HLOrderPriceDescFooter.h"
#import "HLOrderPriceDescView.h"
#import "HLOrderPartHeader.h"
#import "HLOrderAddressViewCell.h"
#import "HLOrderContactViewCell.h"
#import "HLOrderImgLbViewCell.h"
#import "HLOrderRemarkCell.h"

@interface HLOrderScanTableCell ()<HLOrderOpetionDelegate, HLOrderAddressDelegate>

@property (nonatomic, strong) HLScanOrderLayout *scanLayout;

@end

@implementation HLOrderScanTableCell

- (void)initSubView {
    [super initSubView];
    [self.tableView registerClass:[HLOrderPartHeader class] forHeaderFooterViewReuseIdentifier:@"HLOrderPartHeader"];
    [self.tableView registerClass:[HLOrderPriceDescFooter class] forHeaderFooterViewReuseIdentifier:@"HLOrderPriceDescFooter"];
    [self.tableView registerClass:[HLOrderPriceDescView class] forHeaderFooterViewReuseIdentifier:@"HLOrderPriceDescView"];
}

#pragma mark - getter
- (void)setOrderLayout:(HLScanOrderLayout *)orderLayout {
    [super setOrderLayout:orderLayout];
    _scanLayout = orderLayout;
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

//点击部分退款
- (void)hl_headerViewWithOpenClick:(BOOL)open {
    self.scanLayout.partOpen = open;
    NSIndexSet *set = [[NSIndexSet alloc]initWithIndex:self.scanLayout.partSection];
    
    [UIView animateWithDuration:0.3 animations:^{
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

#pragma mark - HLOrderAddressDelegate
- (void)hl_addressCellClickToNavigatePage {
    if ([self.delegate respondsToSelector:@selector(hl_goToNavigatePageWithLayout:)]) {
        [self.delegate hl_goToNavigatePageWithLayout:self.orderLayout];
    }
}

#pragma mark - HLOrderCellDelegate

- (NSInteger)hl_numberOfSectionsInTableView:(UITableView *)tableView {
    return self.orderLayout.sectionCount;
}

- (NSInteger)hl_tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    if (section == self.orderLayout.stmDesSection ) {
        return self.orderLayout.open ? self.orderLayout.stmRows : 0;
    }
    
    if (section == self.scanLayout.partSection && self) {
        return  self.scanLayout.partOpen ? self.scanLayout.partRows : 0;
    }
    
    return 1;
}

- (UITableViewCell *)hl_tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    HLScanOrderModel *scanModel = (HLScanOrderModel *)self.scanLayout.orderModel;
    if (indexPath.section == 0) { //订单信息
        HLOrderInfoViewCell *cell = (HLOrderInfoViewCell *) [tableView hl_dequeueReusableCellWithIdentifier:@"HLOrderInfoViewCell" indexPath:indexPath];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.orderModel = scanModel;
        return cell;
    }
    
    if (indexPath.section == 1) { //用户信息
        HLOrderUserInfoViewCell *cell = (HLOrderUserInfoViewCell *) [tableView hl_dequeueReusableCellWithIdentifier:@"HLOrderUserInfoViewCell" indexPath:indexPath];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.orderModel = scanModel;
        return cell;
    }
    
    //    地址 或自提
    if (indexPath.section == 2) {
        
        if (scanModel.address.length) {
            HLOrderAddressViewCell *cell = (HLOrderAddressViewCell *) [tableView hl_dequeueReusableCellWithIdentifier:@"HLOrderAddressViewCell" indexPath:indexPath];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.delegate = self;
            cell.orderModel = scanModel;
            return cell;
        }
        
        HLOrderImgLbViewCell *cell = (HLOrderImgLbViewCell *) [tableView hl_dequeueReusableCellWithIdentifier:@"HLOrderImgLbViewCell" indexPath:indexPath];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.tip = scanModel.peisong_money_str;
        cell.tipImgUrl = scanModel.zhuohao_people_pic;
        
        // 高度为 0 时，隐藏内部视图
        [cell controlSubViewsHidden:self.scanLayout.deskHight == 0];
        return cell;
    }
    
    if (indexPath.section == 3) {
        HLOrderContactViewCell *cell = (HLOrderContactViewCell *) [tableView hl_dequeueReusableCellWithIdentifier:@"HLOrderContactViewCell" indexPath:indexPath];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.orderModel = scanModel;
        return cell;
    }
    
    //商品部分
    if (indexPath.section == self.scanLayout.stmDesSection) {
        
        if (scanModel.remark.length && indexPath.row == 0) { //返回备注信息
            HLOrderRemarkCell *cell = (HLOrderRemarkCell *) [tableView hl_dequeueReusableCellWithIdentifier:@"HLOrderRemarkCell" indexPath:indexPath];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.title = @"订单备注：";
            cell.contentAttr = scanModel.remarkAttr;
            return cell;
        }
        //展示 价格说明
        if (scanModel.settlementDes.count && indexPath.row == self.scanLayout.stmRows - 1) {
            HLOrderLRTableCell *cell = (HLOrderLRTableCell *) [tableView hl_dequeueReusableCellWithIdentifier:@"HLOrderLRTableCell" indexPath:indexPath];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.contents = scanModel.settlementDes;
            return cell;
        }
        //显示商品
        HLGoodTableCell *cell = (HLGoodTableCell *) [tableView hl_dequeueReusableCellWithIdentifier:@"HLGoodTableCell" indexPath:indexPath];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.goodModel = scanModel.Info[indexPath.row];
        return cell;
    }
    
    if (indexPath.section == self.scanLayout.partSection) {
        //部分退款cell
        HLOrderPartRefundCell *cell = (HLOrderPartRefundCell *)[tableView hl_dequeueReusableCellWithIdentifier:@"HLOrderPartRefundCell" indexPath:indexPath];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.orderRefund = scanModel.returnInfo[indexPath.row];
        return cell;
    }
    
    //最后一个 下单信息
    HLOrderContentsCell *cell = (HLOrderContentsCell *)[tableView hl_dequeueReusableCellWithIdentifier:@"HLOrderContentsCell" indexPath:indexPath];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.contents = scanModel.bottomContents;
    return cell;
}


- (CGFloat)hl_tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    HLScanOrderModel *scanModel = (HLScanOrderModel *)self.scanLayout.orderModel;
    
    if (indexPath.section == 0) {
        return self.scanLayout.orderInfoHight;
    }
    
    if (indexPath.section == 1) {
        return self.scanLayout.userInfoHight;
    }
    
    if (indexPath.section == 2) {
        if (scanModel.address.length) {
           return self.scanLayout.addressHight;
        }
        return self.scanLayout.deskHight;
    }
    
    if (indexPath.section == 3) {
        return self.scanLayout.contactHight;
    }
    
    if (indexPath.section == self.scanLayout.stmDesSection) {
//        备注
        if (scanModel.remark.length && indexPath.row == 0) {
            return self.scanLayout.remarkHeight;
        }
        //展示 价格说明
        if (scanModel.settlementDes.count && indexPath.row == self.scanLayout.stmRows - 1) {
            return [self.scanLayout calculatePriceDescHight];
        }
        return self.scanLayout.goodsHight;
    }
    
    if (indexPath.section == self.scanLayout.partSection) {
        HLOrderPartRefund *partRefund = scanModel.returnInfo[indexPath.row];
        return partRefund.totleHight;
    }
    
    return self.scanLayout.bottomHight;
}

- (UIView *)hl_tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    
    if (section == self.scanLayout.partSection) {
        HLOrderPartHeader *header = [tableView dequeueReusableHeaderFooterViewWithIdentifier:@"HLOrderPartHeader"];
        header.delegate = self;
        header.partOpen = self.scanLayout.partOpen;
        return header;
    }
    return nil;
}

- (UIView *)hl_tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    HLScanOrderModel *scanModel = (HLScanOrderModel *)self.scanLayout.orderModel;
    if (section == self.scanLayout.stmDesSection) {
        if (scanModel.is_zd == 1) { //整单退款
            HLOrderPriceDescFooter *footer = [tableView dequeueReusableHeaderFooterViewWithIdentifier:@"HLOrderPriceDescFooter"];
            [footer configUserPrice:scanModel.amount storePrice:scanModel.s_amount];
            footer.isOpen = self.scanLayout.open;
            footer.delegate = self;
            return footer;
        }
        HLOrderPriceDescView *footer = [tableView dequeueReusableHeaderFooterViewWithIdentifier:@"HLOrderPriceDescView"];
        footer.delegate = self;
        footer.type = HLOrderPriceDescSettleType;
        footer.open = self.orderLayout.open;
        footer.money = scanModel.chengjiao_price;
        return footer;
    }
    return nil;
}

- (CGFloat)hl_tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    if (section == self.scanLayout.stmDesSection) {
        return self.scanLayout.footerHight;
    }
    return 0.0;
}

- (CGFloat)hl_tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (section == self.scanLayout.partSection) {
        return FitPTScreen(54);
    }
    return 0.0;
}

@end


