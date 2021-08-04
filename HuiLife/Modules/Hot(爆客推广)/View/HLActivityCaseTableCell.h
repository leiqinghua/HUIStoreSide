//
//  HLActivityCaseTableCell.h
//  HuiLife
//
//  Created by 雷清华 on 2020/2/20.
//

#import "HLBaseTableViewCell.h"

NS_ASSUME_NONNULL_BEGIN
@class HLHotCaseInfo;
@interface HLActivityCaseTableCell : HLBaseTableViewCell

@property(nonatomic, strong) HLHotCaseInfo *caseInfo;

@end

NS_ASSUME_NONNULL_END
