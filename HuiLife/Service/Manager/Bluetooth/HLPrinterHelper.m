//
//  HLPrinterHelper.m
//  HuiLife
//
//  Created by 王策 on 2021/6/19.
//

#import "HLPrinterHelper.h"
#import "MMScanViewController.h"
#define kLineWidth 32   // 每一行能有 32 个字符数，GBK 编码

#define kLeftMax 16
#define kMiddleMax 6
#define kRightMax 10

@interface HLPrinterHelper ()

/** 将要打印的排版后的数据 */
@property (strong, nonatomic)   NSMutableData *printerData;

@end

@implementation HLPrinterHelper

- (instancetype)init
{
    self = [super init];
    if (self) {
        [self defaultSetting];
    }
    return self;
}

- (void)defaultSetting
{
    _printerData = [[NSMutableData alloc] init];
    
    // 1.初始化打印机
    Byte initBytes[] = {0x1B,0x40};
    [_printerData appendBytes:initBytes length:sizeof(initBytes)];
    // 2.设置行间距为1/6英寸，约34个点
    // 另一种设置行间距的方法看这个 @link{-setLineSpace:}
    Byte lineSpace[] = {0x1B,0x32};
    [_printerData appendBytes:lineSpace length:sizeof(lineSpace)];
    // 3.设置字体:标准0x00，压缩0x01;
    Byte fontBytes[] = {0x1B,0x4D,0x00};
    [_printerData appendBytes:fontBytes length:sizeof(fontBytes)];

}

#pragma mark - 基本操作

/**
 *  换行
 */
- (void)appendNewLine
{
    Byte nextRowBytes[] = {0x0A};
    [_printerData appendBytes:nextRowBytes length:sizeof(nextRowBytes)];
}

/**
 *  回车
 */
- (void)appendReturn
{
    Byte returnBytes[] = {0x0D};
    [_printerData appendBytes:returnBytes length:sizeof(returnBytes)];
}

/**
 *  设置对齐方式
 *
 *  @param alignment 对齐方式：居左、居中、居右
 */
- (void)setAlignment:(HLTextAlignment)alignment
{
    Byte alignBytes[] = {0x1B,0x61,alignment};
    [_printerData appendBytes:alignBytes length:sizeof(alignBytes)];
}

/// 设置字体样式，高度加倍
- (void)setFontDoubleHeight{
    Byte typeBytes[] = {0x1d, 0x21, 0x01};
    [_printerData appendBytes:typeBytes length:sizeof(typeBytes)];
}

/**
 *  设置字体大小
 *
 *  @param fontSize 字号
 */
- (void)setFontSize:(HLFontSize)fontSize
{
    Byte fontSizeBytes[] = {0x1D,0x21,fontSize};
    [_printerData appendBytes:fontSizeBytes length:sizeof(fontSizeBytes)];
}

/**
 *  添加文字，不换行
 *
 *  @param text 文字内容
 */
- (void)setText:(NSString *)text
{
    
    NSStringEncoding enc = CFStringConvertEncodingToNSStringEncoding(kCFStringEncodingGB_18030_2000);
    NSData *data = [text dataUsingEncoding:enc];
    NSUInteger size = data.length;
    void *textdata = malloc(size);
    [data getBytes:textdata length:size];
    [_printerData appendBytes:textdata length:size];
    free(textdata);
}

/**
 *  添加文字，不换行
 *
 *  @param text    文字内容
 *  @param maxChar 最多可以允许多少个字节,后面加...
 */
- (void)setText:(NSString *)text maxChar:(int)maxChar
{
    NSStringEncoding enc = CFStringConvertEncodingToNSStringEncoding(kCFStringEncodingGB_18030_2000);
    NSData *data = [text dataUsingEncoding:enc];
    if (data.length > maxChar) {
        data = [data subdataWithRange:NSMakeRange(0, maxChar)];
        text = [[NSString alloc] initWithData:data encoding:enc];
        if (!text) {
            data = [data subdataWithRange:NSMakeRange(0, maxChar - 1)];
            text = [[NSString alloc] initWithData:data encoding:enc];
        }
        text = [text stringByAppendingString:@"..."];
    }
    [self setText:text];
}

/**
 *  设置偏移文字
 *
 *  @param text 文字
 */
