//
//  HLSendOrderRangeInfo.m
//  HuiLife
//
//  Created by 王策 on 2019/8/9.
//

#import "HLSendOrderRangeInfo.h"

@implementation HLSendOrderRangeInfo

+(NSDictionary *)mj_objectClassInArray{
    return @{@"items":@"HLSendOrderRangeSuggestionInfo"};
}

/// 判断是不是选择的自定义
- (BOOL)isCustumRange{
    return self.isCustom != 0;
}

- (HLSendOrderRangeSuggestionInfo *)selectRangeSuggestionInfo{
    __block HLSendOrderRangeSuggestionInfo *selectInfo = nil;
    [self.items enumerateObjectsUsingBlock:^(HLSendOrderRangeSuggestionInfo * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if (obj.select) {
            selectInfo = obj;
            *stop = YES;
        }
    }];
    return selectInfo;
}

@end

@implementation HLSendOrderRangeSuggestionInfo

@end
