//
//  HLDownSelectView.h
//  HuiLife
//
//  Created by 王策 on 2019/8/6.
//

#import <UIKit/UIKit.h>

typedef enum : NSUInteger {
    HLDownSelectTypeDown,   // 向上
    HLDownSelectTypeUp,     // 向下
    HLDownSelectTypeAuto    // 自动判断
} HLDownSelectType;

NS_ASSUME_NONNULL_BEGIN

// 选择时的回调
typedef void(^HLDownSelectCallBack)(NSInteger index);
// 隐藏时的回调
typedef void(^HLDownSelectHideCallBack)(void);

@interface HLDownSelectView : UIView

/**
 展示下拉视图

 @param titles 标题数组
 @param itemHeight item的高度
 @param dependView 依赖的view，下拉的宽度就是依赖view的宽度
 @param type 向上还是向下弹出
 @param maxNum 最多几个就开始滑动
 @param callBack 回调
 */
+ (void)showSelectViewWithTitles:(NSArray *)titles itemHeight:(CGFloat)itemHeight dependView:(UIView *)dependView showType:(HLDownSelectType)type maxNum:(CGFloat)maxNum callBack:(HLDownSelectCallBack)callBack;

+ (void)showSelectViewWithTitles:(NSArray *)titles currentTitle:(NSString *)currentTitle needShowSelect:(BOOL)needShowSelect showSeperator:(BOOL)showSeperator itemHeight:(CGFloat)itemHeight dependView:(UIView *)dependView showType:(HLDownSelectType)type maxNum:(CGFloat)maxNum hideCallBack:(HLDownSelectHideCallBack)hideCallBack callBack:(HLDownSelectCallBack)callBack;

@end

NS_ASSUME_NONNULL_END
