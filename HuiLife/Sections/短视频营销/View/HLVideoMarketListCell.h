//
//  HLVideoMarketListCell.h
//  HuiLife
//
//  Created by 王策 on 2021/4/21.
//

#import <UIKit/UIKit.h>
#import "HLVideoMarketModel.h"

//https://sapi.51huilife.cn/HuiLife_Api/sortVideo/change.php
//video_id    35
//state    0
//pid    1346191
//id    66118
//token    1waunA1KzaRI8nEu1oiq

@class HLVideoMarketListCell;
@protocol HLVideoMarketListCellDelegate <NSObject>

/// 点击被驳回的原因
- (void)marketListCell:(HLVideoMarketListCell *)cell reasonClickWithModel:(HLVideoMarketModel *)model;

/// 点击上下架控制按钮
- (void)marketListCell:(HLVideoMarketListCell *)cell controlClickWithModel:(HLVideoMarketModel *)model;

/// 点击编辑按钮
- (void)marketListCell:(HLVideoMarketListCell *)cell editClickWithModel:(HLVideoMarketModel *)model;

/// 点击播放
- (void)marketListCell:(HLVideoMarketListCell *)cell playClickWithModel:(HLVideoMarketModel *)model;

@end

NS_ASSUME_NONNULL_BEGIN

@interface HLVideoMarketListCell : UITableViewCell

@property (nonatomic, strong) HLVideoMarketModel *listModel;
@property (nonatomic, weak) id <HLVideoMarketListCellDelegate> delegate;

@end

NS_ASSUME_NONNULL_END
