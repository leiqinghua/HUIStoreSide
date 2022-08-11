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

// 请求商品列表的mode，短视频为 1  推送为 0
@property (nonatomic, assign) NSInteger mode;

// 当前选择的type
@property (nonatomic, assign) NSInteger type;

// 选择的数据回调
@property (nonatomic, copy) void(^productSelectBlock)(HLVideoProductModel *proModel, NSInteger type);

@end

NS_ASSUME_NONNULL_END
