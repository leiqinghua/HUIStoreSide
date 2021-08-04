//
//  HLDiscountSetTableCell.h
//  HuiLife
//
//  Created by 雷清华 on 2020/5/20.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@class HLDiscountInfo;
@class HLDiscountSetTableCell;

@protocol HLDiscountSetTableCellDelegate <NSObject>

- (void)discountCell:(HLDiscountSetTableCell *)cell add:(BOOL)add;

@end

@interface HLDiscountSetTableCell : UITableViewCell

@property(nonatomic, weak) id<HLDiscountSetTableCellDelegate> delegate;
@property(nonatomic, strong) HLDiscountInfo *info;
@property(nonatomic, assign) NSInteger limitNum;
@end

NS_ASSUME_NONNULL_END
