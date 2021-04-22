//
//  HLVideoMarketModel.m
//  HuiLife
//
//  Created by 王策 on 2021/4/21.
//

#import "HLVideoMarketModel.h"

@implementation HLVideoMarketModel

- (NSString *)stateStr{
    if (!_stateStr) {
        _stateStr = @"";
        switch (self.state) {
            case 0:
                _stateStr = @"已下架";
                break;
            case 1:
                _stateStr = @"推广中";
                break;
            case 15:
                _stateStr = @"驳回";
                break;
            default:
                break;
        }
    }
    return _stateStr;
}

@end
