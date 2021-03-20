//
//  HLProfitFooterView.h
//  HuiLife
//
//  Created by 雷清华 on 2020/9/24.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@class HLProfitOrderCell;
@class HLProfitOrderInfo;
@protocol HLProfitOrderCellDelegate;
@protocol HLProfitOrderViewDelegate;

@interface HLProfitFooterView : UIView

@property(nonatomic, strong, readonly) UILabel *detailLb;

- (void)initSubView;

@end

//折扣footer
@interface HLProfitDiscountView : HLProfitFooterView

@property(nonatomic, strong) NSArray *discounts;

@property(nonatomic, copy) NSString *discount;

- (void)selectAtIndex:(NSInteger)index;

- (void)configDefaultDiscountStr:(NSString *)discountStr;

@end

//订单折扣footer
@interface HLProfitOrderView : HLProfitFooterView

@property(nonatomic, strong) NSArray *orderDiscounts;
//获取所有折扣
@property(nonatomic, strong, readonly) NSMutableArray *datasource;

@property(nonatomic, weak) id<HLProfitOrderViewDelegate>delegate;

@end


@protocol HLProfitOrderViewDelegate <NSObject>

- (void)orderViewAdd:(BOOL)add allSource:(NSArray *)datasource;

@end


//外卖折扣cell
@interface HLProfitOrderCell : UITableViewCell

@property(nonatomic, weak) id<HLProfitOrderCellDelegate>delegate;

@property(nonatomic, assign) BOOL add;

@property(nonatomic, strong) HLProfitOrderInfo *info;

@end


@protocol HLProfitOrderCellDelegate <NSObject>

- (void)orderCell:(HLProfitOrderCell *)cell add:(BOOL)add;

@end




NS_ASSUME_NONNULL_END
