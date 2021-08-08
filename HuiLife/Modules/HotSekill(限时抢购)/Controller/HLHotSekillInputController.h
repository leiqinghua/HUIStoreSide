//
//  HLHotSekillInputController.h
//  HuiLife
//
//  Created by 王策 on 2019/8/6.
//

#import "HLBaseViewController.h"
#import "HLRightInputViewCell.h"
#import "HLInputDateViewCell.h"
#import "HLRightDownSelectCell.h"
#import "HLDownSelectView.h"
#import "HLHotSekillDetailController.h"
#import "HLCalendarViewController.h"
#import "HLTimeSingleSelectView.h"
#import "HLInputUseDescViewCell.h"
#import "HLHotSekillDef.h"
#import "HLHotSekillTransporter.h"


NS_ASSUME_NONNULL_BEGIN

@interface HLHotSekillInputController : HLBaseViewController

/// 是否为编辑
@property (nonatomic, assign) BOOL isEdit;

/// 编辑的 item 的 id
@property (nonatomic, copy) NSString *editId;

/// 秒杀类型
@property (nonatomic, assign) HLHotSekillType sekillType;

/// 存放数据 model
@property (nonatomic, copy) NSArray *dataSource;

@end

NS_ASSUME_NONNULL_END
