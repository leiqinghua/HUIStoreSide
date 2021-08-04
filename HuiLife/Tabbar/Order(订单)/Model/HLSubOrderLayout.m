//
//  HLSubOrderLayout.m
//  iOS13test
//
//  Created by 雷清华 on 2019/10/23.
//  Copyright © 2019 雷清华. All rights reserved.
//

#import "HLSubOrderLayout.h"

@implementation HLScanOrderLayout

- (NSInteger)sectionCount {
    HLScanOrderModel *model = (HLScanOrderModel *)self.orderModel;
    if (model.returnInfo.count) {
        return 7;
    }
    return 6;
}

- (NSInteger)stmRows {
    HLScanOrderModel *model = (HLScanOrderModel *)self.orderModel;
    NSInteger rows = self.orderModel.Info.count;
    if (self.orderModel.settlementDes.count) {
        rows += 1;
    }
    if (model.remark.length) {
        rows += 1;
    }
    return rows;
}

- (NSInteger)partSection {
    HLScanOrderModel *model = (HLScanOrderModel *)self.orderModel;
    if (model.returnInfo.count) {
        return 5;
    }
    return -1;
}

- (NSInteger)stmDesSection {
    return 4;
}

- (NSInteger)partRows {
    HLScanOrderModel *model = (HLScanOrderModel *)self.orderModel;
    return model.returnInfo.count;
}

- (CGFloat)footerHight {
    HLScanOrderModel *model = (HLScanOrderModel *)self.orderModel;
    if (model.is_zd == 1 ) {
        return model.s_amount.doubleValue > 0 ? FitPTScreen(83) : FitPTScreen(48);
    }
    return FitPTScreen(54);
}

- (CGFloat)userInfoHight {
    HLScanOrderModel *model = (HLScanOrderModel *)self.orderModel;
    BOOL isSelf = (model.selfTime.length && model.is_send.integerValue == 3);
    if (isSelf && model.mobile.length ) {
        return FitPTScreen(83);
    } else if (!model.mobile.length && !isSelf) {
        return 0.0;
    }
    return FitPTScreen(56);
}

//计算地址的高度
- (CGFloat)caclateAddressHight {
    HLScanOrderModel *model = (HLScanOrderModel *)self.orderModel;
    if (!model.address.length) return 0.0;
    CGSize size = [HLTools attrSizeWithString:model.address lineSpace:1.5 kern:0 font:[UIFont systemFontOfSize:FitPTScreen(14)] width:FitPTScreen(180)];
    return size.height;
}

- (CGFloat)addressHight {
    if (!_addressHight) {
        _addressHight = [self caclateAddressHight] + FitPTScreen(30);
    }
    return _addressHight;
}

- (CGFloat)contactHight {
    HLScanOrderModel *model = (HLScanOrderModel *)self.orderModel;
    if (model.tel.length) {
       return FitPTScreen(56);
    }
    return 0.0;
}

- (CGFloat)fixedHight {
    if (!_fixedHight) {
         HLScanOrderModel *model = (HLScanOrderModel *)self.orderModel;
        CGFloat hight = model.address.length?self.addressHight:self.deskHight;
        return self.orderInfoHight + self.userInfoHight + self.contactHight + self.bottomHight + self.functionHight + hight;
    }
    return _fixedHight;
}

- (CGFloat)deskHight {
     HLScanOrderModel *model = (HLScanOrderModel *)self.orderModel;
    if (model.zhuohao_people_str.length) {
        return FitPTScreen(56);
    }
    return 0;
}

- (CGFloat)remarkHeight {
    HLScanOrderModel *model = (HLScanOrderModel *)self.orderModel;
    if (!model.remark.length) return 0;
    if (!_remarkHeight) {
        _remarkHeight = [HLTools estmateHightString:model.remark Font:[UIFont systemFontOfSize:FitPTScreen(14)] lineSpace:5 maxWidth:FitPTScreen(250)] + FitPTScreen(30);
    }
    return _remarkHeight;
}

/// 计算tableview的高度
- (CGFloat)tableHight {
    HLScanOrderModel *model = (HLScanOrderModel *)self.orderModel;
    CGFloat tableHight = self.fixedHight;
    if (self.open) { //展开
        tableHight += model.Info.count * self.goodsHight ;
        //加上价格描述的高度
        tableHight += [self calculatePriceDescHight];
        //加上 备注高度
        tableHight += self.remarkHeight;
    }
    //如果是整单退款，要+83的footer高度，其他的+54 footer高度
    tableHight += self.footerHight;
    //查看是不是有部分退款
    if (!model.returnInfo.count) return tableHight;
    //如果有部分退款,判断是否展开两种状态
    if (self.partOpen) { //展开
        for (HLOrderPartRefund *part in model.returnInfo) {
            tableHight += part.totleHight;
        }
    }
    //header的高度
    tableHight += FitPTScreen(54);
    return tableHight;
}

@end

@implementation HLConShopLayout

@end

@implementation HLSpikeBuyLayout

- (NSInteger)stmRows {
   NSInteger rows = self.orderModel.Info.count;
    if (self.orderModel.settlementDes.count) {
        rows += 1;
    }
    return rows;
}

- (CGFloat)footerHight {
    return FitPTScreen(54);
}

///// 计算 显示电话地址的高度
//- (void)calculateUserInfoHight {
//    if (self.orderModel.mobile.length) {
//        self.userInfoHight = FitPTScreen(56);
//    }
//}

