//
//  HLSendOrderCodeInfo.m
//  HuiLife
//
//  Created by 王策 on 2019/8/9.
//

#import "HLSendOrderCodeInfo.h"

@implementation HLSendOrderCodeInfo

-(NSArray *)cardNoArr{
    if (!_cardNoArr) {
        NSMutableArray *mArr = [NSMutableArray array];
        if (self.cardNo1.length) {
            [mArr addObject:self.cardNo1];
        }
        if (self.cardNo2.length) {
            [mArr addObject:self.cardNo2];
        }
        _cardNoArr = [mArr copy];
    }
    return _cardNoArr;
}

-(CGFloat)cellHeight{
    if (_cellHeight == 0) {
        _cellHeight = FitPTScreen(10) + FitPTScreen(50) * (2 + self.cardNoArr.count);
    }
    return _cellHeight;
}

@end
