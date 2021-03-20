//
//  UIColor+Common.h
//  HuiLife
//
//  Created by 闻喜惠生活 on 2018/7/13.
//

#import <UIKit/UIKit.h>

@interface UIColor (Common)

//随机颜色
+(instancetype)randomColor;

+(UIColor *) hl_StringToColor: (NSString *) stringToConvert;

+(UIColor *) hl_StringToColor: (NSString *) stringToConvert andAlpha:(CGFloat)alpha;

@end