/// 计算tableview的高度
- (CGFloat)tableHight {
    HLSpikeBuyModel *model = (HLSpikeBuyModel *)self.orderModel;
    CGFloat tableHight = self.orderInfoHight + self.userInfoHight + self.bottomHight + self.functionHight;
    if (self.open) { //展开
        tableHight += model.Info.count * self.goodsHight ;
        //加上价格描述的高度
        tableHight += [self calculatePriceDescHight];
    }
    //如果是整单退款，要+83的footer高度，其他的+54 footer高度
    tableHight += self.footerHight;
    return tableHight;
}

@end

@implementation HLPreferentialLayout

- (NSInteger)stmRows {
    return 1;
}

- (CGFloat)footerHight {
    return FitPTScreen(54);
}

/// 计算tableview的高度
- (CGFloat)tableHight {
    CGFloat tableHight = self.orderInfoHight + self.userInfoHight + self.bottomHight + self.functionHight;
    if (self.open) { //展开
        //加上价格描述的高度
        tableHight += [self calculatePriceDescHight];
    }
    //如果是整单退款，要+83的footer高度，其他的+54 footer高度
    tableHight += self.footerHight;
    return tableHight;
}

@end

@implementation HLCarServiceLayout


/// 计算tableview的高度
- (CGFloat)tableHight {
    CGFloat tableHight = self.orderInfoHight + self.userInfoHight + self.bottomHight + self.functionHight;
    tableHight += self.orderModel.Info.count * self.goodsHight;
    return tableHight;
}

- (NSInteger)stmRows {
    return self.orderModel.Info.count;
}

@end

@implementation HLFastBuyLayout

- (NSInteger)stmRows {
    NSInteger rows = self.orderModel.Info.count;
    if (self.orderModel.settlementDes.count) {
        rows += 1;
    }
    return rows;
}

- (CGFloat)footerHight {
    return FitPTScreen(54);
}

/// 计算tableview的高度
- (CGFloat)tableHight {
    HLFastBuyModel *model = (HLFastBuyModel *)self.orderModel;
    CGFloat tableHight = self.orderInfoHight + self.userInfoHight + self.bottomHight + self.functionHight;
    if (self.open) { //展开
        tableHight += model.Info.count * self.goodsHight ;
        //加上价格描述的高度
        tableHight += [self calculatePriceDescHight];
    }
    
    tableHight += self.footerHight;
    
    return tableHight;
}

@end

@implementation HLDiscountBuyLayout

- (NSInteger)stmRows {
    NSInteger rows = self.orderModel.Info.count;
    if (self.orderModel.settlementDes.count) {
        rows += 1;
    }
    return rows;
}

- (CGFloat)footerHight {
    return FitPTScreen(54);
}


/// 计算tableview的高度
- (CGFloat)tableHight {
    HLDiscountBuyModel *model = (HLDiscountBuyModel *)self.orderModel;
    CGFloat tableHight = self.orderInfoHight + self.userInfoHight + self.bottomHight + self.functionHight;
    if (self.open) { //展开
        tableHight += model.Info.count * self.goodsHight;
        //加上价格描述的高度
        tableHight += [self calculatePriceDescHight];
    }
    tableHight += self.footerHight;
    return tableHight;
}

@end

@implementation HLVoucherBuyLayout

- (NSInteger)stmRows {
    NSInteger rows = self.orderModel.Info.count;
    if (self.orderModel.settlementDes.count) {
        rows += 1;
    }
    return rows;
}

- (CGFloat)footerHight {
    return FitPTScreen(54);
}

/// 计算tableview的高度
- (CGFloat)tableHight {
    HLVoucherBuyModel *model = (HLVoucherBuyModel *)self.orderModel;
    CGFloat tableHight = self.orderInfoHight + self.userInfoHight + self.bottomHight + self.functionHight;
    if (self.open) { //展开
        tableHight += model.Info.count * self.goodsHight;
        //加上价格描述的高度
        tableHight += [self calculatePriceDescHight];
    }
    tableHight += self.footerHight;
    return tableHight;
}

@end

@implementation HLNumberCardLayout

- (NSInteger)stmRows {
    NSInteger rows = self.orderModel.Info.count;
    if (self.orderModel.settlementDes.count) {
        rows += 1;
    }
    return rows;
}

- (CGFloat)footerHight {
    return FitPTScreen(54);
}

/// 计算tableview的高度
- (CGFloat)tableHight {
    HLNumberCardModel *model = (HLNumberCardModel *)self.orderModel;
    CGFloat tableHight = self.orderInfoHight + self.userInfoHight + self.bottomHight + self.functionHight;
    if (self.open) { //展开
        tableHight += model.Info.count * self.goodsHight;
        //加上价格描述的高度
        tableHight += [self calculatePriceDescHight];
    }
    tableHight += self.footerHight;
    return tableHight;
}

@end

//hui卡（5）
@implementation HLHUICardLayout

- (NSInteger)stmRows {
    NSInteger rows = self.orderModel.Info.count;
    if (self.orderModel.settlementDes.count) {
        rows += 1;
    }
    return rows;
}

- (CGFloat)footerHight {
    return FitPTScreen(54);
}

/// 计算tableview的高度
- (CGFloat)tableHight {
    HLHUICardModel *model = (HLHUICardModel *)self.orderModel;
    CGFloat tableHight = self.orderInfoHight + self.userInfoHight + self.bottomHight + self.functionHight;
    if (self.open) { //展开
        tableHight += model.Info.count * self.goodsHight;
        //加上价格描述的高度
        tableHight += [self calculatePriceDescHight];
    }
    tableHight += self.footerHight;
    return tableHight;
}
@end


//爆款 44
@implementation HLHotShopLayout

@end

//秒杀拼团
@implementation HLSpikeGroupLayout

@end

