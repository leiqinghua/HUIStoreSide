//
//  HLSubOrderModel.m
//  iOS13test
//
//  Created by 雷清华 on 2019/10/22.
//  Copyright © 2019 雷清华. All rights reserved.
//

#import "HLSubOrderModel.h"

@implementation HLScanOrderModel

+ (NSDictionary *)mj_objectClassInArray {
    return @{
        @"Info": @"HLOrderGoodModel",
        @"returnInfo": @"HLOrderPartRefund",
    };
}

- (NSString *)contactTip {
    if (self.is_send.integerValue == 3) {
        return @"自提人：";
    }
    return @"收货人：";
}

- (NSAttributedString *)remarkAttr {
    if (!self.remark.length) return nil;
    if (!_remarkAttr) {
        NSMutableParagraphStyle *style = [[NSMutableParagraphStyle alloc]init];
        style.lineSpacing = 5;
        _remarkAttr = [[NSAttributedString alloc]initWithString:self.remark attributes:@{NSParagraphStyleAttributeName:style}];
    }
    return _remarkAttr;
}

- (NSMutableArray *)settlementDes {
    NSMutableArray *contents = [NSMutableArray array];
    if (![self emptyWithMoney:self.pay_price]) {
        NSDictionary * dict = @{@"key":@"商品总额",@"value":[NSString stringWithFormat:@"%@",[self addMoneySymbolWithMoney:self.pay_price]]};
        [contents addObject:dict];
    }
    
    if (![self emptyWithMoney:self.commission]) {
        NSDictionary * dict = @{@"key":self.commission_str,@"value":[NSString stringWithFormat:@"-%@",[self addMoneySymbolWithMoney:self.commission]]};
        [contents addObject:dict];
    }
    
    if (![self emptyWithMoney:self.distribution_money]) {
        NSDictionary * dict = @{@"key":self.distribution_str,@"value":[NSString stringWithFormat:@"%@",[self addMoneySymbolWithMoney:self.distribution_money]]};
        [contents addObject:dict];
    }
    
    //    排单费
    if (![self emptyWithMoney:self.dispatch_fee_money]) {
        NSDictionary * dict = @{@"key":_dispatch_fee_money_str,@"value":[NSString stringWithFormat:@"%@",[self addMoneySymbolWithMoney:self.dispatch_fee_money]]};
        [contents addObject:dict];
    }
    //    外卖折扣
    if (_take_away_discount.floatValue != 10 && _take_away_discount.floatValue) {
        NSDictionary * dict = @{@"key":_take_away_discount_str,@"value":[NSString stringWithFormat:@"%@",_take_away_discount]};
        [contents addObject:dict];
    }
    //    运送费
    if (![self emptyWithMoney:self.freight_coupon_money]) {
        NSDictionary * dict = @{@"key":_freight_coupon_money_str,@"value":[NSString stringWithFormat:@"%@",[self addMoneySymbolWithMoney:self.freight_coupon_money]]};
        [contents addObject:dict];
    }
    
    if (self.discount_act.count >0) {
        for (NSDictionary * dict in self.discount_act) {
            NSDictionary * data = @{@"key":dict[@"name"],@"value":dict[@"price"]};
            [contents addObject:data];
        }
    }
    
    if (![self emptyWithMoney:self.peisong_money]) {
        NSDictionary * dict = @{@"key":self.peisong_money_str,@"value":[NSString stringWithFormat:@"%@",[self addMoneySymbolWithMoney:self.peisong_money]]};
        [contents addObject:dict];
    }
    
    if (![self emptyWithMoney:self.coupon_money]) {
        NSDictionary * dict = @{@"key":self.coupon_money_str,@"value":[NSString stringWithFormat:@"%@",[self addMoneySymbolWithMoney:self.coupon_money]]};
        [contents addObject:dict];
    }
    
    if (![self emptyWithMoney:self.ziti_money]) {
        NSDictionary * dict = @{@"key":self.ziti_money_str,@"value":[NSString stringWithFormat:@"%@",[self addMoneySymbolWithMoney:self.ziti_money]]};
        [contents addObject:dict];
    }
    
    if (![self emptyWithMoney:self.pack_money]) {
        NSDictionary * dict = @{@"key":self.pack_money_str,@"value":[NSString stringWithFormat:@"%@",[self addMoneySymbolWithMoney:self.pack_money]]};
        [contents addObject:dict];
    }
    
    if (![self emptyWithMoney:self.redbag]) {
        NSDictionary * dict = @{@"key":@"红包优惠",@"value":[NSString stringWithFormat:@"-%@",[self addMoneySymbolWithMoney:self.pack_money]]};
        [contents addObject:dict];
    }
    
    return contents;
}

