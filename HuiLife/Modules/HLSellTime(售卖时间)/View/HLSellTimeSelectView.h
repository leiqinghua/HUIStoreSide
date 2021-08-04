//
//  HLSellTimeSelectView.h
//  HuiLife
//
//  Created by 雷清华 on 2020/3/31.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface HLSellTimeSelectView : UIView

+ (void)showWithTitles:(NSArray *)times selectIndex:(NSInteger)index dependView:(UIView *)dependView completion:(void(^)(NSInteger))completion;

//能设置固定高度
+ (void)showWithTitles:(NSArray *)times selectIndex:(NSInteger)index height:(CGFloat)height dependView:(UIView *)dependView completion:(void(^)(NSInteger))completion;
@end

NS_ASSUME_NONNULL_END
