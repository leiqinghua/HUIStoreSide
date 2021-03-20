//
//  HLPrinterSetModel.m
//  HuiLife
//
//  Created by 闻喜惠生活 on 2018/11/22.
//

#import "HLPrinterSetModel.h"

@implementation HLPrinterSetModel

-(instancetype)init{
    if (self = [super init]) {
        _isSwitch = NO;
        _isON = YES;
        //无限输入
        _max_inputNum = 10000;
    }
    return self;
}

@end
