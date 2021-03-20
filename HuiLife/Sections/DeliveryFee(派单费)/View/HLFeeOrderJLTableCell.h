//
//  HLFeeOrderJLTableCell.h
//  HuiLife
//
//  Created by 雷清华 on 2020/5/18.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@class HLFeeBaseInfo;
@interface HLFeeOrderJLTableCell : UITableViewCell
@property(nonatomic, strong) NSArray *orders;
@property(nonatomic, strong) HLFeeBaseInfo *orderInfo;

@end

NS_ASSUME_NONNULL_END
