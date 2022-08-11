//
//  HLDistanceInputTableCell.h
//  HuiLife
//
//  Created by 雷清华 on 2020/5/18.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@class HLFeeBaseInfo;

@interface HLDistanceInputTableCell : UITableViewCell

@property(nonatomic, strong) HLFeeBaseInfo *baseInfo;

@property(nonatomic, assign) BOOL canEdit;

@end

NS_ASSUME_NONNULL_END
