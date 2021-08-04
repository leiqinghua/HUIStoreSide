//
//  HLWithDrawalInputView.h
//  HuiLife
//
//  Created by 王策 on 2019/9/10.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@class HLWithDrawalInputView;
@protocol HLWithDrawalInputViewDelegate <NSObject>

/// 点击全部提现
- (void)clickAllMoneyBtnWithInputView:(HLWithDrawalInputView *)inputView;

/// 输入框价格改变
- (void)inputMoneyChanged:(NSString *)inputMoney inputView:(HLWithDrawalInputView *)inputView;

@end

@interface HLWithDrawalInputView : UIView

@property (nonatomic, assign) id <HLWithDrawalInputViewDelegate> delegate;

/// 配置输入框的金额
- (void)configWithdrawalMoney:(double)money;

/// 获取输入框的金额
- (NSString *)inputWithdrawalMoney;

/// 配置实际到账金额
- (void)configAcceptMoney:(double)acceptMoney;

@end

NS_ASSUME_NONNULL_END
