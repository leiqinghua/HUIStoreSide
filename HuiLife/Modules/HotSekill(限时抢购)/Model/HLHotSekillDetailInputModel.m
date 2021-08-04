//
//  HLHotSekillDetailInputModel.m
//  HuiLife
//
//  Created by 王策 on 2019/8/7.
//

#import "HLHotSekillDetailInputModel.h"

@implementation HLHotSekillDetailInputModel

- (NSDictionary *)buildParams{
    if (self.contentName.length == 0 || self.num.length == 0 || self.orinalPrice.length == 0) {
        return nil;
    }
    return @{
             @"name":self.contentName,
             @"num":self.num,
             @"unit":self.selectUnit.name,
             @"price":self.orinalPrice,
             @"remarks":self.remark?:@""
             };
}

@end

@implementation HLHotSekillDetailUnitModel


@end
