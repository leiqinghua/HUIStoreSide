//
//  HLOrderPrinterModel.h
//  HuiLife
//
//  Created by 王策 on 2021/6/19.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@class HLOrderPrinterItem;
@interface HLOrderPrinterModel : NSObject

@property (nonatomic, assign) NSInteger times; // 联数
@property (nonatomic, assign) NSInteger type; // 订单类型，暂未用到
@property (nonatomic, strong) HLOrderPrinterItem *items; // 包裹打印的主要数据


//// 转化成打印的数据
@property (nonatomic, strong) NSData *printData;

@end

@interface HLOrderPrinterItem : NSObject

@property (nonatomic, copy) NSString *button; // 最底部二维码下方文字
@property (nonatomic, copy) NSArray <NSDictionary *>*list; // key - value 直接打印
@property (nonatomic, copy) NSString *qr_url;
@property (nonatomic, copy) NSString *small_title;
@property (nonatomic, copy) NSString *title;

@end

@interface HLOrderPrinterGoods : NSObject

@property (nonatomic, copy) NSString *num;
@property (nonatomic, copy) NSString *price;
@property (nonatomic, copy) NSString *prices;
@property (nonatomic, copy) NSString *title;

@end

NS_ASSUME_NONNULL_END