- (void)setOffsetText:(NSString *)text
{
    // 1.计算偏移量,因字体和字号不同，所以计算出来的宽度与实际宽度有误差(小字体与22字体计算值接近)
    NSDictionary *dict = @{NSFontAttributeName:[UIFont systemFontOfSize:22.0]};
    NSAttributedString *valueAttr = [[NSAttributedString alloc] initWithString:text attributes:dict];
    int valueWidth = valueAttr.size.width + 1;
    
    // 2.设置偏移量
    [self setOffset:368 - valueWidth];
    
    // 3.设置文字
    [self setText:text];
}

/**
 *  设置偏移量
 *
 *  @param offset 偏移量
 */
- (void)setOffset:(NSInteger)offset
{
    NSInteger remainder = offset % 256;
    NSInteger consult = offset / 256;
    Byte spaceBytes2[] = {0x1B, 0x24, remainder, consult};
    [_printerData appendBytes:spaceBytes2 length:sizeof(spaceBytes2)];
}

/**
 *  设置行间距
 *
 *  @param points 多少个点
 */
- (void)setLineSpace:(NSInteger)points
{
    //最后一位，可选 0~255
    Byte lineSpace[] = {0x1B,0x33,points};
    [_printerData appendBytes:lineSpace length:sizeof(lineSpace)];
}

/**
 *  设置二维码模块大小
 *
 *  @param size  1<= size <= 16,二维码的宽高相等
 */
- (void)setQRCodeSize:(NSInteger)size
{
    Byte QRSize [] = {0x1D,0x28,0x6B,0x03,0x00,0x31,0x43,size};
    //    Byte QRSize [] = {29,40,107,3,0,49,67,size};
    [_printerData appendBytes:QRSize length:sizeof(QRSize)];
}

/**
 *  设置二维码的纠错等级
 *
 *  @param level 48 <= level <= 51
 */
- (void)setQRCodeErrorCorrection:(NSInteger)level
{
    Byte levelBytes [] = {0x1D,0x28,0x6B,0x03,0x00,0x31,0x45,level};
    //    Byte levelBytes [] = {29,40,107,3,0,49,69,level};
    [_printerData appendBytes:levelBytes length:sizeof(levelBytes)];
}

/**
 *  将二维码数据存储到符号存储区
 * [范围]:  4≤(pL+pH×256)≤7092 (0≤pL≤255,0≤pH≤27)
 * cn=49
 * fn=80
 * m=48
 * k=(pL+pH×256)-3, k就是数据的长度
 *
 *  @param info 二维码数据
 */
- (void)setQRCodeInfo:(NSString *)info
{
    NSInteger kLength = info.length + 3;
    NSInteger pL = kLength % 256;
    NSInteger pH = kLength / 256;
    
    Byte dataBytes [] = {0x1D,0x28,0x6B,pL,pH,0x31,0x50,48};
    //    Byte dataBytes [] = {29,40,107,pL,pH,49,80,48};
    [_printerData appendBytes:dataBytes length:sizeof(dataBytes)];
    NSData *infoData = [info dataUsingEncoding:NSUTF8StringEncoding];
    [_printerData appendData:infoData];
//        [self setText:info];
}

/**
 *  打印之前存储的二维码信息
 */
- (void)printStoredQRData
{
    Byte printBytes [] = {0x1D,0x28,0x6B,0x03,0x00,0x31,0x51,48};
    //    Byte printBytes [] = {29,40,107,3,0,49,81,48};
    [_printerData appendBytes:printBytes length:sizeof(printBytes)];
}

#pragma mark - 常用方法

/// 设置文字
/// @param text 文字
/// @param alignment 对齐方式
/// @param fontSize 文字大小
/// @param isDoubleHeight 是否为比较高样式的字体
- (void)appendText:(NSString *)text alignment:(HLTextAlignment)alignment fontSize:(HLFontSize)fontSize doubleHeight:(BOOL)isDoubleHeight
{
    // 1.文字对齐方式
    [self setAlignment:alignment];
    // 2.设置字号
    [self setFontSize:fontSize];
    if (isDoubleHeight) {
        [self setFontDoubleHeight];
    }
    // 3.设置标题内容
    [self setText:text];
    // 4.换行
    [self appendNewLine];
}


