//
//  HLVideoProductListController.h
//  HuiLife
//
//  Created by 王策 on 2021/4/23.
//

#import "HLBaseViewController.h"

NS_ASSUME_NONNULL_BEGIN

@interface HLVideoProductListController : HLBaseViewController

@property (nonatomic, assign) NSInteger type;

// 选择的pro_id，如果匹配，那么显示已选择
@property (nonatomic, copy) NSString *pro_id;

@end

NS_ASSUME_NONNULL_END
