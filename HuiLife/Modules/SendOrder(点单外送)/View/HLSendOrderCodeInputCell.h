//
//  HLSendOrderCodeInputCell.h
//  HuiLife
//
//  Created by 王策 on 2019/8/10.
//

#import <UIKit/UIKit.h>
#import "HLSendOrderCodeInputInfo.h"

NS_ASSUME_NONNULL_BEGIN

@class HLSendOrderCodeInputCell;
@protocol HLSendOrderCodeInputCellDelegate <NSObject>

/// 删除
- (void)deleteBtnClickWithInputCell:(HLSendOrderCodeInputCell *)cell;

@end

@interface HLSendOrderCodeInputCell : UITableViewCell

@property (nonatomic, weak) id <HLSendOrderCodeInputCellDelegate> delegate;

@property (nonatomic, strong) HLSendOrderCodeInputInfo *inputInfo;

@property (nonatomic, assign) NSInteger index;


/**
 配置底部线是否显示

 @param showLine YES or No
 */
- (void)configBottomLine:(BOOL)showLine;

@end

NS_ASSUME_NONNULL_END
