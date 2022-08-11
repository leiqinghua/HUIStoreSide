//
//  HLSetShopControlCell.h
//  HuiLife
//
//  Created by 王策 on 2021/4/21.
//

#import <UIKit/UIKit.h>
#import "HLSetStoreModel.h"

@class HLSetShopControlCell;
@protocol HLSetShopControlCellDelegate <NSObject>

/// 编辑
- (void)controlCell:(HLSetShopControlCell *)cell editWithStoreModel:(HLSetStoreModel *)model;

/// 删除
- (void)controlCell:(HLSetShopControlCell *)cell delWithStoreModel:(HLSetStoreModel *)model;

@end
NS_ASSUME_NONNULL_BEGIN

@interface HLSetShopControlCell : UITableViewCell

@property (nonatomic, strong) HLSetStoreModel *storeModel;

@property (nonatomic, weak) id <HLSetShopControlCellDelegate> delegate;

@end

NS_ASSUME_NONNULL_END
