//
//  HLFeatureMainInfo.m
//  HuiLife
//
//  Created by 雷清华 on 2020/5/20.
//

#import "HLFeatureMainInfo.h"

@implementation HLFeatureMainInfo

- (NSMutableArray<HLFeatureInfo *> *)datasource {
    if (!_datasource) {
        _datasource = [NSMutableArray array];
        HLFeatureInfo *info1 = [[HLFeatureInfo alloc]init];
        info1.key = @"label_1";
        info1.value = _label_1;
        
        HLFeatureInfo *info2 = [[HLFeatureInfo alloc]init];
        info2.key = @"label_2";
        info2.value = _label_2;
        
        HLFeatureInfo *info3 = [[HLFeatureInfo alloc]init];
        info3.key = @"label_3";
        info3.value = _label_3;
        
        [_datasource addObject:info1];
        [_datasource addObject:info2];
        [_datasource addObject:info3];
    }
    return _datasource;
}

@end

@implementation HLFeatureInfo

@end

