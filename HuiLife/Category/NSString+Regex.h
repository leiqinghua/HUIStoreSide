//
//  NSString+Regex.h
//  HuiLife
//
//  Created by 闻喜惠生活 on 2018/7/12.
//

#import <Foundation/Foundation.h>

@interface NSString (Regex)

//6-20位字母数字或字符
+ (BOOL)hl_isSafePassword:(NSString *)strPwd;

+ (NSString *)UUID;

+ (NSString *)hl_stringWithNoZeroMoney:(double)money;

// A-Z 0-9 组成的10位随机数
+ (NSString *)hl_randomNumberAndA_Z;

// 时间戳
+ (NSString *)hl_timestamp;

//在金额前面添加 ¥
+ (NSString *)moneyPrefixWithMoney:(NSString *)money;

/// 去除小数点后无效的0
+ (NSString *)hl_stringNoZeroWithDoubleValue:(double)doubleValue;
/**
 判断是否全是空格
 */
+ (BOOL) isEmpty:(NSString *) str;

/**
 正则判断全是数字
 */
- (BOOL)hl_inputShouldNumber;

/**
 正则判断是手机号码
 */
-(BOOL)isPhoneNum;
/**
 正则判断全是字母
 */
- (BOOL)hl_inputShouldLetter;

/**
 正则判断至少包含字母或数字，也可以包含其他字符
 */
- (BOOL)hl_inputShouldLetterOrNum;

/**
 正则判断全是汉字
 */
- (BOOL)hl_inputShouldChinese;

/// 是否含有汉字
- (BOOL)hl_hasChinese;
/**
 根据正则，过滤特殊字符
 */
- (NSString *)filterwithRegex:(NSString *)regexStr;

/// 计算宽度
- (CGFloat)hl_widthForFont:(UIFont *)font;

/// 计算高度
- (CGFloat)hl_heightForFont:(UIFont *)font width:(CGFloat)width ;
/// 计算高度
- (CGFloat)hl_heightWithFont:(UIFont *)font width:(CGFloat)width lineSpace:(CGFloat)lineSpace kern:(CGFloat)kern;
//是否大于比较的时间(拿有效时间去比较,date 可以为空)
//isdate:是否是年月日或年月
- (BOOL)compairDate:(NSString *)date isDate:(BOOL)isdate;

/**
 修改字符串中数字颜色, 并返回对应富文本
 
 @param color 数字颜色, 包括小数
 @param normalColor 默认颜色
 @return 结果富文本
 */
- (NSMutableAttributedString *)modifyDigitalColor:(UIColor *)color normalColor:(UIColor *)normalColor font:(UIFont *)font normalFont:(UIFont *)normalFont;

//将byte 字符串转成 NSData
- (NSData*)convertBytesStringToData;

- (Byte)convertToByte ;
@end
