//
//  HLFinanceModel.m
//  HuiLife
//
//  Created by 闻喜惠生活 on 2018/12/27.
//

#import "HLFinanceModel.h"

@implementation HLFinanceModel

-(NSString *)compomentStr{
    NSMutableString * str = [NSMutableString string];
    if ([self.shouru hl_isAvailable]) {
        [str appendFormat:@"收入￥%@",self.shouru];
    }
    if (self.zhichu.length) {
       [str appendFormat:@" 支出￥%@",self.zhichu];
    }
    return str;
}

-(BOOL)isEntried{
    if ([self.name isEqualToString:@"已结算"]) {
        return YES;
    }
    return NO;
}

-(NSString *)money{
    return [NSString stringWithFormat:@"+%@",self.keti];
}
@end

@implementation HLEntriedModel

+(NSDictionary *)mj_replacedKeyFromPropertyName{
    return @{
             // 模型属性: JSON key, MJExtension 会自动将 JSON 的 key 替换为你模型中需要的属性
             @"Id":@"id",
             };
}

-(NSString *)moneyText{
    return [NSString stringWithFormat:@"￥%@",_money];
}

-(BOOL)isSuccess{
    return [_status isEqualToString:@"提现成功"];
}
@end
