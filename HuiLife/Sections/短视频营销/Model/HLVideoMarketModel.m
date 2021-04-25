//
//  HLVideoMarketModel.m
//  HuiLife
//
//  Created by 王策 on 2021/4/21.
//

#import "HLVideoMarketModel.h"

@implementation HLVideoMarketModel

- (void)setState:(NSInteger)state{
    _state = state;
    self.stateStr = nil;
}

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
            case 10:
                _stateStr = @"审核中";
                break;
            default:
                break;
        }
    }
    return _stateStr;
}

@end
