//
//  HLDayDealGoodController.h
//  HuiLife
//
//  Created by 雷清华 on 2020/11/17.
//

#import "HLBaseViewController.h"

NS_ASSUME_NONNULL_BEGIN
typedef void(^HLDayDealBlock)(NSString *,NSString *);
@interface HLDayDealGoodController : HLBaseViewController

@property(nonatomic, copy) HLDayDealBlock dayDealBlock;

@property(nonatomic, copy) NSString *goodId;

@end

NS_ASSUME_NONNULL_END
