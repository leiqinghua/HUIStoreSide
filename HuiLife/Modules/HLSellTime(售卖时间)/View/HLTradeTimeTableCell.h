//
//  HLTradeTimeTableCell.h
//  HuiLife
//
//  Created by 雷清华 on 2020/3/30.
//

#import "HLBaseTableViewCell.h"
#import "HLSellModel.h"

NS_ASSUME_NONNULL_BEGIN
@class HLTradeTimeItemCell;
@protocol HLTradeTimeItemDelegate;
@interface HLTradeTimeTableCell : HLBaseTableViewCell

@property(nonatomic, strong) HLSellModel *model;

@property(nonatomic, strong) NSArray *timeData;

@end


@interface HLTradeTimeItemCell : UITableViewCell

//0 添加，1删除
@property(nonatomic, assign) NSInteger optionType;

@property(nonatomic, weak) id<HLTradeTimeItemDelegate> delegate;

@property(nonatomic, strong) HLTimeModel *model;

@end


@protocol HLTradeTimeItemDelegate <NSObject>

- (void)tradeTime:(HLTimeModel *)timeModel add:(BOOL)isAdd;

- (void)tradeTime:(HLTimeModel *)timeModel begin:(BOOL)begin dependView:(UIView *)dependView;

@end

NS_ASSUME_NONNULL_END
