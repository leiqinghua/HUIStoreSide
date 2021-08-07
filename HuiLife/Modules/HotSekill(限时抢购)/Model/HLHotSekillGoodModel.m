//
//  HLHotSekillGoodModel.m
//  HuiLife
//
//  Created by 王策 on 2019/8/6.
//

#import "HLHotSekillGoodModel.h"

@implementation HLHotSekillGoodModel

+(NSDictionary *)mj_replacedKeyFromPropertyName{
    return @{@"Id":@"id"};
}

-(NSAttributedString *)priceAttr{
    if (!_priceAttr) {
        NSString *allStr = [NSString stringWithFormat:@"¥%@",[NSString hl_stringWithNoZeroMoney:_price]];
        NSMutableAttributedString *moneyAttr = [[NSMutableAttributedString alloc] initWithString:allStr attributes:@{NSForegroundColorAttributeName : UIColorFromRGB(0xFF4040),NSFontAttributeName:[UIFont boldSystemFontOfSize:FitPTScreen(20)]}];
        [moneyAttr addAttribute:NSFontAttributeName value:[UIFont boldSystemFontOfSize:FitPTScreen(15)] range:[allStr rangeOfString:@"¥"]];
        _priceAttr = moneyAttr;
    }
    return _priceAttr;
}

- (NSAttributedString *)noNormalTypePriceAttr{
    if (!_noNormalTypePriceAttr) {
        NSString *allStr = [NSString stringWithFormat:@"¥%@",[NSString hl_stringWithNoZeroMoney:_orgPrice]];
        NSMutableAttributedString *moneyAttr = [[NSMutableAttributedString alloc] initWithString:allStr attributes:@{NSForegroundColorAttributeName : UIColorFromRGB(0xFF4040),NSFontAttributeName:[UIFont boldSystemFontOfSize:FitPTScreen(20)]}];
        [moneyAttr addAttribute:NSFontAttributeName value:[UIFont boldSystemFontOfSize:FitPTScreen(15)] range:[allStr rangeOfString:@"¥"]];
        _noNormalTypePriceAttr = moneyAttr;
    }
    return _noNormalTypePriceAttr;
}


@end