/// 左右两列样式
/// @param title 标题
/// @param value 内容
/// @param isDoubleHeight 是否为比较高样式的字体
- (void)appendTitle:(NSString *)title value:(NSString *)value doubleHeight:(BOOL)isDoubleHeight{
    // 设置对齐方式
    [self setAlignment:HLTextAlignmentLeft];
    // 设置字号
    [self setFontSize:HLFontSizeTitleSmalle];
    if (isDoubleHeight) {
        [self setFontDoubleHeight];
    }
    
    // 计算文本数量
    NSMutableString *string = [[NSMutableString alloc] initWithFormat:@"%@%@",title,value];
    // 计算和kLineWidth 的差值
    NSInteger defCount = kLineWidth - [self charactorNumberWithString:[string copy]];
    
    if (defCount > 0) {
        for (NSInteger i = 0; i < defCount; i++) {
            [string insertString:@" " atIndex:title.length + i];
        }
    }
    
    // 设置标题内容
    [self setText:string];
    // 换行
    [self appendNewLine];
}

- (void)appendTitle:(NSString *)title value:(NSString *)value valueOffset:(NSInteger)offset
{
    [self appendTitle:title value:value valueOffset:offset fontSize:HLFontSizeTitleSmalle];
}

- (void)appendTitle:(NSString *)title value:(NSString *)value valueOffset:(NSInteger)offset alignment:(HLTextAlignment)alignment{
    // 1.设置对齐方式
    [self setAlignment:alignment];
    // 2.设置字号
    [self setFontSize:HLFontSizeTitleSmalle];
    // 3.设置标题内容
    [self setText:title];
    // 4.设置内容偏移量
    [self setOffset:offset];
    // 5.设置实际值
    [self setText:value];
    // 6.换行
    [self appendNewLine];
}
- (void)appendTitle:(NSString *)title value:(NSString *)value valueOffset:(NSInteger)offset fontSize:(HLFontSize)fontSize
{
    // 1.设置对齐方式
    [self setAlignment:HLTextAlignmentLeft];
    // 2.设置字号
    [self setFontSize:fontSize];
    // 3.设置标题内容
    [self setText:title];
    // 4.设置内容偏移量
    [self setOffset:offset];
    // 5.设置实际值
    [self setText:value];
    // 6.换行
    [self appendNewLine];

}


/// 散列
/// @param left 左
/// @param middle 中
/// @param right 右
- (void)appendLeftText:(NSString *)left middleText:(NSString *)middle rightText:(NSString *)right
{
    [self setAlignment:HLTextAlignmentLeft];
    [self setFontSize:HLFontSizeTitleSmalle];
    NSInteger leftNum = [self charactorNumberWithString:left];
    NSInteger middleNum = [self charactorNumberWithString:middle];
    NSInteger rightNum = [self charactorNumberWithString:right];
    NSInteger defLeft = kLeftMax - leftNum;
    NSInteger defMiddle = kMiddleMax - middleNum;
    NSInteger defRight = kRightMax - rightNum;

    NSMutableString *string = [[NSMutableString alloc] init];
    if (defLeft < 0) {
        // 这里强制从第 8 个字符换行，不一定 8 个字符都是中文，所以还需要补足，如果商品名称前 8 个都是数字或者字母，就比较尴尬了
        NSString *subString = [left substringToIndex:8];
        NSInteger defSub = kLeftMax - [self charactorNumberWithString:subString];
        [string appendString:[left substringToIndex:8]];
        if (defSub > 0) {
            [string appendString:[self wordSpaceStringWithNum:defSub]];
        }
    }else{
        [string appendString:left];
        [string appendString:[self wordSpaceStringWithNum:defLeft]];
    }
    
    if (defMiddle > 0) {
        [string appendString:[self wordSpaceStringWithNum:defMiddle]];
    }
    [string appendString:middle];
    
    if (defRight > 0) {
        [string appendString:[self wordSpaceStringWithNum:defRight]];
    }
    [string appendString:right];
    
    if (defLeft < 0) {
        [string appendString:[left substringFromIndex:8]];
    }
    
    [self setText:[string copy]];
    
    [self appendNewLine];
    
}

