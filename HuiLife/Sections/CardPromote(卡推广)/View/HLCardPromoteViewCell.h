//
//  HLCardPromoteViewCell.h
//  HuiLife
//
//  Created by 雷清华 on 2019/11/7.
//

#import <UIKit/UIKit.h>
#import "HLCardPromoteType.h"

NS_ASSUME_NONNULL_BEGIN
@class HLCardDiscount;
@protocol HLCardPromoteViewCellDelegate;

@interface HLCardPromoteViewCell : UITableViewCell

@property(nonatomic, weak) id<HLCardPromoteViewCellDelegate>delegate;

@property(nonatomic, strong)HLCardPromoteType *model;

@end

@interface HLCardDiscountViewCell : UITableViewCell

@property(nonatomic, strong) HLCardDiscount *model;

@end

@interface HLCardDiscount : NSObject

@property(nonatomic, copy) NSString *title;

@property(nonatomic, copy) NSString *set;

@property(nonatomic, copy) NSString *unit;

@property(nonatomic, copy) NSString *type;

@end


@protocol HLCardPromoteViewCellDelegate <NSObject>

- (void)cardPromoteCell:(HLCardPromoteViewCell *)cell switchOn:(BOOL)on;

@end


NS_ASSUME_NONNULL_END
