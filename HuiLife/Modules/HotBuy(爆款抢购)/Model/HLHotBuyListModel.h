//
//  HLHotBuyListModel.h
//  HuiLife
//
//  Created by 王策 on 2019/10/23.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface HLHotBuyListModel : NSObject
{
    NSAttributedString *_priceAttr;
}

// 商品id
@property (nonatomic, copy) NSString *pid;
// 商品名称
@property (nonatomic, copy) NSString *proname;
// 图片地址
@property (nonatomic, copy) NSString *propicpath;
// 秒杀价格
@property (nonatomic, assign) double prounitprice;
// 原价
@property (nonatomic, assign) double market_price;
// 是否在线 1-在线 0-下线 2-售完
@property (nonatomic, assign) NSInteger on_line;
// 文字状态
@property (nonatomic, copy) NSString *state;
// 浏览数
@property (nonatomic, copy) NSString *click_num;
// 销售数量
@property (nonatomic, copy) NSString *num;
//使用数量
@property (nonatomic, copy) NSString *use_num;

// 价格富文本
- (NSAttributedString *)priceAttr;

@end

NS_ASSUME_NONNULL_END
