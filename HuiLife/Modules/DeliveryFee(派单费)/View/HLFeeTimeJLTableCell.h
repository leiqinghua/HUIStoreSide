//
//  HLFeeTimeJLTableCell.h
//  HuiLife
//
//  Created by 雷清华 on 2020/5/18.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
@class HLFeeBaseInfo;
@interface HLFeeTimeJLTableCell : UITableViewCell

@property(nonatomic, strong) NSArray *titles;
@property(nonatomic, strong) HLFeeBaseInfo *timeInfo;
@property(nonatomic, copy) void (^HLFeeTimeSelectBack)(void);
@end

NS_ASSUME_NONNULL_END
