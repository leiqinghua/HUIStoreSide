//
//  HLHotSekillInputController+SubType.h
//  HuiLife
//
//  Created by 王策 on 2021/8/7.
//

#import "HLHotSekillInputController.h"
#import "HLHotSekillTransporter.h"

NS_ASSUME_NONNULL_BEGIN

@interface HLHotSekillInputController (SubType)

/// 根据不同类型构建数据源数组
- (NSArray *)buildDataSourceWithType:(HLHotSekillType)sekillType;

/// 默认类型验证规则
- (NSArray *)sekillTypeNormalRoles;

///  亿元券兑换
- (NSArray *)sekillType20;

/// 新人引流到店
- (NSArray *)sekillType30;

/// 签约爆客推广
- (NSArray *)sekillType40;

/// 亿元券 & 新客引流类型配置编辑的详情数据
- (void)handle20And30EditData:(NSDictionary *)dataDict;

/// 默认类型 & 签约爆客推广类型配置编辑的详情数据
- (void)handleNormalAnd40EditData:(NSDictionary *)dataDict;

@end

NS_ASSUME_NONNULL_END
