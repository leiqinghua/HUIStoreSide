//
//  HLBaseOrderLayout.m
//  iOS13test
//
//  Created by 雷清华 on 2019/10/23.
//  Copyright © 2019 雷清华. All rights reserved.
//

#import "HLBaseOrderLayout.h"

@implementation HLBaseOrderLayout

- (instancetype)initWithOrderModel:(HLBaseOrderModel *)orderModel {
    if (self = [super init]) {
        _orderModel = orderModel;
        [self layoutSubViewFrames];
    }
    return self;
}

/// 设置子视图大小
- (void)layoutSubViewFrames {
    _orderInfoHight = FitPTScreen(50);
    [self calculateBottomContentHight];
}

- (CGFloat)userInfoHight {
    if (!self.orderModel.mobile.length) {
        return 0.0;
    }
    return FitPTScreen(56);
}

- (CGFloat)footerHight {
   return FitPTScreen(54);
}

- (CGFloat)goodsHight {
    return FitPTScreen(70);
}

- (CGFloat)functionHight {
    if (self.orderModel.functions.count) {
        return FitPTScreen(57);
    }
    return 0.0;
}


- (CGFloat)totalHight {
    return self.tableHight + FitPTScreen(10);
}

/// 计算底部描述的高度
- (void)calculateBottomContentHight {
    NSArray *contents = self.orderModel.bottomContents;
    self.bottomHight = ( contents.count + 1 ) * FitPTScreen(20);
    for (NSString *text in contents) {
        self.bottomHight += [HLTools estmateHightString:text Font:[UIFont systemFontOfSize:FitPTScreen(14)]];
    }
}

/// 价格描述高度计算
- (CGFloat)calculatePriceDescHight {
    NSArray *contents = self.orderModel.settlementDes;
    if (contents.count) {
        CGFloat hight = ( contents.count + 1 ) * FitPTScreen(20);
        for (NSDictionary *content in contents) {
            NSString *title = content[@"key"];
            hight += [HLTools estmateHightString:title Font:[UIFont systemFontOfSize:FitPTScreen(14)]];
        }
        return hight;
    }
    return 0;
}

- (NSInteger)sectionCount {
    return 4;
}

- (NSInteger)stmDesSection {
    return 2;
}

@end
