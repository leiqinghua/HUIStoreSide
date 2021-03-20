//
//  UITabBar+HLBadge.m
//  HuiLife
//
//  Created by 闻喜惠生活 on 2018/9/12.
//

#import "UITabBar+HLBadge.h"
#define TabbarItemNums 5.0

@implementation UITabBar (HLBadge)

//显示红点
- (void)showBadgeOnItemIndex:(int)index{
    [self removeBadgeOnItemIndex:index];
    //新建小红点
    UIView *bview = [[UIView alloc]init];
    bview.tag = 888+index;
    bview.layer.cornerRadius = 2.5;
    bview.clipsToBounds = YES;
    bview.backgroundColor = [UIColor redColor];
    CGRect tabFram = self.frame;
    
    float percentX = (index+0.6)/TabbarItemNums;
    CGFloat x = ceilf(percentX*tabFram.size.width);
    CGFloat y = ceilf(0.1*tabFram.size.height);
    bview.frame = CGRectMake(x, y, 5, 5);
    [self addSubview:bview];
    [self bringSubviewToFront:bview];
}

//隐藏红点
-(void)hideBadgeOnItemIndex:(int)index{
    [self removeBadgeOnItemIndex:index];
}

//移除控件
- (void)removeBadgeOnItemIndex:(int)index{
    for (UIView*subView in self.subviews) {
        if (subView.tag == 888+index) {
            [subView removeFromSuperview];
        }
    }
}

-(BOOL)isHaveBadge:(int)index{
    for (UIView*subView in self.subviews) {
        if (subView.tag == 888+index) {
            return YES;
        }
    }
    return NO;
}
@end
