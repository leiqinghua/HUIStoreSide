//
//  HLSendOrderRangeHead.h
//  HuiLife
//
//  Created by 王策 on 2019/8/9.
//

#import <UIKit/UIKit.h>
#import "HLSendOrderRangeInfo.h"
NS_ASSUME_NONNULL_BEGIN

@class HLSendOrderRangeHead;
@protocol HLSendOrderRangeHeadDelegate <NSObject>

/// 切换
- (void)rangeHead:(HLSendOrderRangeHead *)rangeHead isCustom:(BOOL)isCustom;

@end

@interface HLSendOrderRangeHead : UIView

@property (nonatomic, weak) id <HLSendOrderRangeHeadDelegate> delegate;

/// 配置数据
- (void)configDataWithRangeInfo:(HLSendOrderRangeInfo *)rangeInfo;

@end

NS_ASSUME_NONNULL_END
