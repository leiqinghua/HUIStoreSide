//
//  HLRedBagAlertController.h
//  HuiLife
//
//  Created by 雷清华 on 2020/11/18.
//

#import "HLBaseViewController.h"

NS_ASSUME_NONNULL_BEGIN

typedef void(^HLPaySuccess)(NSString *);
@interface HLRedBagAlertController : HLBaseViewController
@property(nonatomic, copy) NSString *extendId;
@property(nonatomic, copy) NSString *proId;
@property(nonatomic, assign) BOOL hideTime;
@property(nonatomic, copy) HLPaySuccess successBlock;
@end

NS_ASSUME_NONNULL_END
