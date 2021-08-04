//
//  HLSendOrderCodeAddController.h
//  HuiLife
//
//  Created by 王策 on 2019/8/9.
//

#import "HLBaseViewController.h"

typedef void(^HLSendOrderCodeAddBlock)(void);

NS_ASSUME_NONNULL_BEGIN

@interface HLSendOrderCodeAddController : HLBaseViewController

/// 传入桌号，说明是编辑
@property (nonatomic, copy) NSString *tableId;

@property (nonatomic, copy) NSString *type;

@property (nonatomic, copy) HLSendOrderCodeAddBlock addBlock;

@end

NS_ASSUME_NONNULL_END
