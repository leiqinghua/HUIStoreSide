//
//  HLCardDiscountController.h
//  HuiLife
//
//  Created by 雷清华 on 2019/11/7.
//

#import "HLBaseViewController.h"

NS_ASSUME_NONNULL_BEGIN

typedef void(^HLCardModifyDiscount)(NSString *discount);


@interface HLCardDiscountController : HLBaseViewController

@property(nonatomic, copy) HLCardModifyDiscount modifyDiscountBlock;

- (instancetype)initWithType:(NSString *)type ;

@end


@interface HLDiscountButton : UIView

@property(nonatomic, assign) BOOL selected;

@property(nonatomic, copy) NSString *discount;

- (void)addtarget:(id)target selector:(SEL)selector;

@end

NS_ASSUME_NONNULL_END
