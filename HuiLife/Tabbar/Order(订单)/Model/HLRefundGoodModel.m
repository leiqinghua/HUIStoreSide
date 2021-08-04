//
//  HLRefundGoodModel.m
//  HuiLife
//
//  Created by 闻喜惠生活 on 2019/1/24.
//

#import "HLRefundGoodModel.h"

@implementation HLRefundGoodModel

+(NSDictionary *)mj_replacedKeyFromPropertyName{
    return @{
             @"Id":@"id",
             };
}

-(NSString *)priceText{
    return [NSString stringWithFormat:@"商品价格：%@",_price];
}

-(NSString *)numText{
    return [NSString stringWithFormat:@"商品总数：%@",_pro_num];
}
@end
