//
//  HLDeliveryWayInfo.m
//  HuiLife
//
//  Created by 雷清华 on 2020/9/28.
//

#import "HLDeliveryWayInfo.h"

@implementation HLDeliveryWayInfo

+ (NSDictionary *)mj_objectClassInArray {
    return @{@"eleRoles":@"HLDeliveryRule"};
}

- (CGFloat)cellHight {
    if (!_open) {
        return FitPTScreen(115);
    }
    CGFloat hight = FitPTScreen(115);
    for (int i = 0; i<self.eleRoles.count -1; i ++) {
        NSArray *rules = self.eleRoles[i];
        hight += FitPTScreen(35)*rules.count;
    }
    NSArray *lastArr = self.eleRoles.lastObject;
    hight += FitPTScreen(50)*lastArr.count;
    return hight;
}

- (NSArray<NSArray<HLDeliveryRule *> *> *)eleRoles {
    if (!_config) {
        _config = YES;
        NSArray *lastArr = self.eleRoles.lastObject;
        for (HLDeliveryRule *rule in lastArr) {
            if ([rule.col01 containsString:@"（"]) {
                NSMutableString *muRule = [NSMutableString stringWithString:rule.col01];
                NSRange range = [rule.col01 rangeOfString:@"（"];
                [muRule insertString:@"\n" atIndex:range.location];
                rule.col01 = [muRule copy];
            }
        }
    }
    return _eleRoles;
}
@end

@implementation HLDeliveryRule



@end
