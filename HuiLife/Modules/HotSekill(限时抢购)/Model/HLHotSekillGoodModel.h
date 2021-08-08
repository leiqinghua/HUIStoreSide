//
//  HLHotSekillGoodModel.h
//  HuiLife
//
//  Created by 王策 on 2019/8/6.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface HLHotSekillGoodModel : NSObject

// id
@property (nonatomic, copy) NSString *Id;
// 
@property (nonatomic, copy) NSString *pic;
@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *priceTitle;
@property (nonatomic, assign) double orgPrice;
@property (nonatomic, assign) double price;

/// 分佣
@property (nonatomic, assign) double invite_amount;

/// 提供的数量
@property (nonatomic, assign) NSInteger offerNum;

/// 限购的数量
@property (nonatomic, assign) NSInteger limitNum;

/// 开始时间
@property (nonatomic, copy) NSString *startTime;

/// 结束时间
@property (nonatomic, copy) NSString *endTime;

/// 截止时间
@property (nonatomic, copy) NSString *closingDate;

@property (nonatomic, copy) NSString *popularize; // 一般
@property (nonatomic, copy) NSString *popularColor;

/// 订单数 使用数 浏览数
@property (nonatomic, assign) NSInteger orderCnt;
@property (nonatomic, assign) NSInteger usedCnt;
@property (nonatomic, assign) NSInteger hitsCnt;

// 上架的状态具体分为这四种（1未开售 2已过期 3已售完 4销售中） 5已下架 6未通过 7审核中
@property (nonatomic, copy) NSString *state;
@property (nonatomic, assign) NSInteger stateCode;

// 被拒原因
@property (nonatomic, copy) NSString *reason;

// 1 上架  2 下架
@property (nonatomic, assign) NSInteger upOrDown;

/// 展架提示
@property(nonatomic,copy) NSString * displayRack;
@property(nonatomic,copy) NSString * qrCode;
@property(nonatomic,copy) NSString * wechatMoments;
@property(nonatomic,copy) NSString * friendCircle;

/// 是否已经开始推广了(选择时会返回这个数据)，另一个需求使用的
@property (nonatomic, assign) BOOL isSelected;

/// 自己加的，标明是否选中
@property (nonatomic, assign) BOOL userSelect;

/// 普通秒杀类型价格展示  售价 17
@property (nonatomic, strong) NSAttributedString *priceAttr;

/// 非普通秒杀类型价格展示  价值 17
@property (nonatomic, strong) NSAttributedString *noNormalTypePriceAttr;

@end

NS_ASSUME_NONNULL_END
//offerNum    22

