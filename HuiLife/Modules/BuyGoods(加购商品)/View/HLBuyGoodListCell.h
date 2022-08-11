//
//  HLBuyGoodListCell.h
//  HuiLife
//
//  Created by 王策 on 2019/8/6.
//

#import <UIKit/UIKit.h>
#import "HLBuyGoodListModel.h"

NS_ASSUME_NONNULL_BEGIN

@class HLBuyGoodListCell;
@protocol HLBuyGoodListCellDelegate <NSObject>

- (void)listCell:(HLBuyGoodListCell *)cell controlGoodModel:(HLBuyGoodListModel *)goodModel;

@end

@interface HLBuyGoodListCell : UITableViewCell

@property (nonatomic, weak) id <HLBuyGoodListCellDelegate> delegate;

@property (nonatomic, strong) HLBuyGoodListModel *goodModel;

@end

NS_ASSUME_NONNULL_END
