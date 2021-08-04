//
//  HLSendOrderSecondCell.h
//  HuiLife
//
//  Created by 王策 on 2019/8/8.
//

#import <UIKit/UIKit.h>
#import "HLSendOrderMainInfo.h"
NS_ASSUME_NONNULL_BEGIN

@class HLSendOrderSecondCell;
@protocol HLSendOrderSecondCellDelegate <NSObject>

/// 点击功能按钮
- (void)secondFuncCell:(HLSendOrderSecondCell *)cell clickFuncInfo:(HLSendOrderSecondFuncInfo *)funcInfo;

/// switch 开关管理
- (void)switchValueChangeWithSecondFuncCell:(HLSendOrderSecondCell *)cell;

@end

@interface HLSendOrderSecondCell : UITableViewCell

@property (nonatomic, weak) id <HLSendOrderSecondCellDelegate> delegate;

@property (nonatomic, strong) HLSendOrderSecondInfo *secondInfo;

@end

NS_ASSUME_NONNULL_END
