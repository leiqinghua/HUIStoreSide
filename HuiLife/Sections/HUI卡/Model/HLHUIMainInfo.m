//
//  HLHUIMainInfo.m
//  HuiLife
//
//  Created by 雷清华 on 2020/9/23.
//

#import "HLHUIMainInfo.h"

@implementation HLHUIMainInfo

- (NSAttributedString *)timeAttr {
    if (!_timeAttr) {
        NSString *timeStr = [NSString stringWithFormat:@"期限%ld年",_termYear];
        NSMutableAttributedString *attr = [[NSMutableAttributedString alloc]initWithString:timeStr];
        NSRange timeRange = [timeStr rangeOfString:[NSString stringWithFormat:@"%ld",_termYear]];
        [attr addAttributes:@{NSFontAttributeName:[UIFont boldSystemFontOfSize:FitPTScreen(20)],NSForegroundColorAttributeName:UIColorFromRGB(0x343434)} range:timeRange];
        _timeAttr = [attr copy];
    }
    return _timeAttr;
}

@end
