//
//  HLHotSekillListController.h
//  HuiLife
//
//  Created by 王策 on 2019/8/6.
//

#import "HLBaseViewController.h"
#import "HLHotSekillListViewCell.h"
#import "HLHotSekillDef.h"

typedef void(^HLHotSekillSelectBlock)(HLHotSekillGoodModel * _Nullable goodModel);

NS_ASSUME_NONNULL_BEGIN

@interface HLHotSekillListController : HLBaseViewController

/// 选择时使用
@property (nonatomic, copy) HLHotSekillSelectBlock selectBlock;

/// 类型
@property (nonatomic, copy) NSString *type;

/// 不知道干啥的，安卓有
@property (nonatomic, assign) NSInteger from;

@end

NS_ASSUME_NONNULL_END
