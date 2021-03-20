//
//  HLBaseInputModel.m
//  HuiLife
//
//  Created by 闻喜惠生活 on 2019/8/3.
//

#import "HLBaseInputModel.h"

@implementation HLBaseInputModel

-(instancetype)init{
    if (self = [super init]) {
        _canEdit = YES;//默认可以编辑
        _cellHight = FitPTScreen(48);
    }
    return self;
}

-(BOOL)checkResult{
    if (!_needCheck) {
        return YES;
    }
    
    if (!_value.length) {
        return false;
    }
    return YES;
}

@end
