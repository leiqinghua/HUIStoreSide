//
//  HLGroupModel.m
//  HuiLife
//
//  Created by 闻喜惠生活 on 2019/8/14.
//

#import "HLGroupModel.h"

@implementation HLGroupModel

+(NSDictionary *)mj_replacedKeyFromPropertyName{
    return @{@"Id":@"id"};
}

-(NSAttributedString *)priceAttr{
    if (!_priceAttr) {
        NSString *allStr = [NSString stringWithFormat:@"¥%@",[NSString hl_stringWithNoZeroMoney:_groupPrice]];
        NSMutableAttributedString *moneyAttr = [[NSMutableAttributedString alloc] initWithString:allStr attributes:@{NSForegroundColorAttributeName : UIColorFromRGB(0xFF4040),NSFontAttributeName:[UIFont boldSystemFontOfSize:FitPTScreen(20)]}];
        [moneyAttr addAttribute:NSFontAttributeName value:[UIFont boldSystemFontOfSize:FitPTScreen(15)] range:[allStr rangeOfString:@"¥"]];
        _priceAttr = moneyAttr;
    }
    return _priceAttr;
}

@end


@implementation HLGroupSelectModel


-(NSAttributedString *)priceAttr{
    NSString *allStr = [NSString stringWithFormat:@"¥%@",[NSString hl_stringWithNoZeroMoney:_price]];
    NSMutableAttributedString *moneyAttr = [[NSMutableAttributedString alloc] initWithString:allStr attributes:@{NSForegroundColorAttributeName : UIColorFromRGB(0xFF4040),NSFontAttributeName:[UIFont boldSystemFontOfSize:FitPTScreen(20)]}];
    [moneyAttr addAttribute:NSFontAttributeName value:[UIFont boldSystemFontOfSize:FitPTScreen(15)] range:[allStr rangeOfString:@"¥"]];
    return moneyAttr;
}

-(NSString *)orderNumText{
    return [NSString stringWithFormat:@"订单数：%ld",_orderCnt];
}

-(NSString *)useNumText{
     return [NSString stringWithFormat:@"使用数：%ld",_usedCnt];
}

@end
