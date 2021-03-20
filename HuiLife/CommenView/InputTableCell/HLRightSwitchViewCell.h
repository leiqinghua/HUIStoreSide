//
//  HLRightSwitchViewCell.h
//  HuiLife
//
//  Created by 王策 on 2019/8/10.
//

#import "HLBaseInputViewCell.h"


@interface HLRightSwitchInfo : HLBaseTypeInfo

@property (nonatomic, assign) BOOL switchOn;

@end

@class HLRightSwitchViewCell;

@protocol HLRightSwitchViewCellDelegate <NSObject>
/// 开关
- (void)switchViewCell:(HLRightSwitchViewCell *)cell switchChanged:(HLRightSwitchInfo *)switchInfo;

@end


@interface HLRightSwitchViewCell : HLBaseInputViewCell

@property (nonatomic, weak) id <HLRightSwitchViewCellDelegate> delegate;

@end

