//
//  HLOrderPartRefund.h
//  iOS13test
//
//  Created by 雷清华 on 2019/10/28.
//  Copyright © 2019 雷清华. All rights reserved.
// 部分退款

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface HLOrderPartRefund : NSObject

/// u退款的商品
@property (strong, nonatomic) NSArray *pro;

//用户收到退款金额：
@property (copy, nonatomic) NSString *amount;

/// 商家承担退款金额
@property (copy, nonatomic) NSString *s_amount;

/// 退款编号
@property (copy, nonatomic) NSString *returnId;

/// 退款原因
@property (copy, nonatomic) NSString *reason;

/// 退款时间
@property (copy, nonatomic) NSString *succed_time;

/// 退款说明
@property (strong, nonatomic) NSMutableArray *contents;

/// 总高度
@property (assign, nonatomic) CGFloat totleHight;

//商品高度
@property (assign, nonatomic) CGFloat goodHight;

/// 用户收到和商家承担退款金额
@property (assign, nonatomic) CGFloat priceDesHight;

/// 退款的说明高度
@property (assign, nonatomic) CGFloat contentHight;

@end

NS_ASSUME_NONNULL_END
