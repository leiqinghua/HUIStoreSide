//
//  HLHotBuyAddController.h
//  HuiLife
//
//  Created by 王策 on 2019/10/23.
//

#import "HLBaseViewController.h"

NS_ASSUME_NONNULL_BEGIN

typedef void(^HLHotBuyAddCallBack)(void);

@interface HLHotBuyAddController : HLBaseViewController

@property (nonatomic, copy) HLHotBuyAddCallBack callBack;

@end

NS_ASSUME_NONNULL_END
