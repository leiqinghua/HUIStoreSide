//
//  HLProfitGoodInfo.h
//  HuiLife
//
//  Created by 雷清华 on 2020/9/30.
// 权益类型 model

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN
@class HLProfitOrderInfo;
@class HLProfitFirstInfo;
@class HLProfitYMInfo;
@class HLProfitServiceInfo;
@class HLProfitVoucherInfo;
@class HLProfitDiscountInfo;
@class HLProfitGiftInfo;

@interface HLProfitGoodInfo : NSObject

//权益索引（用于修改权益
@property(nonatomic, copy) NSString *gainId;
//卡索引
@property(nonatomic, copy) NSString *cardId;

/**
 //权益类型
 1 收单折扣，3日常折扣,2 外卖折扣，
 43 服务卡，42代金券，41 打折券， 21赠品
 60,话费 61 外卖红包
 */
@property(nonatomic, assign) NSInteger gainType;
//权益名称
@property(nonatomic, copy) NSString *gainName;
//权益描述
@property(nonatomic, copy) NSString *gainDesc;
//显示 开卡送。。(待返回)
@property(nonatomic, copy) NSString *title;
//权益使用商户索引
@property(nonatomic, copy) NSString *bussUserId;

//==============================================

@property(nonatomic, assign) CGFloat cellHight;
//权益类型 字符串
@property(nonatomic, copy) NSString *gainTypeName;

@property(nonatomic, strong) NSAttributedString *discountAttr;

@property(nonatomic, copy) NSString *detailStr;

+ (NSArray *)profitsWithDict:(NSArray *)oriResult;

+ (NSArray *)ignoredKeys;

@end


// 外卖红包子项
@interface HLProfitRedPacketGainInfo : NSObject

@property (nonatomic, copy) NSString *class_id; // 分类id
@property (nonatomic, copy) NSString *discount; // 折扣
//@property (nonatomic, copy) NSString *gain_id;  // id
@property (nonatomic, copy) NSString *title;    // 名称

@end
// 外卖红包
@interface HLProfitRedPacketInfo : HLProfitGoodInfo

@property(nonatomic, copy) NSArray <HLProfitRedPacketGainInfo *>*disOut;     // 分类列表
@property (nonatomic, copy) NSString *gainPrice;// 价格

@property (nonatomic, strong) NSMutableAttributedString *gainPriceAttr;

@end

//首单折扣,日常折扣
@interface HLProfitFirstInfo : HLProfitGoodInfo

@property(nonatomic, copy) NSString * disFirst;

@end


//外卖折扣
@interface HLProfitYMInfo : HLProfitGoodInfo

//起始折扣
@property(nonatomic, copy) NSString *disFirst;

@property(nonatomic, strong) NSArray<HLProfitOrderInfo *> *disOut;

@property(nonatomic, strong) NSAttributedString *detailAttr;

@end

//服务卡权益
@interface HLProfitServiceInfo : HLProfitGoodInfo
//权益数量
@property(nonatomic, assign) NSInteger gainNum;
//有效期开始
@property(nonatomic, copy) NSString *startDate;
//有效期截止
@property(nonatomic, copy) NSString *endDate;
//开启月月赠送
@property(nonatomic, assign) BOOL open;

@end

//代金券权益
@interface HLProfitVoucherInfo : HLProfitGoodInfo
//权益金额
@property(nonatomic, copy) NSString *gainPrice;
//权益限额
@property(nonatomic, copy) NSString *limitPrice;
//权益数量
@property(nonatomic, assign) NSInteger gainNum;
//有效期开始
@property(nonatomic, copy) NSString *startDate;
//有效期截止
@property(nonatomic, copy) NSString *endDate;

//开启月月赠送
@property(nonatomic, assign) BOOL open;

@end

//打折券权益
@interface HLProfitDiscountInfo : HLProfitGoodInfo
//折扣
@property(nonatomic, copy) NSString * gainPrice;
//权益限额
@property(nonatomic, copy) NSString *limitPrice;
//权益数量
@property(nonatomic, assign) NSInteger gainNum;
//有效期开始
@property(nonatomic, copy) NSString *startDate;
//有效期截止
@property(nonatomic, copy) NSString *endDate;
//开启月月赠送
@property(nonatomic, assign) BOOL open;
@end

//赠品
@interface HLProfitGiftInfo : HLProfitGoodInfo
//商品价值
@property(nonatomic, copy) NSString *gainPrice;
//权益图标
@property(nonatomic, copy) NSString *imgLogo;
//权益详情图片
@property(nonatomic, copy) NSString *imgDetail;
//权益数量
@property(nonatomic, assign) NSInteger gainNum;
//有效期开始
@property(nonatomic, copy) NSString *startDate;
//有效期截止
@property(nonatomic, copy) NSString *endDate;

@property(nonatomic, copy) NSString *dateStr;
//开启月月赠送
@property(nonatomic, assign) BOOL open;

@end

//话费券
@interface HLPhoneFeeInfo : HLProfitGoodInfo

@property(nonatomic, copy) NSString *endDate;

@property(nonatomic, copy) NSString *startDate;

@property(nonatomic, copy) NSString *limitPrice;

@property(nonatomic, assign) BOOL state;

@property(nonatomic, copy) NSString * gainPrice;

@property(nonatomic, assign) NSInteger gainNum;

@property(nonatomic, copy) NSString *gainLableDesc;

@property(nonatomic, copy) NSString *gainLable;

@end


//订单折扣 的 model
@interface HLProfitOrderInfo : NSObject
@property(nonatomic, copy) NSString *priceStart;//价格开始
@property(nonatomic, copy) NSString *priceEnd;//价格结束
@property(nonatomic, copy) NSString *discount;//折扣
//placehoder
@property(nonatomic, copy) NSString *discountPlace;
@property(nonatomic, copy) NSString *minPlace;
@property(nonatomic, copy) NSString *maxPlace;
@property(nonatomic, copy) NSString *Id;

- (BOOL)check;

@end

NS_ASSUME_NONNULL_END
