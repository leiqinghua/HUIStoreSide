//
//  HLHotBuyListModel.m
//  HuiLife
//
//  Created by 王策 on 2019/10/23.
//

#import "HLHotBuyListModel.h"

@implementation HLHotBuyListModel

-(NSAttributedString *)priceAttr{
    if (!_priceAttr) {
        NSString *allStr = [NSString stringWithFormat:@"¥%.2lf",_prounitprice];
        NSMutableAttributedString *moneyAttr = [[NSMutableAttributedString alloc] initWithString:allStr attributes:@{NSForegroundColorAttributeName : UIColorFromRGB(0xFF4040),NSFontAttributeName:[UIFont boldSystemFontOfSize:FitPTScreen(20)]}];
        [moneyAttr addAttribute:NSFontAttributeName value:[UIFont boldSystemFontOfSize:FitPTScreen(15)] range:[allStr rangeOfString:@"¥"]];
        _priceAttr = moneyAttr;
    }
    return _priceAttr;
}

@end
