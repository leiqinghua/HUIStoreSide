//
//  HLFeeTableViewHeader.h
//  HuiLife
//
//  Created by 王策 on 2021/6/8.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
@class HLFeeTableViewHeader;
@protocol HLFeeTableViewHeaderDelegate <NSObject>

- (void)feeTableHeader:(HLFeeTableViewHeader *)header switchChanged:(BOOL)switchOn;

@end

@interface HLFeeTableViewHeader : UIView

@property (nonatomic, weak) id <HLFeeTableViewHeaderDelegate> delegate;

- (void)configSwitchOn:(BOOL)switchOn;

@end

NS_ASSUME_NONNULL_END