- (NSMutableArray *)bottomContents {
    NSMutableArray *contents = [NSMutableArray array];
    if (self.storeName.length) {
        [contents addObject:[NSString stringWithFormat:@"下单门店：%@",self.storeName]];
    }
    
    if (self.is_zd != 1) { //除了整单退款
        if (self.input_time.length) {
            [contents addObject:[NSString stringWithFormat:@"下单时间：%@",self.input_time]];
        }
        return contents;
    }
    //整单退款
    if (self.return_reason.length) {
        [contents addObject:[NSString stringWithFormat:@"退款原因：%@", self.return_reason]];
    }
    
    if (self.succed_time.length) {
        [contents addObject:[NSString stringWithFormat:@"退款时间： %@", self.succed_time]];
    }
    
    [contents addObject:[NSString stringWithFormat:@"退款单号：%@", self.returnId]];
    
    return contents;
}


- (NSArray *)functions {
    if (_is_zd == 1) return nil;
    NSMutableArray *functions = [NSMutableArray array];
    if ([self.state isEqualToString:@"待处理"]) {
        if (_is_dispatch) { //开启配送 走新的，否则保留之前
            NSString *tipImg = _dispatch_state == 1?@"djs_grey":@"order_yjd";
            [functions addObject:@{@"tipImg":tipImg,@"funTitle":_dispatch_state_info?:@""}];
            [functions addObject:@{@"tipImg":@"printe_tip",@"funTitle":@"打印"}];
        } else if (_is_send.intValue == 3) {
            [functions addObject:@{@"tipImg":@"deliever_tip",@"funTitle":@"已自提"}];
            [functions addObject:@{@"tipImg":@"printe_tip",@"funTitle":@"打印"}];
        } else if (_is_send.intValue == 0) {
            [functions addObject:@{@"tipImg":@"deliever_tip",@"funTitle":@"配送"}];
            [functions addObject:@{@"tipImg":@"printe_tip",@"funTitle":@"打印"}];
        } else {
            [functions addObject:@{@"tipImg":@"tk_tip",@"funTitle":@"退款"}];
            [functions addObject:@{@"tipImg":@"printe_tip",@"funTitle":@"打印"}];
        }
        
        return functions;
    }
    
    if ([self.state isEqualToString:@"配送中"]) {
        
        if (_is_dispatch) { //开启外卖
            [functions addObject:@{@"tipImg":@"order_yjding",@"funTitle":_dispatch_state_info?:@""}];
            [functions addObject:@{@"tipImg":@"arrive_tip",@"funTitle":@"送达"}];
        } else {
            [functions addObject:@{@"tipImg":@"tk_tip",@"funTitle":@"退款"}];
            [functions addObject:@{@"tipImg":@"arrive_tip",@"funTitle":@"送达"}];
        }
        return functions;
    }
    
    [functions addObject:@{@"tipImg":@"tk_tip",@"funTitle":@"退款"}];
    [functions addObject:@{@"tipImg":@"printe_tip",@"funTitle":@"打印"}];
    
    return functions;
}

- (NSInteger)dispatchType {
    if ([_dispatch_state_info isEqualToString:@"骑手配送中"]) {
        return 0;
    }
    
    if ([_dispatch_state_info isEqualToString:@"骑手已接单"]) {
        return 1;
    }
    return -1;
}

//- (NSString *)remark {
//    return @"这个达克赛德净空法师jdk放暑假了大幅叫开放DNF啥的饭卡都解封肺积水两地分居卡萨丁发发送到连副科级啊啥地方";
//}
@end


/// 商超
@implementation HLConShopModel

- (NSMutableArray *)settlementDes {
    NSMutableArray *settlements = [super settlementDes];
    if (![self emptyWithMoney:self.sum_money]) {
        NSDictionary * dict = @{@"key":@"商品原价",@"value":[NSString stringWithFormat:@"%@",[self addMoneySymbolWithMoney:self.sum_money]]};
        [settlements insertObject:dict atIndex:0];
    }
    
    if (![self emptyWithMoney:self.sj_pay_price]) {
        NSDictionary * dict = @{@"key":@"实付金额",@"value":[NSString stringWithFormat:@"%@",[self addMoneySymbolWithMoney:self.sj_pay_price]]};
        [settlements addObject:dict];
    }
    return settlements;
}



