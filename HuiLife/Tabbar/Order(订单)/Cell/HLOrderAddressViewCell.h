//
//  HLOrderAddressViewCell.h
//  HuiLife
//
//  Created by 雷清华 on 2020/1/13.
//

#import <UIKit/UIKit.h>
#import "HLBaseTableViewCell.h"

NS_ASSUME_NONNULL_BEGIN

@protocol HLOrderAddressDelegate <NSObject>
//导航页
- (void)hl_addressCellClickToNavigatePage;

@end

@class HLBaseOrderModel;
@interface HLOrderAddressViewCell : HLBaseTableViewCell

@property(nonatomic, strong) HLBaseOrderModel *orderModel;
@property(nonatomic, weak) id<HLOrderAddressDelegate>delegate;

@end

NS_ASSUME_NONNULL_END
