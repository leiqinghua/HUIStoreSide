//
//  HLReviewModel.m
//  HuiLife
//
//  Created by 雷清华 on 2020/12/22.
//

#import "HLReviewModel.h"

@implementation HLReviewModel

+ (NSDictionary *)objectClassInArray{
    return @{
             @"explains":@"HLStatuInfo",
             @"censors" :@"HLStatuInfo"
             };
    
}

- (NSString *)optionTitle {
    if (!_optionTitle) {
        switch (_state) {
            case 0:
                _optionTitle = @"提交审核";
                break;
            case 5:
                _optionTitle = @"重新提交";
                break;
            case 8:
                _optionTitle = @"异常处理";
                break;
            case 10:
                _optionTitle = @"请耐心等待";
                break;
            default:
                _optionTitle = @"推广中";
                break;
        }
    }
    return _optionTitle;
}

- (NSAttributedString *)tipAttr {
    if (!_tipAttr) {
        NSString *tip = [NSString stringWithFormat:@"商家状态：%@",_tips];
        UIColor *tipColor = UIColorFromRGB(0xFF9900);
        if (self.state == 15) {
            tipColor = UIColorFromRGB(0x23A820);
        } else if (self.state == 5 || self.state == 8) {
            tipColor = UIColorFromRGB(0xFF0000);
        }
        NSRange statuRange = [tip rangeOfString:@"商家状态："];
        NSMutableAttributedString *mutarr = [[NSMutableAttributedString alloc]initWithString:tip attributes:@{NSForegroundColorAttributeName:UIColorFromRGB(0x333333)}];
        [mutarr addAttributes:@{NSForegroundColorAttributeName :tipColor} range:NSMakeRange(statuRange.length, tip.length-statuRange.length)];
        _tipAttr = [mutarr copy];
    }
    return _tipAttr;
}
@end

@implementation HLStatuInfo



@end

@implementation HLStatuFailInfo



@end
