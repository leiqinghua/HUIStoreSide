//
//  HLPrinterHelper.h
//  HuiLife
//
//  Created by 王策 on 2021/6/19.
//

#import <Foundation/Foundation.h>
#import "UIImage+Bitmap.h"

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSInteger, HLPrinterStyle) {
    HLPrinterStyleDefault,
    HLPrinterStyleCustom
};

/** 文字对齐方式 */
typedef NS_ENUM(NSInteger, HLTextAlignment) {
    HLTextAlignmentLeft = 0x00,
    HLTextAlignmentCenter = 0x01,
    HLTextAlignmentRight = 0x02
};

/** 字号 */
typedef NS_ENUM(NSInteger, HLFontSize) {
    HLFontSizeTitleSmalle = 0x00,
    HLFontSizeTitleMiddle = 0x11,
    HLFontSizeTitleBig = 0x22
};

@interface HLPrinterHelper : NSObject

/// 添加标题
- (void)appendText:(NSString *)text alignment:(HLTextAlignment)alignment fontSize:(HLFontSize)fontSize doubleHeight:(BOOL)isDoubleHeight;

/// 添加分割线
- (void)appendSeperatorLine;

/// 添加两列
- (void)appendTitle:(NSString *)title value:(NSString *)value doubleHeight:(BOOL)isDoubleHeight;

/// 添加三列的，分配的字符数分别为 16 6 10
- (void)appendLeftText:(NSString *)left middleText:(NSString *)middle rightText:(NSString *)right;

/// 添加二维码
- (void)appendQRCodeWithInfo:(NSString *)info;

/// 添加二维码，另一种方式
- (void)appendQRCodeWithInfo:(NSString *)info size:(NSInteger)size alignment:(HLTextAlignment)alignment;

-(void)printCutPaper;


#pragma mark - 基础操作

/// 换行
- (void)appendNewLine;

/// 回车
- (void)appendReturn;

/// 设置对齐方式
- (void)setAlignment:(HLTextAlignment)alignment;

/// 设置字体样式，高度加倍
- (void)setFontDoubleHeight;

/// 设置字体倍数
- (void)setFontSize:(HLFontSize)fontSize;

/// 添加文字，不换行
- (void)setText:(NSString *)text;

/**
 *  添加文字，不换行
 *
 *  @param text    文字内容
 *  @param maxChar 最多可以允许多少个字节,后面加...
 */
- (void)setText:(NSString *)text maxChar:(int)maxChar;

/// 设置偏移文字
- (void)setOffsetText:(NSString *)text;

/// 设置偏移量
- (void)setOffset:(NSInteger)offset;

/// 设置行间距
- (void)setLineSpace:(NSInteger)points;

/**
 *
 *
 *  @param size  1<= size <= 16,二维码的宽高相等
 */
- (void)setQRCodeSize:(NSInteger)size;

/**
 *  设置二维码的纠错等级
 *
 *  @param level 48 <= level <= 51
 */
- (void)setQRCodeErrorCorrection:(NSInteger)level;
/**
 *  获取最终的data
 *
 *  @return 最终的data
 */
- (NSData *)getFinalData;




@end

NS_ASSUME_NONNULL_END
