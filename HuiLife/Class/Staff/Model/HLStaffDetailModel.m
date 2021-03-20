//
//  HLStaffDetailModel.m
//  HuiLife
//
//  Created by 闻喜惠生活 on 2018/10/18.
//

#import "HLStaffDetailModel.h"

@implementation HLStaffDefaultModel

+(NSDictionary *)mj_replacedKeyFromPropertyName{
    
    return @{
             // 模型属性: JSON key, MJExtension 会自动将 JSON 的 key 替换为你模型中需要的属性
             @"modelID":@"id",
             };
}
@end


@implementation HLStaffDetailModel

-(instancetype)initWithText:(NSString *)text holder:(NSString *)placeHolder type:(HLStaffDetailModelType)type{
    if (self = [super init]) {
        self.text = text;
        self.placeHolder = placeHolder;
        self.type = type;
        //默认
        _fieldType = HLTextFieldDefaultType;
        //无限输入
        _input_num = 100000;
    }
    return self;
}

@end
