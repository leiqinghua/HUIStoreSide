//
//  HLRefundModel.m
//  HuiLife
//
//  Created by 闻喜惠生活 on 2019/1/24.
//

#import "HLRefundModel.h"

@implementation HLRefundModel

+(NSDictionary *)mj_replacedKeyFromPropertyName{
    return @{
             @"Id":@"id",
             };
}

+(NSDictionary *)objectClassInArray{
    return @{
             @"pro_info":@"HLRefundGoodModel",
             };
    
}

-(NSString *)deskNumText{
    if ([_zhuohao hl_isAvailable]) {
        return [NSString stringWithFormat:@"桌号：%@",_zhuohao];
    }
    return _zhuohao;
}

-(BOOL)is_zd{
    NSInteger totleCount = 0;
    NSInteger selectCount = 0;
    for (HLRefundGoodModel *model in self.pro_info) {
        totleCount += model.pro_num.intValue;
        selectCount += model.selectNum;
    }
    HLLog(@"totleCount = %ld,selectCount = %ld",totleCount,selectCount);
    return totleCount == selectCount;
}

-(NSInteger)totleCount{
    NSInteger totleCount = 0;
    for (HLRefundGoodModel *model in self.pro_info) {
        totleCount += model.pro_num.intValue;
    }
    return totleCount;
}

-(NSString *)IdText{
    return [NSString stringWithFormat:@"订单号：%@",_Id];
}

-(NSAttributedString *)idAttr{
    NSString *text = [NSString stringWithFormat:@"订单单号：%@",_Id];
    NSMutableAttributedString * attr = [[NSMutableAttributedString alloc]initWithString:text];
    NSRange range = [text rangeOfString:@"："];
    NSDictionary * attribute1 = @{NSForegroundColorAttributeName:UIColorFromRGB(0x989898)};
    NSDictionary * attribute2 = @{NSForegroundColorAttributeName:UIColorFromRGB(0x282828)};
    NSDictionary * attribute3 =@{NSFontAttributeName:[UIFont systemFontOfSize:FitPTScreenH(14)]};
    
    [attr addAttributes:attribute1 range:NSMakeRange(0, range.location+1)];
    [attr addAttributes:attribute2 range:NSMakeRange(range.location+1, text.length-range.location -1)];
    [attr addAttributes:attribute3 range:NSMakeRange(0, text.length)];
    return attr;
}

-(NSAttributedString *)tipAttr{
    NSString *text = @"温馨提示：提交前请与客户沟通达成一致";
    NSMutableAttributedString * attr = [[NSMutableAttributedString alloc]initWithString:text];
    NSRange range = [text rangeOfString:@"："];
    NSDictionary * attribute1 = @{NSForegroundColorAttributeName:UIColorFromRGB(0xFF8D26)};
    NSDictionary * attribute2 = @{NSForegroundColorAttributeName:UIColorFromRGB(0x989898)};
    NSDictionary * attribute3 =@{NSFontAttributeName:[UIFont systemFontOfSize:FitPTScreenH(13)]};
    
    [attr addAttributes:attribute1 range:NSMakeRange(0, range.location+1)];
    [attr addAttributes:attribute2 range:NSMakeRange(range.location+1, text.length-range.location -1)];
    [attr addAttributes:attribute3 range:NSMakeRange(0, text.length)];
    return attr;
}

@end
