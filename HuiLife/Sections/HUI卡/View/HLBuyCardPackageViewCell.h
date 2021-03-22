//
//  HLBuyCardPackageViewCell.h
//  HuiLife
//
//  Created by 王策 on 2021/3/20.
//

#import <UIKit/UIKit.h>
#import "HLBuyCardPackageItemView.h"
NS_ASSUME_NONNULL_BEGIN

@interface HLBuyCardPackageViewModel : NSObject

@property (nonatomic, copy) NSString *tip;
@property (nonatomic, copy) NSArray <HLBuyCardPackageViewItem *>*items;
@property (nonatomic, assign) NSInteger selectIndex;

@property (nonatomic, assign) CGFloat cellHeight;

@end

@class HLBuyCardPackageViewCell;
@protocol HLBuyCardPackageViewCellDelegate <NSObject>

- (void)packageViewCell:(HLBuyCardPackageViewCell *)cell selectItem:(HLBuyCardPackageViewItem *)item;

@end

@interface HLBuyCardPackageViewCell : UITableViewCell

@property (nonatomic, strong) HLBuyCardPackageViewModel *model;

@property (nonatomic, weak) id <HLBuyCardPackageViewCellDelegate> delegate;

@end

NS_ASSUME_NONNULL_END
