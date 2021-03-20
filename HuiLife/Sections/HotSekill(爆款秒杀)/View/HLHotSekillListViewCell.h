//
//  HLHotSekillListViewCell.h
//  HuiLife
//
//  Created by 王策 on 2019/8/6.
//

#import <UIKit/UIKit.h>
#import "HLHotSekillGoodModel.h"
NS_ASSUME_NONNULL_BEGIN

@class HLHotSekillListViewCell;
@protocol HLHotSekillListViewCellDelegate <NSObject>

/// 点击更多按钮
- (void)listViewCell:(HLHotSekillListViewCell *)cell moreBtnClick:(HLHotSekillGoodModel *)goodModel;

@end

@interface HLHotSekillListViewCell : UITableViewCell

@property (nonatomic, weak) id <HLHotSekillListViewCellDelegate> delegate;

@property (nonatomic, strong) HLHotSekillGoodModel *goodModel;

/// 可以选中的那种
@property (nonatomic, assign) BOOL showSelectView;

@end

NS_ASSUME_NONNULL_END
