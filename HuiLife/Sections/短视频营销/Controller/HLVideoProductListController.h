//
//  HLVideoProductListController.h
//  HuiLife
//
//  Created by 王策 on 2021/4/23.
//

#import "HLBaseViewController.h"

NS_ASSUME_NONNULL_BEGIN
@class HLVideoProductModel;
@interface HLVideoProductListController : HLBaseViewController

// 类型 外卖 0  秒杀 1
@property (nonatomic, assign) NSInteger type;

// 选择的pro_id，如果匹配，那么显示已选择
@property (nonatomic, copy) NSString *pro_id;

// 请求商品列表的mode，短视频为 1  推送为 0
@property (nonatomic, assign) NSInteger mode;

// 选择的数据回调，这里使用 name and pro_id
@property (nonatomic, copy) void(^productSelectBlock)(HLVideoProductModel *proModel, NSInteger type);


@end

NS_ASSUME_NONNULL_END
