//
//  HLVoucherBankQueryController.h
//  HuiLife
//
//  Created by 王策 on 2019/9/2.
//

#import "HLBaseViewController.h"

NS_ASSUME_NONNULL_BEGIN

/// 银行名称 联行号
typedef void(^HLVoucherBankSelectBlock)(NSString *bankName,NSString *bankId);

@interface HLVoucherBankQueryController : HLBaseViewController

@property (nonatomic, copy) HLVoucherBankSelectBlock selectBlock;

@end

NS_ASSUME_NONNULL_END
