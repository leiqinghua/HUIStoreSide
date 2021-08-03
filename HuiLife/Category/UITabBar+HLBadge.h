//
//  UITabBar+HLBadge.h
//  HuiLife
//
//  Created by 闻喜惠生活 on 2018/9/12.
//

#import <UIKit/UIKit.h>

@interface UITabBar (HLBadge)

- (void)showBadgeOnItemIndex:(int)index;

- (void)hideBadgeOnItemIndex:(int)index;
//是否有红点
- (BOOL)isHaveBadge:(int)index;

@end
