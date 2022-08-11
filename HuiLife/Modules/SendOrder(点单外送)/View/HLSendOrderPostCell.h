//
//  HLSendOrderPostCell.h
//  HuiLife
//
//  Created by 王策 on 2019/8/8.
//

#import <UIKit/UIKit.h>
#import "HLSendOrderMainInfo.h"
NS_ASSUME_NONNULL_BEGIN

@class HLSendOrderPostCell;
@protocol HLSendOrderPostCellDelegate <NSObject>

/// 点击按钮
- (void)postCell:(HLSendOrderPostCell *)cell clickMainInfo:(HLSendOrderMainInfo *)mainInfo;

@end

@interface HLSendOrderPostCell : UITableViewCell

@property (nonatomic, weak) id <HLSendOrderPostCellDelegate> delegate;

@property (nonatomic, strong) HLSendOrderMainInfo *mainInfo;

@end

NS_ASSUME_NONNULL_END