- (NSAttributedString *)tipAttr {
    NSString *text = @"";
    if (self.address.length) {
        text = [NSString stringWithFormat:@"配送地址：%@",self.address];
    }
    NSRange range = [text rangeOfString:@"："];
    NSMutableAttributedString *mutrr = [[NSMutableAttributedString alloc]initWithString:text attributes:@{NSForegroundColorAttributeName:UIColorFromRGB(0x555555)}];
    [mutrr addAttributes:@{NSForegroundColorAttributeName:UIColorFromRGB(0x868686)} range:range];
    return mutrr;
}

- (NSString *)zhuohao_people_pic {
    return nil; //强制置空
}

- (NSString *)zhuohao_people_str {
    return nil;//强制置空
}

- (NSArray *)functions {
    if (self.is_zd == 1) return nil;
    NSMutableArray *functions = [NSMutableArray array];
    if ([self.state isEqualToString:@"待处理"]) {
        if (self.is_send.integerValue == 3 ) {
            [functions addObject:@{@"tipImg":@"deliever_tip",@"funTitle":@"已自提"}];
        } else {
            [functions addObject:@{@"tipImg":@"deliever_tip",@"funTitle":@"配送"}];
        }
        [functions addObject:@{@"tipImg":@"printe_tip",@"funTitle":@"打印"}];
    } else if ([self.state isEqualToString:@"配送中"]) {
        [functions addObject:@{@"tipImg":@"tk_tip",@"funTitle":@"退款"}];
        [functions addObject:@{@"tipImg":@"arrive_tip",@"funTitle":@"送达"}];
    } else {
        [functions addObject:@{@"tipImg":@"tk_tip",@"funTitle":@"退款"}];
        [functions addObject:@{@"tipImg":@"printe_tip",@"funTitle":@"打印"}];
    }
    return functions;
}

@end


///  秒杀团购(1,16)
@implementation HLSpikeBuyModel

+ (NSDictionary *)mj_objectClassInArray {
    return @{
        @"Info": @"HLOrderGoodModel"
    };
}

- (NSMutableArray *)settlementDes {
    NSMutableArray *contents = [NSMutableArray array];
    if (![self emptyWithMoney:self.sum_money]) {
        NSDictionary * dict = @{@"key":@"商品原价",@"value":[NSString stringWithFormat:@"%@",[self addMoneySymbolWithMoney:self.sum_money]]};
        [contents addObject:dict];
    }
    
    if (![self emptyWithMoney:self.pay_price]) {
        NSDictionary * dict = @{@"key":@"商品总额",@"value":[NSString stringWithFormat:@"%@",[self addMoneySymbolWithMoney:self.pay_price]]};
        [contents addObject:dict];
    }
    
    if (![self emptyWithMoney:self.commission]) {
        NSDictionary * dict = @{@"key":self.commission_str,@"value":[NSString stringWithFormat:@"%@",[self addMoneySymbolWithMoney:self.commission]]};
        [contents addObject:dict];
    }
    
    if (![self emptyWithMoney:self.distribution_money]) {
        NSDictionary * dict = @{@"key":self.distribution_str,@"value":[NSString stringWithFormat:@"%@",[self addMoneySymbolWithMoney:self.distribution_money]]};
        [contents addObject:dict];
    }
    
    if (self.discount_act.count >0) {
        for (NSDictionary * dict in self.discount_act) {
            NSDictionary * data = @{@"key":dict[@"name"],@"value":dict[@"price"]};
            [contents addObject:data];
        }
    }
    
    if (![self emptyWithMoney:self.peisong_money]) {
        NSDictionary * dict = @{@"key":self.peisong_money_str,@"value":[NSString stringWithFormat:@"%@",[self addMoneySymbolWithMoney:self.peisong_money]]};
        [contents addObject:dict];
    }
    
    if (![self emptyWithMoney:self.coupon_money]) {
        NSDictionary * dict = @{@"key":self.coupon_money_str,@"value":[NSString stringWithFormat:@"%@",[self addMoneySymbolWithMoney:self.coupon_money]]};
        [contents addObject:dict];
    }
    
    if (![self emptyWithMoney:self.ziti_money]) {
        NSDictionary * dict = @{@"key":self.ziti_money_str,@"value":[NSString stringWithFormat:@"%@",[self addMoneySymbolWithMoney:self.ziti_money]]};
        [contents addObject:dict];
    }
    
    return contents;
}

