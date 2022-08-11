//
//  HLDiscountSetController.h
//  HuiLife
//
//  Created by 雷清华 on 2020/5/20.
//

#import "HLBaseViewController.h"

NS_ASSUME_NONNULL_BEGIN

@interface HLDiscountSetController : HLBaseViewController

@property(nonatomic, copy) void(^HLDiscountCallBack)(BOOL on);

@end

NS_ASSUME_NONNULL_END
