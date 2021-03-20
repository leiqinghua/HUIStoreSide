//
//  HLCardListModel.m
//  HuiLife
//
//  Created by 雷清华 on 2019/8/17.
//

#import "HLCardListModel.h"

@implementation HLCardListModel

-(NSAttributedString *)numAttr{
    if (!_numAttr) {
        NSString * text = [NSString stringWithFormat:@"%ld%@",_cardTimes,_timesDesc];
        NSRange range = [text rangeOfString:_timesDesc];
        NSMutableAttributedString * attr = [[NSMutableAttributedString alloc]initWithString:text attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:FitPTScreen(32)]}];
        [attr addAttributes:@{NSFontAttributeName :[UIFont systemFontOfSize:FitPTScreen(22)]} range:range];
        _numAttr = [attr copy];
    }
    return _numAttr;
}

-(UIColor *)promoteColor{
    switch (_marketType) {
        case 0:
            return UIColorFromRGB(0x90D15C);
            break;
        case 1:
            return UIColorFromRGB(0xFF903F);
            break;
        case 2:
            return UIColorFromRGB(0xFF5A3F);
            break;
        default:
            return nil;
            break;
    }
}

@end

@implementation HLCardPromote



@end


@implementation HLCardSelectModel



@end
