//
//  UIButton+HLExtension.h
//  HuiLife
//
//  Created by 雷清华 on 2019/12/13.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIButton (HLExtension)
/// 创建button
/// @param image 图片
/// @param select 是否选中
+ (instancetype)hl_regularWithImage:(NSString *)image select:(BOOL)select ;
/// 创建button
/// @param title title
/// @param color title 颜色
/// @param font title 字体
/// @param image 图片
+ (instancetype)hl_regularWithTitle:(NSString *)title titleColor:(NSString *)color font:(CGFloat)font image:(NSString *)image ;


/// 创建button
/// @param title title
/// @param color title 颜色
/// @param font title 字体
/// @param backImg 背景图片
+ (instancetype)hl_regularWithTitle:(NSString *)title titleColor:(NSString *)color font:(CGFloat)font backgroundImg:(NSString *)backImg;


/// 获取titleLable的size
/// @param title button的title
/// @param font 字体
/// @param size 最大size
- (CGSize)hl_estmateSizeWithTitle:(NSString *)title  Font:(UIFont*)font maxSize:(CGSize)size;

@end

NS_ASSUME_NONNULL_END
