//
//  HLMonthCountController.h
//  HuiLife
//
//  Created by 雷清华 on 2020/9/7.
//

#import "HLBaseViewController.h"

@protocol HLMonthCountHeaderDelegate;

NS_ASSUME_NONNULL_BEGIN

@interface HLMonthCountController : HLBaseViewController

@end


@interface HLMonthCountHeader : UITableViewHeaderFooterView

@property(nonatomic, weak) id<HLMonthCountHeaderDelegate> delegate;

- (void)configDate:(NSString *)date num:(NSInteger)num;

@end


@protocol HLMonthCountHeaderDelegate <NSObject>

- (void)monthHeader:(HLMonthCountHeader *)header selectDate:(NSString *)date ;

@end

NS_ASSUME_NONNULL_END
