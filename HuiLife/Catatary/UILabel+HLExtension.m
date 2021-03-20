//
//  UILabel+HLExtension.m
//  HuiLife
//
//  Created by 雷清华 on 2019/12/13.
//

#import "UILabel+HLExtension.h"

@implementation UILabel (HLExtension)

+ (instancetype)hl_regularWithColor:(NSString * )color font:(CGFloat)font {
    UILabel * lable = [self hl_lableWithColor:color font:font bold:false numbers:1];
    return lable;
}


+ (instancetype)hl_singleLineWithColor:(NSString * )color font:(CGFloat)font bold:(BOOL)bold {
    UILabel * lable = [self hl_lableWithColor:color font:font bold:bold numbers:1];
    return lable;
}

+  (instancetype)hl_lableWithColor:(NSString * )color font:(CGFloat)font bold:(BOOL)bold numbers:(int)num {
    UILabel * lable = [[UILabel alloc]init];
    lable.textColor = [HLTools hl_toColorByColorStr:color];
    lable.font = bold?[UIFont boldSystemFontOfSize:FitPTScreen(font)] :[UIFont systemFontOfSize:FitPTScreen(font)];
    lable.numberOfLines = num;
    return lable;
}

@end
