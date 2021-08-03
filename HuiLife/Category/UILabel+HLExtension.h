//
//  UILabel+HLExtension.h
//  HuiLife
//
//  Created by 雷清华 on 2019/12/13.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface UILabel (HLExtension)

/// 创建lable 正常字体  单行
/// @param color 字体颜色字符串
/// @param font 字体值
+(instancetype)hl_regularWithColor:(NSString * )color font:(CGFloat)font;

/// 创建lable  单行
/// @param color 字体颜色字符串
/// @param font 字体值
/// @param bold 是否是粗体
+(instancetype)hl_singleLineWithColor:(NSString * )color font:(CGFloat)font bold:(BOOL)bold;

/// 创建lable
/// @param color 字体颜色字符串
/// @param font 字体值
/// @param bold 是否是粗体
/// @param num 几行显示
+(instancetype)hl_lableWithColor:(NSString * )color font:(CGFloat)font bold:(BOOL)bold numbers:(int)num;

@end

NS_ASSUME_NONNULL_END
