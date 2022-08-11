//
//  HLStoreBuyMainInfo.m
//  HuiLife
//
//  Created by 王策 on 2019/8/30.
//

#import "HLStoreBuyMainInfo.h"

@implementation HLStoreBuyMainInfo


/// 控制选中第一个年份 还有 支付方式
- (void)configDefaultSelectYearAndPayType{
    if (self.ruleData.count) {
        HLStoreBuyYearInfo *yearInfo = self.ruleData.firstObject;
        yearInfo.select = YES;
    }
    if (self.zhifuData.count) {
        HLStoreBuyTypeInfo *typeInfo = self.zhifuData.firstObject;
        typeInfo.select = YES;
    }
}

+(NSDictionary *)mj_objectClassInArray{
    return @{@"ruleData":@"HLStoreBuyYearInfo",
             @"zhifuData":@"HLStoreBuyTypeInfo"
             };
}

-(HLStoreBuyYearInfo *)selectYearInfo{
    __block HLStoreBuyYearInfo *selectInfo = nil;
    [self.ruleData enumerateObjectsUsingBlock:^(HLStoreBuyYearInfo * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if (obj.select) {
            selectInfo = obj;
            *stop = YES;
        }
    }];
    return selectInfo;
}

- (HLStoreBuyTypeInfo *)selectTypeInfo{
    __block HLStoreBuyTypeInfo *selectInfo = nil;
    [self.zhifuData enumerateObjectsUsingBlock:^(HLStoreBuyTypeInfo * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if (obj.select) {
            selectInfo = obj;
            *stop = YES;
        }
    }];
    return selectInfo;
}

@end

@implementation HLStoreBuyYearInfo

+(NSDictionary *)mj_replacedKeyFromPropertyName{
    return @{@"Id":@"id"};
}

@end

@implementation HLStoreBuyTypeInfo

@end