@end


///  优惠买单（4）
@implementation HLPreferentialModel

- (NSMutableArray *)settlementDes {
    NSMutableArray *contents = [NSMutableArray array];
    if (![self emptyWithMoney:self.sum_money]) {
        NSDictionary * dict = @{@"key":@"商品原价",@"value":[NSString stringWithFormat:@"%@",[self addMoneySymbolWithMoney:self.sum_money]]};
        [contents addObject:dict];
    }
    
    if (![self emptyWithMoney:self.pay_price]) {
        NSDictionary * dict = @{@"key":@"商品总额",@"value":[NSString stringWithFormat:@"%@",[self addMoneySymbolWithMoney:self.pay_price]]};
        [contents addObject:dict];
    }
    
    if (![self emptyWithMoney:self.commission]) {
        NSDictionary * dict = @{@"key":@"服务费",@"value":[NSString stringWithFormat:@"%@",[self addMoneySymbolWithMoney:self.commission]]};
        [contents addObject:dict];
    }
    
    if (self.discount.length) {
        NSDictionary *dict = @{@"key": @"商家折扣",
                               @"value": [NSString stringWithFormat:@"%@", self.discount] };
        [contents addObject:dict];
    }
    
    if (self.discount_act.count >0) {
        for (NSDictionary * dict in self.discount_act) {
            NSDictionary * data = @{@"key":dict[@"name"],@"value":dict[@"price"]};
            [contents addObject:data];
        }
    }
    
    if (![self emptyWithMoney:self.peisong_money]) {
        NSDictionary * dict = @{@"key":self.peisong_money_str,@"value":[NSString stringWithFormat:@"%@",[self addMoneySymbolWithMoney:self.peisong_money]]};
        [contents addObject:dict];
    }
    
    if (![self emptyWithMoney:self.coupon_money]) {
        NSDictionary * dict = @{@"key":self.coupon_money_str,@"value":[NSString stringWithFormat:@"%@",[self addMoneySymbolWithMoney:self.coupon_money]]};
        [contents addObject:dict];
    }
    
    if (![self emptyWithMoney:self.ziti_money]) {
        NSDictionary * dict = @{@"key":self.ziti_money_str,@"value":[NSString stringWithFormat:@"%@",[self addMoneySymbolWithMoney:self.ziti_money]]};
        [contents addObject:dict];
    }
    
    return contents;
}

- (NSArray *)functions {
    return @[@{ @"tipImg": @"printe_tip",
                @"funTitle": @"打印" }];
}
@end

/// 汽车服务(13)
@implementation HLCarServiceModel

+ (NSDictionary *)mj_objectClassInArray {
    return @{
        @"Info": @"HLOrderCarModel"
    };
}


@end


/// 快捷买单(30)
@implementation HLFastBuyModel

+ (NSDictionary *)mj_objectClassInArray {
    return @{
        @"Info": @"HLOrderGoodModel"
    };
}

- (NSMutableArray *)settlementDes {
    NSMutableArray *contents = [NSMutableArray array];
    
    if (![self emptyWithMoney:self.pay_price]) {
        NSDictionary * dict = @{@"key":@"商品总额",@"value":[NSString stringWithFormat:@"%@",[self addMoneySymbolWithMoney:self.pay_price]]};
        [contents addObject:dict];
    }
    
    if (![self emptyWithMoney:self.commission]) {
        NSDictionary * dict = @{@"key":@"服务费",@"value":[NSString stringWithFormat:@"%@",[self addMoneySymbolWithMoney:self.commission]]};
        [contents addObject:dict];
    }
    
    if (self.discount_act.count >0) {
        for (NSDictionary * dict in self.discount_act) {
            NSDictionary * data = @{@"key":dict[@"name"],@"value":dict[@"price"]};
            [contents addObject:data];
        }
    }
    
    if (![self emptyWithMoney:self.peisong_money]) {
        NSDictionary * dict = @{@"key":self.peisong_money_str,@"value":[NSString stringWithFormat:@"%@",[self addMoneySymbolWithMoney:self.peisong_money]]};
        [contents addObject:dict];
    }
    
    if (![self emptyWithMoney:self.coupon_money]) {
        NSDictionary * dict = @{@"key":self.coupon_money_str,@"value":[NSString stringWithFormat:@"%@",[self addMoneySymbolWithMoney:self.coupon_money]]};
        [contents addObject:dict];
    }
    
    if (![self emptyWithMoney:self.ziti_money]) {
        NSDictionary * dict = @{@"key":self.ziti_money_str,@"value":[NSString stringWithFormat:@"%@",[self addMoneySymbolWithMoney:self.ziti_money]]};
        [contents addObject:dict];
    }
    
    return contents;
}

