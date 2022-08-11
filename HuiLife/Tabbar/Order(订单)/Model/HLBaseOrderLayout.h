//
//  HLBaseOrderLayout.h
//  iOS13test
//
//  Created by 雷清华 on 2019/10/23.
//  Copyright © 2019 雷清华. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HLSubOrderModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface HLBaseOrderLayout : NSObject

@property(nonatomic, strong) HLBaseOrderModel *orderModel;
/// 是否展开
@property(nonatomic, assign)BOOL open;
/// 第一个显示订单号的cell 的高度
@property (nonatomic, assign) CGFloat orderInfoHight;

@property (nonatomic, assign) CGFloat userInfoHight;
/// 最后的内容高度
@property (nonatomic, assign) CGFloat bottomHight;

/// 商品部分显示展开的 分组 footer高度
@property (nonatomic, assign) CGFloat footerHight;

@property (nonatomic, assign) CGFloat tableHight;

@property (nonatomic, assign) CGFloat totalHight;
//底部按钮的高度
@property (nonatomic, assign) CGFloat functionHight;

/// 商品高度
@property(nonatomic, assign) CGFloat goodsHight;
/// 共有几个分类
@property (nonatomic, assign) NSInteger sectionCount;

/// 折叠部分在哪个分组
@property (nonatomic, assign) NSInteger stmDesSection;

/// 折叠部分cell 个数
@property (nonatomic, assign) NSInteger stmRows;

/// 初始化方法
/// @param orderModel 对应的orderModel
- (instancetype)initWithOrderModel:(HLBaseOrderModel *)orderModel;

/// 设置子视图大小
- (void)layoutSubViewFrames ;

/// 价格描述高度计算
- (CGFloat)calculatePriceDescHight;

/// 计算底部描述的高度
- (void)calculateBottomContentHight;


@end

NS_ASSUME_NONNULL_END
