//
//  HLAlertAction.m
//  HuiLife
//
//  Created by 闻喜惠生活 on 2019/8/10.
//

#import "HLAlertAction.h"

@implementation HLAlertAction

-(instancetype)initWithTitle:(NSString *)title color:(UIColor*)color completion:(HLActionBlock)completion{
    if (self = [super init]) {
        _title = title;
        _tintColor = color;
        _completion = completion;
        _showLine = YES;
        _type = HLAlertActionNormal;
        _hight = FitPTScreen(50);
        _font = [UIFont systemFontOfSize:FitPTScreen(14)];
    }
    return self;
}

@end
