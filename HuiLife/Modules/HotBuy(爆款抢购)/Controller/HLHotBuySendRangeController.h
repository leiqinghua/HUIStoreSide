//
//  HLHotBuySendRangeController.h
//  HuiLife
//
//  Created by 王策 on 2019/10/23.
//

#import "HLBaseViewController.h"

// 是否是自定义，距离
typedef void(^HLHotBuyRangeCallBack)(BOOL isCustom,NSInteger range);

NS_ASSUME_NONNULL_BEGIN

@interface HLHotBuySendRangeController : HLBaseViewController

@property (nonatomic, copy) HLHotBuyRangeCallBack callBack;

@end

NS_ASSUME_NONNULL_END
