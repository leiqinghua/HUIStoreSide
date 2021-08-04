//
//  HLFeeSectionHeader.h
//  HuiLife
//
//  Created by 雷清华 on 2020/5/18.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@class HLFeeHeaderInfo;
@class HLFeeSectionHeader;

@protocol HLFeeSectionHeaderDelegate <NSObject>

- (void)header:(HLFeeSectionHeader *)header headerInfo:(HLFeeHeaderInfo *)headerInfo;

@end

@interface HLFeeSectionHeader : UITableViewHeaderFooterView

@property(nonatomic, strong) HLFeeHeaderInfo *headerInfo;
@property(nonatomic, weak) id<HLFeeSectionHeaderDelegate> delegate;

@end

NS_ASSUME_NONNULL_END
