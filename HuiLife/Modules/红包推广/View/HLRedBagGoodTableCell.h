//
//  HLRedBagGoodTableCell.h
//  HuiLife
//
//  Created by 雷清华 on 2020/11/16.
//

#import <UIKit/UIKit.h>
#import "HLRedBagPromoteInfo.h"

NS_ASSUME_NONNULL_BEGIN
@protocol HLRedBagGoodTableCellDelegate;
@interface HLRedBagGoodTableCell : UITableViewCell
@property(nonatomic, weak) id<HLRedBagGoodTableCellDelegate>delegate;
@property(nonatomic, strong) HLRedBagPromoteInfo *info;
@end

@protocol HLRedBagGoodTableCellDelegate <NSObject>
//0-推广统计，1追加红包，2 暂停推广
- (void)redBagCell:(HLRedBagGoodTableCell *)cell promoteInfo:(HLRedBagPromoteInfo *)info type:(NSInteger)type;

@end
NS_ASSUME_NONNULL_END
