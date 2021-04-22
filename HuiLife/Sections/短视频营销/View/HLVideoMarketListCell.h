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



@end

NS_ASSUME_NONNULL_BEGIN

@interface HLVideoMarketListCell : UITableViewCell

@property (nonatomic, strong) HLVideoMarketModel *listModel;
@property (nonatomic, weak) id <HLVideoMarketListCellDelegate> delegate;

@end

NS_ASSUME_NONNULL_END
