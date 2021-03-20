//
//  HLBaseOrderModel.h
//  iOS13test
//
//  Created by 雷清华 on 2019/10/22.
//  Copyright © 2019 雷清华. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface HLBaseOrderModel : NSObject

/// 标识
@property (nonatomic, copy) NSString *identifier;
/// 状态
//0处理中，1配送中,2已完成，3退款，4未使用
//@property (assign, nonatomic) NSInteger status;

/// 昵称
@property (copy, nonatomic) NSString *nick_name;

/// 电话
@property (copy, nonatomic) NSString *mobile;

/// 是否是会员
@property (copy, nonatomic) NSString *isVip;

/// 订单文字状态描述：已完成
@property (copy, nonatomic) NSString *state;

/// 订单id
@property (copy, nonatomic) NSString *order_id;

/**
 HUI卡顾客买单 4
 汽车服务 13
 秒杀 1, 16
 扫码点餐/店内点餐/上门外送/自提点餐 18,23
 便利商超 29
 快捷买单 30
 折扣买单(HUI小程序顾客买单) 39
 代金券(HUI小程序代金卷) 38
 计次卡(HUI小程序售卡) 37
 */
@property (assign, nonatomic) NSInteger type;

/// 订单类型文字描述
@property (copy, nonatomic) NSString *orderType;

/// 下单时间
@property (copy, nonatomic) NSString *input_time;

/// 下单门店
@property (copy, nonatomic) NSString *storeName;

/// 商品原价
@property (copy, nonatomic) NSString *sum_money;

/// 实付金额
@property (copy, nonatomic) NSString *pay_price;

/// 商家补贴
@property (copy, nonatomic) NSString *discount_money;

// '手续费'
@property (copy, nonatomic) NSString *commission_str;

//手续费
@property (copy, nonatomic) NSString *commission;

// 分销佣金
@property(nonatomic, copy) NSString *distribution_str;

//分销佣金
@property(nonatomic, copy) NSString *distribution_money;

/// 结算金额
@property (copy, nonatomic) NSString *chengjiao_price;

/// 第一个折叠部分 下方内容 的 额外补充
@property (strong, nonatomic) NSArray *Info;

@property (strong, nonatomic) NSArray *discount_act;

/// 底部内容
@property (strong, nonatomic) NSMutableArray *bottomContents;

/// 折叠部分 结算描述
@property (strong, nonatomic) NSMutableArray *settlementDes;

@property (copy, nonatomic) NSString *coupon_money_str;//代金券
@property (copy, nonatomic) NSString *coupon_money;
@property (copy, nonatomic) NSString *peisong_money_str;//配送费
@property (copy, nonatomic) NSString *peisong_money;
@property (copy, nonatomic) NSString *ziti_money_str;//自提立减
@property (copy, nonatomic) NSString *ziti_money;
//按钮
@property (nonatomic, strong) NSArray *functions;

//添加￥符号
-(NSString *)addMoneySymbolWithMoney:(NSString *)money;
//判断钱是否为0
- (BOOL)emptyWithMoney:(NSString *)money ;

@end


NS_ASSUME_NONNULL_END
