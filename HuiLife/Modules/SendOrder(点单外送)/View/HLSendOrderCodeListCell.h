//
//  HLSendOrderCodeListCell.h
//  HuiLife
//
//  Created by 王策 on 2019/8/9.
//

#import <UIKit/UIKit.h>
#import "HLSendOrderCodeInfo.h"

NS_ASSUME_NONNULL_BEGIN
@class HLSendOrderCodeListCell;
@protocol HLSendOrderCodeListCellDelegate <NSObject>

/// 编辑
- (void)listCell:(HLSendOrderCodeListCell *)cell editCodeInfo:(HLSendOrderCodeInfo *)codeInfo;

/// 删除
- (void)listCell:(HLSendOrderCodeListCell *)cell delCodeInfo:(HLSendOrderCodeInfo *)codeInfo;

@end

@interface HLSendOrderCodeListCell : UITableViewCell

@property (nonatomic, weak) id <HLSendOrderCodeListCellDelegate> delegate;

@property (nonatomic, strong) HLSendOrderCodeInfo *codeInfo;

@end

NS_ASSUME_NONNULL_END
