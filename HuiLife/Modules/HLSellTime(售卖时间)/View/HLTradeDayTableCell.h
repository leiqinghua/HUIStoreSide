//
//  HLTradeDayTableCell.h
//  HuiLife
//
//  Created by 雷清华 on 2020/3/30.
//

#import "HLBaseTableViewCell.h"
#import "HLSellModel.h"

NS_ASSUME_NONNULL_BEGIN
@protocol HLTradeDayTableCellDelegate;
@interface HLTradeDayTableCell : HLBaseTableViewCell

@property(nonatomic, strong) HLSellModel *model;

@property(nonatomic, weak) id<HLTradeDayTableCellDelegate>delegate;
@end

@protocol HLTradeDayTableCellDelegate <NSObject>

- (void)tradeDayWithMode:(HLSellModel *)model cancelAll:(BOOL)cancelAll;

@end

NS_ASSUME_NONNULL_END
