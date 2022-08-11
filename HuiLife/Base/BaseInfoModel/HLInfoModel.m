//
//  HLInfoModel.m
//  HuiLife
//
//  Created by 雷清华 on 2019/8/27.
//

#import "HLInfoModel.h"

@implementation HLInfoModel

-(instancetype)init{
    if (self = [super init]) {
        _cellHight = FitPTScreen(55);
        _canInput = YES;
    }
    return self;
}

-(BOOL)checkParamsIsOk{
    if (!_needCheckParams) {
        return YES;
    }
    
    if (!_text.length) {
        return false;
    }
    
    return YES;
}

@end
