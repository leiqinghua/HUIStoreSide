//
//  HLHotBuyListViewCell.h
//  HuiLife
//
//  Created by 王策 on 2019/10/23.
//

#import <UIKit/UIKit.h>
#import "HLHotBuyListModel.h"
NS_ASSUME_NONNULL_BEGIN

@class HLHotBuyListViewCell;
@protocol HLHotBuyListViewCellDelegate <NSObject>

/// 点击更多按钮
- (void)listViewCell:(HLHotBuyListViewCell *)cell moreBtnClick:(HLHotBuyListModel *)goodModel;

@end

@interface HLHotBuyListViewCell : UITableViewCell

@property (nonatomic, weak) id <HLHotBuyListViewCellDelegate> delegate;

@property (nonatomic, strong) HLHotBuyListModel *listModel;

@end

NS_ASSUME_NONNULL_END
