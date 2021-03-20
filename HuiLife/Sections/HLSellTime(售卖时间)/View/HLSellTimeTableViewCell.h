//
//  HLSellTimeTableViewCell.h
//  HuiLife
//
//  Created by 雷清华 on 2020/3/30.
//

#import "HLBaseTableViewCell.h"
#import "HLSellModel.h"
NS_ASSUME_NONNULL_BEGIN
@protocol HLSellTimeTableCellDelegate;
@interface HLSellTimeTableViewCell : HLBaseTableViewCell

@property(nonatomic, strong) HLSellModel *model;

@property(nonatomic, weak) id<HLSellTimeTableCellDelegate>delegate;

@end

@protocol HLSellTimeTableCellDelegate <NSObject>

- (void)sellTimeWithModel:(HLSellModel *)model clickIndex:(NSInteger)index;

@end


NS_ASSUME_NONNULL_END
