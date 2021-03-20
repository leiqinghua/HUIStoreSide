//
//  HLSetModel.m
//  HuiLife
//
//  Created by 闻喜惠生活 on 2019/8/3.
//

#import "HLSetModel.h"

@implementation HLSetModel

-(CGFloat)inputViewH{
    __block CGFloat hight = 0.0;
    [self.inputs enumerateObjectsUsingBlock:^(HLBaseInputModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        hight += obj.cellHight;
    }];
    return hight;
}

-(CGFloat)inputCellH{
    return self.inputViewH + FitPTScreen(12);
}

@end
