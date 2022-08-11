//
//  HLBaseOrderModel.m
//  iOS13test
//
//  Created by 雷清华 on 2019/10/22.
//  Copyright © 2019 雷清华. All rights reserved.
//

#import "HLBaseOrderModel.h"

@implementation HLBaseOrderModel

//添加￥符号
-(NSString *)addMoneySymbolWithMoney:(NSString *)money{
    
    money = [money stringByReplacingOccurrencesOfString:@"+" withString:@""];
    
    BOOL jian = [money containsString:@"-"];
    
    if ([money containsString:@"￥"] || [money containsString:@"¥"]) {
        return money;
    }
    
    if (jian) {
      money = [money stringByReplacingOccurrencesOfString:@"-" withString:@""];
    }
    return [NSString stringWithFormat:@"%@￥%.2lf",jian?@"-":@"",money.doubleValue];
}

- (NSMutableArray *)bottomContents {
    NSMutableArray *contents = [NSMutableArray array];
    if (self.storeName.length) {
        [contents addObject:[NSString stringWithFormat:@"下单门店：%@",self.storeName]];
    }
    if (self.input_time.length) {
        [contents addObject:[NSString stringWithFormat:@"下单时间：%@",self.input_time]];
    }
    return contents;
}

- (BOOL)emptyWithMoney:(NSString *)money {
    if ([money containsString:@"¥"] || [money containsString:@"￥"]) {
        NSRange range = [money rangeOfString:@"¥"];
        if ([money containsString:@"￥"]) {
             range = [money rangeOfString:@"￥"];
        }
        NSString *moneyStr = [money substringFromIndex:(range.location + 1)];
        return moneyStr.doubleValue == 0;
    }
    return money.doubleValue == 0;
}

@end


