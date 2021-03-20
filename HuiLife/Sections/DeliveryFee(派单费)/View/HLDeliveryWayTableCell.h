//
//  HLDeliveryWayTableCell.h
//  HuiLife
//
//  Created by 雷清华 on 2020/9/28.
//

#import <UIKit/UIKit.h>
#import "HLDeliveryWayInfo.h"
NS_ASSUME_NONNULL_BEGIN
@class HLDeliveryWayTableCell;
@protocol HLDeliveryWayTableCellDelegate <NSObject>

- (void)deliveryCell:(HLDeliveryWayTableCell *)cell deliveryInfo:(HLDeliveryWayInfo *)info;

- (void)deliveryCell:(HLDeliveryWayTableCell *)cell on:(BOOL)on;

@end

@interface HLDeliveryWayTableCell : UITableViewCell

@property(nonatomic, strong) HLDeliveryWayInfo *deliveryInfo;

@property(nonatomic, weak) id<HLDeliveryWayTableCellDelegate>delegate;

@end

@interface HLDeliveryRuleCell : UITableViewCell

@property(nonatomic, strong) HLDeliveryRule *rule;

- (void)configBackgroundColor:(UIColor *)color titleColor:(UIColor *)titleColor;

@end

NS_ASSUME_NONNULL_END
