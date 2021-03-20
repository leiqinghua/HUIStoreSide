//
//  HLStoreModel.m
//  HuiLife
//
//  Created by 闻喜惠生活 on 2018/10/19.
//

#import "HLStoreModel.h"

@implementation HLStoreModel

+ (NSDictionary *)mj_replacedKeyFromPropertyName{
    return @{
             // 模型属性: JSON key, MJExtension 会自动将 JSON 的 key 替换为你模型中需要的属性
             @"storeID":@"id",
             };
}

-(NSString *)nameText{
    if (self.name.length > 10) {
        NSString * str = [self.name substringToIndex:10];
        return  [NSString stringWithFormat:@"%@...",str];
    }
    return self.name;
}

-(NSString *)classnameText{
    if (self.classname.length > 10) {
        NSString * str = [self.classname substringToIndex:10];
        return  [NSString stringWithFormat:@"%@...",str];
    }
    return self.classname;
}


- (CGFloat)classnameTextW{
    return [self.classnameText hl_widthForFont:[UIFont systemFontOfSize:FitPTScreen(10)]];
}
@end
