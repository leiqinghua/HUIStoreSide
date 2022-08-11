//
//  HLSendOrderMoneyInputCell.h
//  HuiLife
//
//  Created by 王策 on 2019/8/9.
//

#import <UIKit/UIKit.h>
#import "HLSendOrderMoneyInfo.h"

NS_ASSUME_NONNULL_BEGIN

@class HLSendOrderMoneyInputCell;
@protocol HLSendOrderMoneyInputCellDelegate <NSObject>

/// 删除
- (void)inputCell:(HLSendOrderMoneyInputCell *)cell deleteInputInfo:(HLSendOrderMoneyInputInfo *)inputInfo;

@end

@interface HLSendOrderMoneyInputCell : UITableViewCell

@property (nonatomic, weak) id <HLSendOrderMoneyInputCellDelegate> delegate;

@property (nonatomic, strong) HLSendOrderMoneyInputInfo *inputInfo;

@property (nonatomic, assign) NSInteger index;

@end

NS_ASSUME_NONNULL_END
