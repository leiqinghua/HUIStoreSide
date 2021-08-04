//
//  HLHotSekillListController.h
//  HuiLife
//
//  Created by 王策 on 2019/8/6.
//

#import "HLBaseViewController.h"
#import "HLHotSekillListViewCell.h"

typedef void(^HLHotSekillSelectBlock)(HLHotSekillGoodModel *goodModel);

typedef enum : NSUInteger {
    HLHotSekillTypeNormal = 10, // 到店活动套餐抢购
    HLHotSekillType20 = 20,     // 亿元券对换
    HLHotSekillType30 = 30,     // 新人引流到店
    HLHotSekillType40 = 40,     // 签约爆客推广
} HLHotSekillType;

NS_ASSUME_NONNULL_BEGIN

@interface HLHotSekillListController : HLBaseViewController

/// 选择时使用
@property (nonatomic, copy) HLHotSekillSelectBlock selectBlock;

/// 类型
@property (nonatomic, assign) HLHotSekillType  type;

/// 不知道干啥的，安卓有
@property (nonatomic, assign) NSInteger from;

@end

NS_ASSUME_NONNULL_END
