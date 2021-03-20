//
//  HLBillModel.m
//  HuiLife
//
//  Created by 闻喜惠生活 on 2018/12/27.
//

#import "HLBillModel.h"

@implementation HLBillModel

+(NSDictionary *)mj_replacedKeyFromPropertyName{
    return @{
             // 模型属性: JSON key, MJExtension 会自动将 JSON 的 key 替换为你模型中需要的属性
             @"Id":@"id",
             };
}

- (NSAttributedString *)priceAttr{
    if (!_priceAttr) {
        NSMutableAttributedString * attr = [[NSMutableAttributedString alloc]initWithString:_price attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:FitPTScreen(16)]}];
        [attr addAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:FitPTScreen(14)]} range:NSMakeRange(0, 1)];
        NSRange dot = [_price rangeOfString:@"."];
        if (dot.location != NSNotFound) {
            [attr addAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:FitPTScreen(14)]} range:NSMakeRange(dot.location, _price.length - dot.location)];
        }
        _priceAttr = [attr copy];
    }
    return _priceAttr;
}
@end
