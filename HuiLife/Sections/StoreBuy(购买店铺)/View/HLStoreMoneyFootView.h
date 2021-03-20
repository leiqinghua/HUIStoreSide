//
//  HLStoreMoneyFootView.h
//  HuiLife
//
//  Created by 王策 on 2019/8/30.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@class HLStoreMoneyFootView;
@protocol HLStoreMoneyFootViewDelegate <NSObject>

///
- (void)clickBuyButtonWithFootView:(HLStoreMoneyFootView *)footView;

@end

@interface HLStoreMoneyFootView : UIView

@property (nonatomic, weak) id <HLStoreMoneyFootViewDelegate> delegate;

- (void)configSaleMoney:(double)saleMoney shengMoney:(NSString *)shengMoney;

@end

NS_ASSUME_NONNULL_END
