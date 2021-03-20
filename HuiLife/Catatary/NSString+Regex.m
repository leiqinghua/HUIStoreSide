//
//  NSString+Regex.m
//  HuiLife
//
//  Created by 闻喜惠生活 on 2018/7/12.
//

#import "NSString+Regex.h"

@implementation NSString (Regex)

- (BOOL)hl_inputShouldNumber {
    if (self.length == 0) return NO;
    NSString *regex =@"[0-9]*";
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",regex];
    return [pred evaluateWithObject:self];
}

-(BOOL)isPhoneNum{
    //    电信号段:133/153/180/181/189/177
    //    联通号段:130/131/132/155/156/185/186/145/176
    //    移动号段:134/135/136/137/138/139/150/151/152/157/158/159/182/183/184/187/188/147/178
    //    虚拟运营商:170
    
    NSString *MOBILE = @"^1(3[0-9]|4[57]|5[0-35-9]|8[0-9]|7[06-8])\\d{8}$";
    
    NSPredicate *regextestmobile = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", MOBILE];
    return [regextestmobile evaluateWithObject:self];
}

- (BOOL)hl_inputShouldLetter {
    if (self.length == 0) return NO;
    NSString *regex =@"[a-zA-Z]*";
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",regex];
    return [pred evaluateWithObject:self];
}

- (BOOL)hl_inputShouldLetterOrNum {
    BOOL hasLetter = NO;
    BOOL hasNum = NO;
    for (int i=0; i<self.length; i++) {
        int charAssci = [self characterAtIndex:i];
        if (charAssci >= 48 && charAssci <= 57) {
            hasNum = YES;
        }
        if ((charAssci >= 65 && charAssci <= 90) || (charAssci >= 97 && charAssci <= 122)) {
            hasLetter = YES;
        }
    }
    return hasNum && hasLetter;
}

- (BOOL)hl_hasChinese {
    for(int i=0; i< [self length];i++){
        int a = [self characterAtIndex:i];
        if( a > 0x4e00 && a < 0x9fff)
        {
            return YES;
        }
    }
    return NO;
}

- (BOOL)hl_inputShouldChinese {
    if (self.length == 0) return NO;
    NSString *regex = @"[\u4e00-\u9fa5]+";
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",regex];
    return [pred evaluateWithObject:self];
}

//根据正则，过滤特殊字符
- (NSString *)filterwithRegex:(NSString *)regexStr {
    NSString *searchText = self;
    NSError *error = NULL;
    NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:regexStr options:NSRegularExpressionCaseInsensitive error:&error];
    NSString *result = [regex stringByReplacingMatchesInString:searchText options:NSMatchingReportCompletion range:NSMakeRange(0, searchText.length) withTemplate:@""];
    return result;
}

/// 计算高度
- (CGSize)hl_sizeForFont:(UIFont *)font size:(CGSize)size mode:(NSLineBreakMode)lineBreakMode {
    CGSize result;
    if (!font) font = [UIFont systemFontOfSize:12];
    if ([self respondsToSelector:@selector(boundingRectWithSize:options:attributes:context:)]) {
        NSMutableDictionary *attr = [NSMutableDictionary new];
        attr[NSFontAttributeName] = font;
        if (lineBreakMode != NSLineBreakByWordWrapping) {
            NSMutableParagraphStyle *paragraphStyle = [NSMutableParagraphStyle new];
            paragraphStyle.lineBreakMode = lineBreakMode;
            attr[NSParagraphStyleAttributeName] = paragraphStyle;
        }
        CGRect rect = [self boundingRectWithSize:size
                                         options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading
                                      attributes:attr context:nil];
        result = rect.size;
    } else {
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
        result = [self sizeWithFont:font constrainedToSize:size lineBreakMode:lineBreakMode];
#pragma clang diagnostic pop
    }
    return result;
}
/// 计算宽度
- (CGFloat)hl_widthForFont:(UIFont *)font {
    CGSize size = [self hl_sizeForFont:font size:CGSizeMake(MAXFLOAT, MAXFLOAT) mode:NSLineBreakByWordWrapping];
    return size.width;
}

