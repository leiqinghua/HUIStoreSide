//
//  HLAddProfitController.h
//  HuiLife
//
//  Created by 雷清华 on 2020/9/24.
//

#import "HLBaseViewController.h"

NS_ASSUME_NONNULL_BEGIN
@class HLProfitGoodInfo;
typedef void(^SaveProfitBlock)(HLProfitGoodInfo *);

@interface HLAddProfitController : HLBaseViewController
//用于编辑
@property(nonatomic, strong) HLProfitGoodInfo *editProfitInfo;

@property(nonatomic, copy) SaveProfitBlock saveProfitBlock;

//已经添加的类型
@property(nonatomic, strong) NSArray *addProfitTypes;

@end

NS_ASSUME_NONNULL_END
