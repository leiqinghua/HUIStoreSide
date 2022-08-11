//
//  HLHotSekillDetailViewCell.h
//  HuiLife
//
//  Created by 王策 on 2019/8/7.
//

#import <UIKit/UIKit.h>
#import "HLHotSekillDetailInputModel.h"

NS_ASSUME_NONNULL_BEGIN

@class HLHotSekillDetailViewCell;
@protocol HLHotSekillDetailViewCellDelegate <NSObject>

/// 删除
- (void)detailViewCell:(HLHotSekillDetailViewCell *)cell deleteInputModel:(HLHotSekillDetailInputModel *)inputModel;

/// 弹出下拉框
- (void)detailViewCell:(HLHotSekillDetailViewCell *)cell showSelectDownView:(UIView *)dependView;

@end

@interface HLHotSekillDetailViewCell : UITableViewCell

@property (nonatomic, weak) id <HLHotSekillDetailViewCellDelegate> delegate;

@property (nonatomic, strong) HLHotSekillDetailInputModel *inputModel;

@end

NS_ASSUME_NONNULL_END