- (NSArray *)functions {
    return @[@{ @"tipImg": @"printe_tip",
                @"funTitle": @"打印" }];
}

@end


/// 折扣买单(39)
@implementation HLDiscountBuyModel

+ (NSDictionary *)mj_objectClassInArray {
    return @{
        @"Info": @"HLOrderGoodModel"
    };
}

- (NSMutableArray *)settlementDes {
    NSMutableArray *contents = [NSMutableArray array];
    if (![self emptyWithMoney:self.sum_money]) {
        [contents addObject:@{ @"key": @"买单金额",@"value":[NSString stringWithFormat:@"%@",[self addMoneySymbolWithMoney:self.sum_money]] }];
    }
    
    if (![self emptyWithMoney:self.amount]) {
        [contents addObject:@{ @"key": @"加购商品",@"value": [self addMoneySymbolWithMoney:self.amount?:@""] }];
    }
    
    if (![self emptyWithMoney:self.commission]) {
        NSDictionary * dict = @{@"key":@"服务费",@"value":[NSString stringWithFormat:@"%@",[self addMoneySymbolWithMoney:self.commission]]};
        [contents addObject:dict];
    }
    
    if (![self emptyWithMoney:self.discount_money]) {
        [contents addObject:@{ @"key": @"商家代金券",@"value":[self addMoneySymbolWithMoney:self.discount_money]  }];
    }
    
    if (![self emptyWithMoney:self.peisong_money]) {
        NSDictionary * dict = @{@"key":self.peisong_money_str,@"value":[NSString stringWithFormat:@"%@",[self addMoneySymbolWithMoney:self.peisong_money]]};
        [contents addObject:dict];
    }
    
    if (![self emptyWithMoney:self.coupon_money]) {
        NSDictionary * dict = @{@"key":self.coupon_money_str,@"value":[NSString stringWithFormat:@"%@",[self addMoneySymbolWithMoney:self.coupon_money]]};
        [contents addObject:dict];
    }
    
    if (![self emptyWithMoney:self.ziti_money]) {
        NSDictionary * dict = @{@"key":self.ziti_money_str,@"value":[NSString stringWithFormat:@"%@",[self addMoneySymbolWithMoney:self.ziti_money]]};
        [contents addObject:dict];
    }
    
    if (![self emptyWithMoney:self.pay_price]) {
        [contents addObject:@{ @"key": @"实付金额",@"value":[self addMoneySymbolWithMoney:self.pay_price?:@""]}];
    }
    
    return contents;
}

@end


/// 代金券(38)
@implementation HLVoucherBuyModel

+ (NSDictionary *)mj_objectClassInArray {
    return @{
        @"Info": @"HLOrderGoodModel"
    };
}

- (NSMutableArray *)settlementDes {
    NSMutableArray *contents = [NSMutableArray array];
    
    if (![self emptyWithMoney:self.pay_price]) {
        NSDictionary * dict = @{@"key":@"订单金额",@"value":[NSString stringWithFormat:@"%@",[self addMoneySymbolWithMoney:self.pay_price]]};
        [contents addObject:dict];
    }
    
    if (![self emptyWithMoney:self.commission]) {
        NSDictionary * dict = @{@"key":@"服务费",@"value":[NSString stringWithFormat:@"%@",[self addMoneySymbolWithMoney:self.commission]]};
        [contents addObject:dict];
    }
    
    if (![self emptyWithMoney:self.coupon_money]) {
        NSDictionary * dict = @{@"key":self.coupon_money_str,@"value":[NSString stringWithFormat:@"%@",[self addMoneySymbolWithMoney:self.coupon_money]]};
        [contents addObject:dict];
    }
    
    if (![self emptyWithMoney:self.peisong_money]) {
        NSDictionary * dict = @{@"key":self.peisong_money_str,@"value":[NSString stringWithFormat:@"%@",[self addMoneySymbolWithMoney:self.peisong_money]]};
        [contents addObject:dict];
    }
    
    if (![self emptyWithMoney:self.ziti_money]) {
        NSDictionary * dict = @{@"key":self.ziti_money_str,@"value":[NSString stringWithFormat:@"%@",[self addMoneySymbolWithMoney:self.ziti_money]]};
        [contents addObject:dict];
    }
    
    return contents;
}

