//
//  UIButton+HLExtension.m
//  HuiLife
//
//  Created by 雷清华 on 2019/12/13.
//

#import "UIButton+HLExtension.h"

@implementation UIButton (HLExtension)

+ (instancetype)hl_regularWithImage:(NSString *)image select:(BOOL)select {
    UIButton *button = [[UIButton alloc]init];
    [button setImage:[UIImage imageNamed:image] forState:select?UIControlStateSelected:UIControlStateNormal];
    return button;
}

+ (instancetype)hl_regularWithTitle:(NSString *)title titleColor:(NSString *)color font:(CGFloat)font image:(NSString *)image {
    UIButton * button = [[UIButton alloc]init];
    [button setTitle:title forState:UIControlStateNormal];
    [button setTitleColor:[HLTools hl_toColorByColorStr:color] forState:UIControlStateNormal];
    button.titleLabel.font = [UIFont systemFontOfSize:FitPTScreen(font)];
    if (image.length) {
        [button setImage:[UIImage imageNamed:image] forState:UIControlStateNormal];
    }
    return button;
}



+ (instancetype)hl_regularWithTitle:(NSString *)title titleColor:(NSString *)color font:(CGFloat)font backgroundImg:(NSString *)backImg {
    UIButton * button = [[UIButton alloc]init];
    [button setTitle:title forState:UIControlStateNormal];
    [button setTitleColor:[HLTools hl_toColorByColorStr:color] forState:UIControlStateNormal];
    button.titleLabel.font = [UIFont systemFontOfSize:FitPTScreen(font)];
    if (backImg.length) {
        [button setBackgroundImage:[UIImage imageNamed:backImg] forState:UIControlStateNormal];
    }
    return button;
}

- (CGSize)hl_estmateSizeWithTitle:(NSString *)title  Font:(UIFont*)font maxSize:(CGSize)size {
    CGSize _size;
    NSDictionary *attribute = @{NSFontAttributeName : font};
    NSStringDrawingOptions options = NSStringDrawingTruncatesLastVisibleLine | NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading;
    _size = [title boundingRectWithSize:size options:options attributes:attribute context:nil].size;
    return _size;
}

@end