/// 计算高度
- (CGFloat)hl_heightForFont:(UIFont *)font width:(CGFloat)width {
    CGSize size = [self hl_sizeForFont:font size:CGSizeMake(width, MAXFLOAT) mode:NSLineBreakByWordWrapping];
    return size.height;
}

/// 根据字体大小，字间距，行高获取高度
- (CGFloat)hl_heightWithFont:(UIFont *)font width:(CGFloat)width lineSpace:(CGFloat)lineSpace kern:(CGFloat)kern{
    NSMutableParagraphStyle *paragraphStyle = [NSMutableParagraphStyle new];
    paragraphStyle.lineSpacing = lineSpace;
    NSDictionary *attriDict = @{
                                NSParagraphStyleAttributeName:paragraphStyle,
                                NSKernAttributeName:@(kern),
                                NSFontAttributeName:font};
    CGSize size = [self boundingRectWithSize:CGSizeMake(width, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:attriDict context:nil].size;
    return size.height;
}

+ (BOOL) isEmpty:(NSString *) str {
    if (!str) {
        return true;
    } else {
        NSCharacterSet *set = [NSCharacterSet whitespaceAndNewlineCharacterSet];
        NSString *trimedString = [str stringByTrimmingCharactersInSet:set];
        if ([trimedString length] == 0) {
            return true;
        } else {
            return false;
        }
    }
}
//6-20位密码数字或字符
+ (BOOL)hl_isSafePassword:(NSString *)strPwd{
    //@"^((?![0-9]+$)(?![a-zA-Z]+$)(?![~!@#$^&|*-_+=.?,]+$))[0-9A-Za-z~!@#$^&|*-_+=.?,]{6,20}$"
    NSString *passWordRegex = @"[0-9A-Za-z~!@#$^&|*-_+=.?,]{6,20}$";   // 数字，字符或符号至少两种
    NSPredicate *regextestcm = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", passWordRegex];
    
    if ([regextestcm evaluateWithObject:strPwd])
    {
        return YES;
    }
    else
    {
        return NO;
    }
}

//是否大于比较的时间(拿有效时间去比较,date 可以为空)
//isdate:是否是年月日或年月
-(BOOL)compairDate:(NSString *)date isDate:(BOOL)isdate{
    BOOL isDY = YES;
    NSArray * array1;
    NSArray * array2;
    if (isdate) {
        array1 = [self componentsSeparatedByString:@"-"];
        array2 = [date componentsSeparatedByString:@"-"];
    }else{
        array1 = [self componentsSeparatedByString:@":"];
        array2 = [date componentsSeparatedByString:@":"];
    }
    for (int i = 0; i<array1.count; i++) {
        NSInteger date1 = [array1[i] integerValue];
        NSInteger date2 = [array2[i] integerValue];
        if (date1 < date2) {
            return NO;
        }else if (date1 > date2){
            return YES;
        }
    }
    return isDY;
}

+ (NSString *)UUID{
    return [[NSUUID UUID] UUIDString];;
}

+ (NSString *)hl_stringWithNoZeroMoney:(double)money{
    NSString * testNumber = [NSString stringWithFormat:@"%.2lf",money];
    // 如果有 .00
    if ([testNumber hasSuffix:@".00"]) {
        testNumber = [testNumber stringByReplacingOccurrencesOfString:@".00" withString:@""];
        return testNumber;
    }
    // 如果有 .但是只有一个0
    if([testNumber containsString:@"."] && [testNumber hasSuffix:@"0"]){
        NSMutableString *mString = [testNumber mutableCopy];
        [mString deleteCharactersInRange:NSMakeRange(testNumber.length - 1, 1)];
        return mString;
    }
    return testNumber;
}

// A-Z 0-9 组成的10位随机数
+ (NSString *)hl_randomNumberAndA_Z{
    NSArray *dataArr = @[@"0",@"1",@"2",@"3",@"4",@"5",@"6",@"7",@"8",@"9",@"A",@"B",@"C",@"D",@"E",@"F",@"G",@"H",@"I",@"J",@"K",@"L",@"M",@"N",@"O",@"P",@"Q",@"R",@"S",@"T",@"U",@"V",@"W",@"X",@"Y",@"Z"];
    NSMutableString *mString = [NSMutableString string];
    for (NSInteger i = 0; i < 10; i++) {
        NSInteger randomIndex = arc4random() % dataArr.count;
        [mString appendString:dataArr[randomIndex]];
    }
    return [mString copy];
}

// 时间戳
+ (NSString *)hl_timestamp{

    NSDateFormatter *formatter = [[NSDateFormatter alloc] init] ;

    [formatter setDateStyle:NSDateFormatterMediumStyle];

    [formatter setTimeStyle:NSDateFormatterShortStyle];

    [formatter setDateFormat:@"YYYY-MM-dd HH:mm:ss"];

    NSTimeZone* timeZone = [NSTimeZone timeZoneWithName:@"Asia/Shanghai"];

    [formatter setTimeZone:timeZone];

    NSDate *datenow = [NSDate date];

    NSString *timeSp = [NSString stringWithFormat:@"%ld", (long)[datenow timeIntervalSince1970]];

    return timeSp;
}

+ (NSString *)moneyPrefixWithMoney:(NSString *)money {
    if ([money containsString:@"¥"] || [money containsString:@"￥"]) {
        return money;
    }
    return [NSString stringWithFormat:@"¥%@",money];
}

/// 去除小数点后无效的0
+ (NSString *)hl_stringNoZeroWithDoubleValue:(double)doubleValue{
    NSString * testNumber = [NSString stringWithFormat:@"%.2lf",doubleValue];
    // 如果有 .00
    if ([testNumber hasSuffix:@".00"]) {
        testNumber = [testNumber stringByReplacingOccurrencesOfString:@".00" withString:@""];
        return testNumber;
    }
    // 如果有 .但是只有一个0
    if([testNumber containsString:@"."] && [testNumber hasSuffix:@"0"]){
        NSMutableString *mString = [testNumber mutableCopy];
        [mString deleteCharactersInRange:NSMakeRange(testNumber.length - 1, 1)];
        return mString;
    }
    return testNumber;
}

/**
 修改字符串中数字颜色, 并返回对应富文本
 
 @param color 数字颜色, 包括小数
 @param normalColor 默认颜色
 @return 结果富文本
 */
- (NSMutableAttributedString *)modifyDigitalColor:(UIColor *)color normalColor:(UIColor *)normalColor font:(UIFont *)font normalFont:(UIFont *)normalFont;
{
    NSRegularExpression *regular = [NSRegularExpression regularExpressionWithPattern:@"([0-9]\\d*\\.?\\d*)" options:0 error:NULL];
    NSArray<NSTextCheckingResult *> *ranges = [regular matchesInString:self options:0 range:NSMakeRange(0, [self length])];
    NSMutableAttributedString *attStr = [[NSMutableAttributedString alloc] initWithString:self attributes:@{NSForegroundColorAttributeName : normalColor,NSFontAttributeName:normalFont}];
    for (int i = 0; i < ranges.count; i++) {
        [attStr setAttributes:@{NSForegroundColorAttributeName : color,NSFontAttributeName:font} range:ranges[i].range];
    }
    return attStr;
}


/**
 带子节的string转为NSData
 @return NSData类型
 */
- (NSData*) convertBytesStringToData {
    NSMutableData* data = [NSMutableData data];
    int idx;
    for (idx = 0; idx+2 <= self.length; idx+=2) {
        NSRange range = NSMakeRange(idx, 2);
        NSString* hexStr = [self substringWithRange:range];
        NSScanner* scanner = [NSScanner scannerWithString:hexStr];
        unsigned int intValue;
        [scanner scanHexInt:&intValue];
        [data appendBytes:&intValue length:1];
    }
    return data;
}

- (Byte)convertToByte {
    // 转成 int  类型
    int endMinutes = [self intValue];
    Byte endMinuteByte = (Byte)0xff&endMinutes;
    return endMinuteByte;
}

@end