@end


/// 计次卡(37)
@implementation HLNumberCardModel

+ (NSDictionary *)mj_objectClassInArray {
    return @{
        @"Info": @"HLOrderGoodModel"
    };
}

- (NSMutableArray *)settlementDes {
    NSMutableArray *contents = [NSMutableArray array];
    
    if (![self emptyWithMoney:self.pay_price]) {
        NSDictionary * dict = @{@"key":@"订单金额",@"value":[NSString stringWithFormat:@"%@",[self addMoneySymbolWithMoney:self.pay_price]]};
        [contents addObject:dict];
    }
    
    if (![self emptyWithMoney:self.commission]) {
        NSDictionary * dict = @{@"key":@"服务费",@"value":[NSString stringWithFormat:@"%@",[self addMoneySymbolWithMoney:self.commission]]};
        [contents addObject:dict];
    }
    
    if (![self emptyWithMoney:self.peisong_money]) {
        NSDictionary * dict = @{@"key":self.peisong_money_str,@"value":[NSString stringWithFormat:@"%@",[self addMoneySymbolWithMoney:self.peisong_money]]};
        [contents addObject:dict];
    }
    
    if (![self emptyWithMoney:self.coupon_money]) {
        NSDictionary * dict = @{@"key":self.coupon_money_str,@"value":[NSString stringWithFormat:@"%@",[self addMoneySymbolWithMoney:self.coupon_money]]};
        [contents addObject:dict];
    }
    
    if (![self emptyWithMoney:self.ziti_money]) {
        NSDictionary * dict = @{@"key":self.ziti_money_str,@"value":[NSString stringWithFormat:@"%@",[self addMoneySymbolWithMoney:self.ziti_money]]};
        [contents addObject:dict];
    }
    
    return contents;
}

@end

//卡（5）
@implementation HLHUICardModel
+ (NSDictionary *)mj_objectClassInArray {
    return @{
        @"Info": @"HLHUICardGoodInfo"
    };
}

- (NSMutableArray *)settlementDes {
    NSMutableArray *contents = [NSMutableArray array];
    if (![self emptyWithMoney:self.sum_money]) {
        NSDictionary * dict = @{@"key":@"商品原价",@"value":[NSString stringWithFormat:@"%@",[self addMoneySymbolWithMoney:self.sum_money]]};
        [contents addObject:dict];
    }
    
    if (![self emptyWithMoney:self.pay_price]) {
        NSDictionary * dict = @{@"key":@"商品总额",@"value":[NSString stringWithFormat:@"%@",[self addMoneySymbolWithMoney:self.pay_price]]};
        [contents addObject:dict];
    }
    return contents;
}
@end


//爆款
@implementation HLHotShopModel


@end

//秒杀拼团
@implementation HLSpikeGroupModel

- (NSArray *)functions {
    if (self.is_zd == 1) return nil;
    NSMutableArray *functions = [NSMutableArray array];
    if ([self.state isEqualToString:@"待处理"]) {
        if (self.is_send.integerValue == 3 || self.is_send.integerValue == 0) {
            [functions addObject:@{@"tipImg":@"tk_tip",@"funTitle":@"退款"}];
        } else {
            [functions addObject:@{@"tipImg":@"deliever_tip",@"funTitle":@"配送"}];
        }
        [functions addObject:@{@"tipImg":@"printe_tip",@"funTitle":@"打印"}];
    } else if ([self.state isEqualToString:@"配送中"]) {
        [functions addObject:@{@"tipImg":@"tk_tip",@"funTitle":@"退款"}];
        [functions addObject:@{@"tipImg":@"arrive_tip",@"funTitle":@"送达"}];
    } else {
        [functions addObject:@{@"tipImg":@"tk_tip",@"funTitle":@"退款"}];
        [functions addObject:@{@"tipImg":@"printe_tip",@"funTitle":@"打印"}];
    }
    return functions;
}

@end
