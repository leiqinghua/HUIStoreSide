//
//  HLSekillPromoteAddController.h
//  HuiLife
//
//  Created by 王策 on 2019/8/10.
//

#import "HLBaseViewController.h"
#import "HLSekillPromoteListModel.h"

NS_ASSUME_NONNULL_BEGIN

typedef void(^HLSekillPromoteAddBlcok)(void);

@interface HLSekillPromoteAddController : HLBaseViewController

@property (nonatomic, copy) HLSekillPromoteAddBlcok addBlock;

@property (nonatomic, strong) HLSekillPromoteListModel *listModel;

@end

NS_ASSUME_NONNULL_END
