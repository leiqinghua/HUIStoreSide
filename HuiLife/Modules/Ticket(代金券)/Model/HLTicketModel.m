//
//  HLTicketModel.m
//  HuiLife
//
//  Created by 闻喜惠生活 on 2019/8/5.
//

#import "HLTicketModel.h"

@implementation HLTicketModel

-(NSAttributedString *)priceAttr{
    if (!_priceAttr) {
        
        NSString * text = [NSString stringWithFormat:@"%@%@",@"¥",_couponPrice];
        
        CGFloat priceFont = FitPTScreen(26);
        CGFloat tipFont = FitPTScreen(20);
        NSMutableAttributedString * mutarr = [[NSMutableAttributedString alloc]initWithString:text attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:priceFont]}];
        NSRange range = [text rangeOfString:@"¥"];
        [mutarr addAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:tipFont]} range:range];
        _priceAttr = [mutarr copy];
        
    }
    return _priceAttr;
}

-(UIColor *)tgColor{
    switch (_marketType) {
        case 0:
            return UIColorFromRGB(0x90D15C);
            break;
        case 1:
            return UIColorFromRGB(0xFF903F);
            break;
        case 2:
            return UIColorFromRGB(0xFF5A3F);
            break;
        default:
            return UIColor.clearColor;
            break;
    }
    
}

-(CGFloat)cellHight{
    if (_giftDesc.length) {
        return FitPTScreen(108);
    }
    return FitPTScreen(102);
}

@end


@implementation HLTicketPromote

-(UIColor *)tgColor{
    switch (self.marketType) {
        case 0:
            return UIColorFromRGB(0xFFAE01);
            break;
        case 1:
            return UIColorFromRGB(0xFF9E3F);
            break;
        case 2:
            return UIColorFromRGB(0xFF7916);
            break;
        default:
            return UIColor.clearColor;
            break;
    }
}

@end


@implementation HLTicketPromoteAble


@end
