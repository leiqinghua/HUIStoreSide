//
//  HLVideoProductSelectController.h
//  HuiLife
//
//  Created by 王策 on 2021/4/23.
//

#import "HLBaseViewController.h"

NS_ASSUME_NONNULL_BEGIN
@class HLVideoProductModel;
@interface HLVideoProductSelectController : HLBaseViewController

// 当前选择的 pro_id
@property (nonatomic, copy) NSString *pro_id;

// 选择的数据回调
@property (nonatomic, copy) void(^productSelectBlock)(HLVideoProductModel *proModel, NSInteger type);

@end

NS_ASSUME_NONNULL_END
