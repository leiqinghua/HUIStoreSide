//
//  HLStaffModel.m
//  HuiLife
//
//  Created by 闻喜惠生活 on 2018/10/18.
//

#import "HLStaffModel.h"

@implementation HLStaffModel

+(NSDictionary *)mj_replacedKeyFromPropertyName{
    return @{
             // 模型属性: JSON key, MJExtension 会自动将 JSON 的 key 替换为你模型中需要的属性
             @"staffID":@"id",
             };
}

-(NSString *)nameText{
    if (self.name.length > 7) {
        NSString * str = [self.name substringToIndex:7];
        return  [NSString stringWithFormat:@"%@...",str];
    }
    return self.name;
}
@end
