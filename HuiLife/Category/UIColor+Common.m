//
//  UIColor+Common.m
//  HuiLife
//
//  Created by 闻喜惠生活 on 2018/7/13.
//

#import "UIColor+Common.h"

@implementation UIColor (Common)

+(instancetype)randomColor{
    int red = (arc4random() % 256);
    int green = (arc4random() % 256);
    int blue = (arc4random() % 256);
    UIColor * color = [UIColor colorWithRed:red/255.0 green:green/255.0 blue:blue/255.0 alpha:1];
    return color;
}

+(UIColor *) hl_StringToColor: (NSString *) stringToConvert
{
    return [UIColor hl_StringToColor:stringToConvert andAlpha:1.0];
}

+ (UIColor *) hl_StringToColor: (NSString *) stringToConvert andAlpha:(CGFloat)alpha
{
    NSString *cString = [[stringToConvert stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] uppercaseString];
    
    // String should be 6 or 8 characters
    if ([cString length] < 6) return [UIColor clearColor];
    // strip 0X if it appears
    if ([cString hasPrefix:@"0X"]) cString = [cString substringFromIndex:2];
    if ([cString hasPrefix:@"#"]) cString = [cString substringFromIndex:1];
    if ([cString length] != 6) return [UIColor clearColor];
    
    NSRange range;
    range.location = 0;
    range.length = 2;
    NSString *rString = [cString substringWithRange:range];
    range.location = 2;
    NSString *gString = [cString substringWithRange:range];
    range.location = 4;
    NSString *bString = [cString substringWithRange:range];
    // Scan values
    unsigned int r, g, b;
    
    if (alpha >1.0 || alpha < 0) {
        alpha = 1.0;
    }
    
    [[NSScanner scannerWithString:rString] scanHexInt:&r];
    [[NSScanner scannerWithString:gString] scanHexInt:&g];
    [[NSScanner scannerWithString:bString] scanHexInt:&b];
    
    return [UIColor colorWithRed:((float) r / 255.0f)
                           green:((float) g / 255.0f)
                            blue:((float) b / 255.0f)
                           alpha:alpha];
}

@end
