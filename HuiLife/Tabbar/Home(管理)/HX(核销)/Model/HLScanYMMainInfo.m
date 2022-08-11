//
//  HLScanYMMainInfo.m
//  HuiLife
//
//  Created by 雷清华 on 2020/6/19.
//

#import "HLScanYMMainInfo.h"

@implementation HLScanYMMainInfo

+ (NSDictionary *)mj_objectClassInArray {
    return @{@"pro_info":@"HLScanYMGoodInfo"};
}

- (CGFloat)orderInfoHight {
    if (!_orderInfoHight) {
        _orderInfoHight = FitPTScreen(71) * _pro_info.count + FitPTScreen(50);
    }
    return _orderInfoHight;
}
@end


@implementation HLScanYMGoodInfo



@end
