//
//  HLOrderPartRefund.m
//  iOS13test
//
//  Created by 雷清华 on 2019/10/28.
//  Copyright © 2019 雷清华. All rights reserved.
//

#import "HLOrderPartRefund.h"

@implementation HLOrderPartRefund

+ (NSDictionary *)mj_objectClassInArray {
    return @{
        @"pro": @"HLOrderGoodModel"
    };
}

- (CGFloat)goodHight {
    return FitPTScreen(70);
}

- (CGFloat)priceDesHight {
    return FitPTScreen(80);
}

- (NSMutableArray *)contents {
    if (!_contents) {
        _contents = [NSMutableArray array];
        if (_returnId.length) {
            [_contents addObject:[NSString stringWithFormat:@"退款编号：%@",_returnId]];
        }
        if (_reason.length) {
            [_contents addObject:[NSString stringWithFormat:@"退款原因：%@",_reason]];
        }
        if (_succed_time.length) {
            [_contents addObject:[NSString stringWithFormat:@"退款时间：%@",_succed_time]];
        }
    }
    return _contents;
}

- (CGFloat)contentHight {
    if (!_contentHight) {
        _contentHight = ( self.contents.count + 1 ) * FitPTScreen(20);
        for (NSString * text in self.contents) {
            _contentHight += [HLTools estmateHightString:text Font:[UIFont systemFontOfSize:FitPTScreen(14)]];
        }
    }
    return _contentHight;
}

- (CGFloat)totleHight {
    return self.pro.count * self.goodHight + self.priceDesHight + self.contentHight;
}
@end
