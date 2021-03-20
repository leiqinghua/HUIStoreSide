//
//  HLVoucherQueryInfo.m
//  HuiLife
//
//  Created by 王策 on 2019/9/4.
//

#import "HLVoucherQueryInfo.h"

@implementation HLVoucherQueryInfo

+(NSDictionary *)mj_objectClassInArray{
    return @{@"bank_list":@"HLVoucherQueryBankInfo",
             @"city_list":@"HLVoucherQueryProvinceInfo"
             };
}

-(NSArray *)provinceTitleArr{
    if (!_provinceTitleArr) {
        
        NSMutableArray *mArr = [NSMutableArray array];
        for (HLVoucherQueryProvinceInfo *provinceInfo in self.city_list) {
            [mArr addObject:provinceInfo.area_name];
        }

        _provinceTitleArr = [mArr copy];
    }
    return _provinceTitleArr;
}

-(NSArray *)bankTitleArr{
    if (!_bankTitleArr) {
        
        NSMutableArray *mArr = [NSMutableArray array];
        for (HLVoucherQueryBankInfo *bankInfo in self.bank_list) {
            [mArr addObject:bankInfo.bank_name];
        }
        
        _bankTitleArr = [mArr copy];
    }
    return _bankTitleArr;
}

/// 选择省之后，重置市数组和区数组
- (void)resetCityArrAndClearAreaArrWithIndex:(NSInteger)index{
    
    // 更新市的数据
    self.cityArr = [self.city_list[index] area_children];
    self.cityTitleArr = @[];
    
    // 更新区的数据
    self.areaArr = @[];
    self.areaTitleArr = @[];
}

/// 选择市之后，重置区数组
- (void)resetAreaArrWithIndex:(NSInteger)index{
    self.areaArr = [self.cityArr[index] area_children];
    self.areaTitleArr = @[];
    self.hasAreaData = self.areaArr.count > 0;
}

-(NSArray *)cityTitleArr{
    if (!_cityTitleArr.count) {
        
        NSMutableArray *mArr = [NSMutableArray array];
        for (HLVoucherQueryCityInfo *cityInfo in self.cityArr) {
            [mArr addObject:cityInfo.area_name];
        }
        
        _cityTitleArr = [mArr copy];
    }
    return _cityTitleArr;
}

-(NSArray *)areaTitleArr{
    if (!_areaTitleArr.count) {
        
        NSMutableArray *mArr = [NSMutableArray array];
        for (HLVoucherQueryAreaInfo *areaInfo in self.areaArr) {
            [mArr addObject:areaInfo.area_name];
        }
        
        _areaTitleArr = [mArr copy];
    }
    return _areaTitleArr;
}

@end

@implementation HLVoucherQueryBankInfo

@end

@implementation HLVoucherQueryProvinceInfo

+(NSDictionary *)mj_objectClassInArray{
    return @{@"area_children":@"HLVoucherQueryCityInfo"};
}


@end

@implementation HLVoucherQueryCityInfo

+(NSDictionary *)mj_objectClassInArray{
    return @{@"area_children":@"HLVoucherQueryAreaInfo"};
}

@end

@implementation HLVoucherQueryAreaInfo



@end
