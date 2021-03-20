//
//  HLBuyGoodListModel.m
//  HuiLife
//
//  Created by 王策 on 2019/8/6.
//

#import "HLBuyGoodListModel.h"

@implementation HLBuyGoodListModel

-(NSAttributedString *)priceAttr{
    if (!_priceAttr) {
        NSString *allStr = _price;
        NSMutableAttributedString *moneyAttr = [[NSMutableAttributedString alloc] initWithString:allStr attributes:@{NSForegroundColorAttributeName : UIColorFromRGB(0xFF4040),NSFontAttributeName:[UIFont boldSystemFontOfSize:FitPTScreen(20)]}];
        [moneyAttr addAttribute:NSFontAttributeName value:[UIFont boldSystemFontOfSize:FitPTScreen(15)] range:[allStr rangeOfString:@"¥"]];
        _priceAttr = moneyAttr;
    }
    return _priceAttr;
}

@end
