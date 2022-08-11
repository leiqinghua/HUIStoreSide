//
//  HLSendOrderMainInfo.m
//  HuiLife
//
//  Created by 王策 on 2019/8/8.
//

#import "HLSendOrderMainInfo.h"

@implementation HLSendOrderMainInfo

+(NSDictionary *)mj_objectClassInArray{
    return @{@"second":@"HLSendOrderSecondInfo"};
}

@end

@implementation HLSendOrderSecondInfo

+(NSDictionary *)mj_objectClassInArray{
    return @{@"items":@"HLSendOrderSecondFuncInfo"};
}

-(NSArray *)itemWidthArr{
    if (!_itemWidthArr) {
        NSMutableArray *mArr = [NSMutableArray array];
        [self.items enumerateObjectsUsingBlock:^(HLSendOrderSecondFuncInfo * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            // 计算宽度
            CGSize stringSize = [HLTools stringSizeWithString:obj.title fontSize:FitPTScreen(11) height:FitPTScreen(15)];
            [mArr addObject:@(stringSize.width + FitPTScreen(32))];
        }];
        _itemWidthArr = mArr;
    }
    return _itemWidthArr;
}

/// 获取需要保存的数据
- (NSDictionary *)buildParams{
    return @{self.savekey?:@"" :self.isOpen ? @"1" : @"0"};
}

- (CGFloat)cellHight {
    if (!_cellHight) {
//        NSInteger rows = (_items.count -1) / 3 + 1;
//        _cellHight = FitPTScreen(76) + rows*FitPTScreen(40) + FitPTScreen(25);
        CGFloat rowWidth = FitPTScreen(25);
        NSInteger row = 0;
        for (NSNumber *width in self.itemWidthArr) {
            if (rowWidth + width.floatValue + FitPTScreen(15) > ScreenW - FitPTScreen(10)) {
                rowWidth = FitPTScreen(25);
                row += 1;
            }
            rowWidth += (width.floatValue +FitPTScreen(15));
        }
        _cellHight = FitPTScreen(76) + (row + 1)*FitPTScreen(40) + FitPTScreen(25);
    }
    return _cellHight;
}

@end

@implementation HLSendOrderSecondFuncInfo


@end
