//
//  HLSekillPromoteListModel.m
//  HuiLife
//
//  Created by 王策 on 2019/8/14.
//

#import "HLSekillPromoteListModel.h"

@implementation HLSekillPromoteListModel

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


@end
