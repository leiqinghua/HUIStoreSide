//
//  HLCardSelectController.h
//  HuiLife
//
//  Created by 闻喜惠生活 on 2019/8/10.
//

#import "HLBaseViewController.h"

NS_ASSUME_NONNULL_BEGIN

typedef void(^HLCardPromoteBlock)(NSString * name,NSString * price,NSString * Id);

@interface HLCardSelectController : HLBaseViewController

@property(nonatomic,copy)HLCardPromoteBlock cardPromoteBlock;

@end

NS_ASSUME_NONNULL_END
