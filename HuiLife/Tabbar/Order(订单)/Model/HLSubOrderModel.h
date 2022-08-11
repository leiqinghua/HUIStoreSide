//
//  HLSubOrderModel.h
//  iOS13test
//
//  Created by 雷清华 on 2019/10/22.
//  Copyright © 2019 雷清华. All rights reserved.

#import "HLBaseOrderModel.h"
#import "HLOrderPartRefund.h"

NS_ASSUME_NONNULL_BEGIN

/// 扫码点餐/店内点餐/上门外送/自提点餐 18,23
@interface HLScanOrderModel : HLBaseOrderModel

/// 退款状态 0没退 1整单退 2部分退
@property(assign, nonatomic) NSInteger is_zd;

@property(assign, nonatomic) NSInteger refund;

@property(copy, nonatomic) NSString *refund_txt;

@property(copy, nonatomic) NSString *returnId;

/// 配送地址
@property(copy, nonatomic) NSString *address;
///自提时间
@property(copy, nonatomic) NSString *selfTime;

/**
 type = 29 : 自提：3， 配送 1
 其他：自提 is_send=3   堂食 is_send=1  外卖 is_send=0
 */
@property(copy, nonatomic) NSString *is_send;
//自提：自提人，其他：收货人
@property(nonatomic, copy) NSString *contactTip;
/// 就餐桌号
@property(copy, nonatomic) NSString *zhuohao;
//联系人
@property(copy, nonatomic) NSString *name;
//联系人电话
@property(copy, nonatomic) NSString *tel;
/// 就餐人数
@property(copy, nonatomic) NSString *people_num;
/// 用户收到退款金额
@property(copy, nonatomic) NSString *amount;
/// 商家承担退款金额
@property(copy, nonatomic) NSString *s_amount;
/// 退款原因
@property(copy, nonatomic) NSString *return_reason;
/// 退款原因
@property(copy, nonatomic) NSString *reason;
/// 退款时间
@property(copy, nonatomic) NSString *succed_time;
/// 部分退款
@property(strong, nonatomic) NSArray<HLOrderPartRefund *> *returnInfo;
/// 店内点餐 桌号旁边的图片
@property(nonatomic,copy)NSString * zhuohao_people_pic;
/// 就餐人数描述
@property(nonatomic,copy)NSString * zhuohao_people_str;
//包装费
@property(nonatomic, copy) NSString * pack_money;
// 包装费提示
@property(nonatomic, copy) NSString * pack_money_str;
///18，23 专用 按钮文案
@property(nonatomic, copy) NSString *dispatch_state_info;
///18，23 专用 骑手接单状态 弹框 呼叫
@property(nonatomic, copy) NSString *dispatch_mobile;
///18，23  专用 （1，待接单，2已接单）
@property(nonatomic, assign) NSInteger dispatch_state;
///0-骑手配送中，1-骑手已接单
@property(nonatomic, assign) NSInteger dispatchType;
///18，23  专用  是否开启配送
@property(nonatomic, assign) BOOL is_dispatch;
///18，23 运送费 str
@property(nonatomic, copy) NSString *freight_coupon_money_str;
///18，23 运送费
@property(nonatomic, copy) NSString *freight_coupon_money;
///18，23 排单费 str
@property(nonatomic, copy) NSString *dispatch_fee_money_str;
///18，23 排单费
@property(nonatomic, copy) NSString *dispatch_fee_money;
///18，23 外卖折扣 str
@property(nonatomic, copy) NSString *take_away_discount_str;
///18，23 外卖折扣
@property(nonatomic, copy) NSString *take_away_discount;

// 0 手动接单 1 自动接单
@property (nonatomic, assign) NSInteger take_out_handing;
// 0 待接单 1 商家已接单/等待骑手接单 2 骑手已接单 3 取货中 5 配送中 6 配送完成
@property (nonatomic, assign) NSInteger take_out_status;
//0 代表商家自配送，没用到
@property (nonatomic, assign) NSInteger take_out_type;

//红包优惠
@property(nonatomic, copy) NSString *redbag;
//备注
@property(nonatomic, copy) NSString *remark;

@property(nonatomic, strong) NSAttributedString *remarkAttr;
///二维码
@property(nonatomic, copy) NSString *qr_code;

@property(nonatomic, copy) NSString *qr_tips;

@end


/// 便利商超（29）
@interface HLConShopModel : HLScanOrderModel
//实付金额
@property(nonatomic, copy) NSString *sj_pay_price;

@end


/// 秒杀团购(1,16)
@interface HLSpikeBuyModel : HLBaseOrderModel

/// 会员优惠价
@property(copy, nonatomic) NSString *price;

@end


/// 优惠买单（4）
@interface HLPreferentialModel : HLBaseOrderModel
/// 折扣
@property (copy, nonatomic) NSString *discount;


@end

/// 汽车服务(13)
@interface HLCarServiceModel : HLBaseOrderModel

@end

/// 快捷买单(30)
@interface HLFastBuyModel : HLBaseOrderModel

/// 配送地址
@property (copy, nonatomic) NSString *address;

@end


/// 折扣买单(39)
@interface HLDiscountBuyModel : HLBaseOrderModel

// 加购商品
@property (nonatomic, copy) NSString *amount;

@end


/// 代金券(38)
@interface HLVoucherBuyModel : HLBaseOrderModel

@end


//计次卡(37)
@interface HLNumberCardModel : HLBaseOrderModel

@end

//卡(5)
@interface HLHUICardModel : HLBaseOrderModel

@end

//爆款（44）
@interface HLHotShopModel : HLConShopModel

@property(nonatomic, copy) NSString *add_pro_price;

@property(nonatomic, copy) NSString *coupon_price;

@end

//秒杀拼团 43
@interface HLSpikeGroupModel : HLScanOrderModel

@end

NS_ASSUME_NONNULL_END
