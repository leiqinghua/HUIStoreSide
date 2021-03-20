//
//  HLSendOrderMoneyInputInfo.m
//  HuiLife
//
//  Created by 王策 on 2019/8/9.
//

#import "HLSendOrderMoneyInfo.h"


@implementation HLSendOrderMoneyInfo

+(NSDictionary *)mj_objectClassInArray{
    return @{@"list":@"HLSendOrderMoneyInputInfo"};
}

-(NSArray<HLRightInputTypeInfo *> *)section0Arr{
    if (!_section0Arr) {
        HLRightInputTypeInfo *startInput = [[HLRightInputTypeInfo alloc] init];
        startInput.leftTip = @"起送费";
        startInput.placeHoder = @"消费多少元起送";
        startInput.cellHeight = FitPTScreen(53);
        startInput.canInput = YES;
        startInput.text = self.startSendMoney > 0 ? [NSString hl_stringWithNoZeroMoney:(double)self.startSendMoney/100] : @"";
        startInput.saveKey = @"startMoney";
        startInput.errorHint = @"请输入起送费";
        startInput.keyBoardType = UIKeyboardTypeDecimalPad;
        startInput.needCheckParams = YES;
        
        HLRightInputTypeInfo *freeInput = [[HLRightInputTypeInfo alloc] init];
        freeInput.leftTip = @"满额免费配送";
        freeInput.placeHoder = @"¥消费多少元以上，免配送费";
        freeInput.needCheckParams = NO;
        freeInput.text = self.freeMoney > 0 ? [NSString hl_stringWithNoZeroMoney:(double)self.freeMoney/100] : @"";
        freeInput.cellHeight = FitPTScreen(53);
        freeInput.canInput = YES;
        freeInput.saveKey = @"freeMoney";
        freeInput.keyBoardType = UIKeyboardTypeDecimalPad;
        freeInput.errorHint = @"";
        _section0Arr = @[startInput,freeInput];
    }
    return _section0Arr;
}

-(NSMutableArray<HLSendOrderMoneyInputInfo *> *)section1Arr{
    if (!_section1Arr) {
        _section1Arr = [NSMutableArray array];
        // 判断获取的数据，list 是否有值
        if (self.list.count == 0) {
            for (NSInteger i = 0; i < 2; i++) {
                HLSendOrderMoneyInputInfo *info = [[HLSendOrderMoneyInputInfo alloc] init];
                [_section1Arr addObject:info];
            }
        }else{
            [self.list enumerateObjectsUsingBlock:^(HLSendOrderMoneyInputInfo * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                obj.sendMoneyText = [NSString hl_stringWithNoZeroMoney:(double)obj.sendMony/100];
                obj.startMoneyText = [NSString hl_stringWithNoZeroMoney:(double)obj.startMoney/100];
                obj.endMoneyText = [NSString hl_stringWithNoZeroMoney:(double)obj.endMoney/100];
                [_section1Arr addObject:obj];
            }];
        }
    }
    return _section1Arr;
}

@end


@implementation HLSendOrderMoneyInputInfo

@end
