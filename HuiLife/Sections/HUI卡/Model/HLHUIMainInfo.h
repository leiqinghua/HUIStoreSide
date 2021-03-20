//
//  HLHUIMainInfo.h
//  HuiLife
//
//  Created by 雷清华 on 2020/9/23.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN
@interface HLHUIMainInfo : NSObject
@property(nonatomic, copy) NSString *cardId;//卡索引
@property(nonatomic, copy) NSString *cardName;//卡名称
@property(nonatomic, copy) NSString *originalPrice;//市场价
@property(nonatomic, copy) NSString *salePrice;//销售价
@property(nonatomic, assign) NSInteger saleNum;//销售量
@property(nonatomic, assign) NSInteger termYear;//卡期限
//0 上架，1下架
@property(nonatomic, assign) NSInteger state;//卡状态
@property(nonatomic, copy) NSString *stateDesc;//卡状态描述
@property(nonatomic, strong) NSAttributedString *timeAttr;
@end
NS_ASSUME_NONNULL_END
