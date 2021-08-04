//
//  HLHotSekillListController.h
//  HuiLife
//
//  Created by 王策 on 2019/8/6.
//

#import "HLBaseViewController.h"
#import "HLHotSekillListViewCell.h"

typedef void(^HLHotSekillSelectBlock)(HLHotSekillGoodModel *goodModel);

NS_ASSUME_NONNULL_BEGIN

@interface HLHotSekillListController : HLBaseViewController

@property (nonatomic, copy) HLHotSekillSelectBlock selectBlock;

@end

NS_ASSUME_NONNULL_END