- (void)appendLeftTextArray:(NSArray *)textArry
{
    [self setAlignment:HLTextAlignmentLeft];
    [self setFontSize:HLFontSizeTitleSmalle];
    NSInteger offset = 0;

    for (int i=0; i<textArry.count; i++) {
        [self setOffset:82*i + offset];
        [self setText:textArry[i]];
    }

    [self appendNewLine];
}

#pragma mark 图片
- (void)appendImage:(UIImage *)image alignment:(HLTextAlignment)alignment maxWidth:(CGFloat)maxWidth
{
    if (!image) {
        return;
    }
    
    // 1.设置图片对齐方式
    [self setAlignment:alignment];
    
    // 2.设置图片
    UIImage *newImage = [image imageWithscaleMaxWidth:maxWidth];
    
    NSData *imageData = [newImage bitmapData];
    [_printerData appendData:imageData];
    
    // 3.换行
    [self appendNewLine];
    
    // 4.打印图片后，恢复文字的行间距
    Byte lineSpace[] = {0x1B,0x32};
    [_printerData appendBytes:lineSpace length:sizeof(lineSpace)];
}

- (void)appendBarCodeWithInfo:(NSString *)info
{
    [self appendBarCodeWithInfo:info alignment:HLTextAlignmentCenter maxWidth:300];
}

- (void)appendBarCodeWithInfo:(NSString *)info alignment:(HLTextAlignment)alignment maxWidth:(CGFloat)maxWidth
{
    UIImage *barImage = [UIImage barCodeImageWithInfo:info];
    [self appendImage:barImage alignment:alignment maxWidth:maxWidth];
}

- (void)appendQRCodeWithInfo:(NSString *)info
{
    [self appendQRCodeWithInfo:info centerImage:nil alignment:HLTextAlignmentCenter maxWidth:180];
}

- (void)appendQRCodeWithInfo:(NSString *)info centerImage:(UIImage *)centerImage alignment:(HLTextAlignment)alignment maxWidth:(CGFloat )maxWidth
{
    UIImage *QRImage = [UIImage qrCodeImageWithInfo:info centerImage:centerImage width:maxWidth];
    [self appendImage:QRImage alignment:alignment maxWidth:maxWidth];
}

- (void)appendSeperatorLine
{
    // 添加分割线
    NSMutableString *string = [NSMutableString new];
    for (NSInteger i = 0; i < 32; i++) {
        [string appendString:@"-"];
    }
    
    [self appendText:[string copy] alignment:HLTextAlignmentCenter fontSize:HLFontSizeTitleSmalle doubleHeight:NO];
}

- (void)appendQRCodeWithInfo:(NSString *)info size:(NSInteger)size alignment:(HLTextAlignment)alignment
{
    [self setAlignment:alignment];
    [self setQRCodeSize:size];
    [self setQRCodeErrorCorrection:48];
    [self setQRCodeInfo:info];
    [self printStoredQRData];
    [self appendNewLine];
}

- (NSData *)getFinalData
{
    return _printerData;
}

-(void)printCutPaper{
    unsigned char m = 0;
    unsigned char data[] = {0x1D, 0x56, 0x30, m};
    [_printerData appendBytes:data length:4];
}

#pragma mark - Helper

/// 获取指定数量的字符串
- (NSString *)wordSpaceStringWithNum:(NSInteger)num{
    NSMutableString *string = [[NSMutableString alloc] init];
    for (NSInteger i = 0; i < num; i++) {
        [string appendString:@" "];
    }
    return [string copy];
}

/// 计算数量
- (NSUInteger)charactorNumberWithString:(NSString *)string
{
    NSStringEncoding encoding = CFStringConvertEncodingToNSStringEncoding(kCFStringEncodingGB_18030_2000);
    return [self charactorNumberWithEncoding:encoding string:string];
}

- (NSUInteger)charactorNumberWithEncoding:(NSStringEncoding)encoding string:(NSString *)string
{
    NSUInteger strLength = 0;
    char *p = (char *)[string cStringUsingEncoding:encoding];
    
    NSUInteger lengthOfBytes = [string lengthOfBytesUsingEncoding:encoding];
    for (int i = 0; i < lengthOfBytes; i++) {
        if (*p) {
            p++;
            strLength++;
        }
        else {
            p++;
        }
    }
    return strLength;
}

@end

