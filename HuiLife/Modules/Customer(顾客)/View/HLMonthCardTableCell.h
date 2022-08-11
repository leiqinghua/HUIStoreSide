//
//  HLMonthCardTableCell.h
//  HuiLife
//
//  Created by 雷清华 on 2020/9/7.
//

#import <UIKit/UIKit.h>

@class HLMonthActiveInfo;
NS_ASSUME_NONNULL_BEGIN

@interface HLMonthCardTableCell : UITableViewCell

@property(nonatomic, strong) HLMonthActiveInfo *monthInfo;

@end

NS_ASSUME_NONNULL_END
