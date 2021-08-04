//
//  HLVoucherMarketAddController.h
//  HuiLife
//
//  Created by 王策 on 2019/8/2.
//

#import "HLBaseViewController.h"

NS_ASSUME_NONNULL_BEGIN

typedef void(^HLVoucherMarketAddBlock)(void);

@interface HLVoucherMarketAddController : HLBaseViewController

/// 需要加载数据
@property (nonatomic, copy) NSString *state;

/// 状态改变后的回调
@property (nonatomic, copy) HLVoucherMarketAddBlock addBlock;

@end

NS_ASSUME_NONNULL_END
