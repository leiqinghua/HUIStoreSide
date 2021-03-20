//
//  HLDayDealGoodInfo.h
//  HuiLife
//
//  Created by 雷清华 on 2020/11/17.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface HLDayDealGoodInfo : NSObject
@property(nonatomic, copy) NSString *Id;//秒杀索引
@property(nonatomic, copy) NSString *pic;//图片
@property(nonatomic, copy) NSString *title;//标题
@property(nonatomic, copy) NSString *end_time;//结束时间
@property(nonatomic, assign) NSInteger count;//总数
@property(nonatomic, assign) NSInteger stock_num;//库存
@property(nonatomic, assign) BOOL up_or_down;//状态(销售中还是下架)
@property(nonatomic, copy) NSString *stateDesc;//状态描述
@property(nonatomic, assign) BOOL isSelected;
//当前是否选中
@property(nonatomic, assign) BOOL click;

@end

NS_ASSUME_NONNULL_END
