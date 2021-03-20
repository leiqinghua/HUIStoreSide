//
//  HLDiscountMainInfo.m
//  HuiLife
//
//  Created by 雷清华 on 2020/5/20.
//

#import "HLDiscountMainInfo.h"

@implementation HLDiscountMainInfo

+ (NSDictionary *)mj_objectClassInArray{
    return @{
             @"discount_set":@"HLDiscountInfo",
             };
}

@end

@implementation HLDiscountInfo

- (instancetype)init
{
    self = [super init];
    if (self) {
        _start_key = @"start_price";
        _end_key = @"end_price";
        _discount_key = @"discount";
    }
    return self;
}

- (NSMutableDictionary *)pargrams {
    if (!_pargrams) {
        _pargrams = [NSMutableDictionary dictionary];
        [_pargrams setObject:_start_price?:@"" forKey:_start_key];
        [_pargrams setObject:_end_price?:@"" forKey:_end_key];
        [_pargrams setObject:_discount?:@"" forKey:_discount_key];
    }
    return _pargrams;
}

- (BOOL)check {
    if (_discount.length) {
        if (!_start_price.length) {
            _toasStr = @"请输入最低订单价格";
            return NO;
        }
        
        if (!_end_price.length) {
            _toasStr = @"请输入最高订单价格";
            return NO;
        }
        
        if (_discount.floatValue < 0.1) {
            _toasStr = @"最高折扣为0.1折";
            return NO;
        }
        
        if (_discount.floatValue > 10) {
            _toasStr = @"最低折扣为10折";
            return NO;
        }
    }
    
    if (_start_price.length || _end_price.length) {
        if (_end_price.floatValue < _start_price.floatValue) {
           _toasStr = @"最高价格不能低于最低价格";
            return NO;
        }
        
        if (!_discount.length) {
            _toasStr = @"请设置折扣";
            return NO;
        }
    }
    
    return YES;
}

- (BOOL)canSave {
    if (!_start_price.length && !_end_price.length && !_discount.length) {
        return NO;
    }
    return YES;
}
@end
