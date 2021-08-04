//
//  HLBuyCardBottomBuyView.h
//  HuiLife
//
//  Created by 王策 on 2021/3/20.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@class HLBuyCardBottomBuyView;
@protocol HLBuyCardBottomBuyViewDelegate <NSObject>

- (void)buyButtonClickWithBuyView:(HLBuyCardBottomBuyView *)buyView;

@end

@interface HLBuyCardBottomBuyView : UIView

@property (nonatomic, weak) id <HLBuyCardBottomBuyViewDelegate> delegate;

- (void)configMoney:(double)money;

@end

NS_ASSUME_NONNULL_END
