//
//  HLStoreDetailModel.m
//  HuiLife
//
//  Created by 闻喜惠生活 on 2018/10/22.
//

#import "HLStoreDetailModel.h"

@implementation HLStoreDefaultModel

+(NSDictionary *)mj_replacedKeyFromPropertyName{
    return @{
             // 模型属性: JSON key, MJExtension 会自动将 JSON 的 key 替换为你模型中需要的属性
             @"storeid":@"id",
             };
}

-(NSString *)businessHours{
    NSArray * dates = @[@"周一至周日",@"周一",@"周二",@"周三",@"周四",@"周五",@"周六",@"周日"];
     NSMutableString * date = [NSMutableString string];
    for (NSString * index in self.shop_date) {
        if (![self.shop_date isEmptyArr]) {
            if ([index integerValue] == 8) {
                [date appendString:dates[0]];
            }else{
                [date appendString:dates[[index integerValue]]];
            }
        }
    }
    
    if (self.shop_hours.count == 2 && ![self.shop_hours isEmptyArr]) {
        [date appendFormat:@"\n%@-%@",self.shop_hours[0],self.shop_hours[1]];
    }
    
    return date;
}

-(NSString *)areaText{
    NSMutableString * area = [NSMutableString string];
    if (self.area.count > 0 && ![self.area isEmptyArr]) {
        [area appendString:self.area[0]];
        for (int i = 1; i<self.area.count; i++) {
            [area appendFormat:@"-%@",self.area[i]];
        }
    }
    return area;
}
@end


@implementation HLStoreDetailModel

-(instancetype)initWithText:(NSString *)text holder:(NSString *)placeHolder type:(HLStoreDetailType)type{
    if (self = [super init]) {
        self.text = text;
        self.placeHolder = placeHolder;
        self.type = type;
    }
    return self;
}


@end
