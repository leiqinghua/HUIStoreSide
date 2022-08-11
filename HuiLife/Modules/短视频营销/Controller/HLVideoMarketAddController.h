//
//  HLVideoMarketAddController.h
//  HuiLife
//
//  Created by 王策 on 2021/4/21.
//

#import "HLBaseViewController.h"
#import "HLVideoMarketModel.h"
NS_ASSUME_NONNULL_BEGIN

@interface HLVideoMarketAddController : HLBaseViewController

/// 编辑时传递过去的数据
@property (nonatomic, strong) HLVideoMarketModel *marketModel;

/// 添加或者编辑完成之后的回调
@property (nonatomic, copy) void(^addBlock)(void);

@end

NS_ASSUME_NONNULL_END
