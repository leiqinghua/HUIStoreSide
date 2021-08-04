//
//  HLOrderUserInfoViewCell.h
//  iOS13test
//
//  Created by 雷清华 on 2019/10/29.
//  Copyright © 2019 雷清华. All rights reserved.
//

#import "HLBaseTableViewCell.h"
#import "HLSubOrderModel.h"

NS_ASSUME_NONNULL_BEGIN

@protocol HLOrderUserInfoCellDelegate <NSObject>

@optional
//导航
- (void)hl_goToNavigatePage;

@end

@interface HLOrderUserInfoViewCell : HLBaseTableViewCell

@property(nonatomic, strong) HLBaseOrderModel *orderModel;

@property(nonatomic, weak) id<HLOrderUserInfoCellDelegate>delegate;

@end

NS_ASSUME_NONNULL_END
