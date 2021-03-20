//
//  HLFeeMainInfo.m
//  HuiLife
//
//  Created by 雷清华 on 2020/5/18.
//

#import "HLFeeMainInfo.h"

@implementation HLFeeMainInfo

- (NSMutableArray *)datasource {
    if (!_datasource) {
        _datasource = [NSMutableArray array];
        
        NSMutableArray *section1 = [NSMutableArray array];
        if (_distance_fee_1) [section1 addObject:_distance_fee_1];
        if (_distance_fee_2) [section1 addObject:_distance_fee_2];
        if (_distance_fee_3)[section1 addObject:_distance_fee_3];
        
        HLFeeHeaderInfo *setInfo = [[HLFeeHeaderInfo alloc]init];
        setInfo.hideDesc = YES;
        setInfo.hideTipV = YES;
        setInfo.index = 0;
        setInfo.title = _dispatch_title;
        setInfo.on = _is_dispatch;
        setInfo.footerInfo = _distance_add_fee;
        setInfo.datasource = section1;
        setInfo.mainKey = @"is_dispatch";
        setInfo.value = @(setInfo.on);
        
        
        NSMutableArray *section2 = [NSMutableArray array];
        if (_distance_reward_fee_1) [section2 addObject:_distance_reward_fee_1];
        if (_distance_reward_fee_2) [section2 addObject:_distance_reward_fee_2];
        if (_distance_reward_fee_3)[section2 addObject:_distance_reward_fee_3];
        
        HLFeeHeaderInfo *orderInfo = [[HLFeeHeaderInfo alloc]init];
        orderInfo.hideSwitch = YES;
        orderInfo.index = 1;
        orderInfo.title = _distance_reward_title;
        orderInfo.subTitle = _distance_reward_label;
        orderInfo.datasource = section2;
        
        NSMutableArray *section3 = [NSMutableArray array];
        if (_consume_reward_fee_1) [section3 addObject:_consume_reward_fee_1];
        if (_consume_reward_fee_2) [section3 addObject:_consume_reward_fee_2];
        if (_consume_reward_fee_3) [section3 addObject:_consume_reward_fee_3];
        if (_consume_reward_fee_4) [section3 addObject:_consume_reward_fee_4];
        
        HLFeeHeaderInfo *timeInfo = [[HLFeeHeaderInfo alloc]init];
        timeInfo.hideSwitch = YES;
        timeInfo.hideDesc = YES;
        timeInfo.index = 2;
        timeInfo.title = _consume_reward_title;
        timeInfo.datasource = section3;
        
        
        NSMutableArray *section4 = [NSMutableArray array];
        if (_tp_distance_fee_1) [section4 addObject:_tp_distance_fee_1];
        if (_tp_distance_fee_2) [section4 addObject:_tp_distance_fee_2];
        if (_tp_distance_fee_3)[section4 addObject:_tp_distance_fee_3];
        
        HLFeeHeaderInfo *serveInfo = [[HLFeeHeaderInfo alloc]init];
        serveInfo.hideTipV = YES;
        serveInfo.hideDesc = YES;
        serveInfo.hideSection = YES;
        serveInfo.index = 3;
        serveInfo.canEdit = NO;
        serveInfo.title = _tp_dispatch_title;
        serveInfo.on = _is_third_party;
        serveInfo.footerInfo = _tp_distance_add_fee;
        
        serveInfo.mainKey = @"is_third_party";
        serveInfo.value = @(serveInfo.on);;
        
        [_datasource addObject:setInfo];
        [_datasource addObject:orderInfo];
        [_datasource addObject:timeInfo];
        [_datasource addObject:serveInfo];
        
        [self configPargrams];
    }
    return _datasource;
}


- (void)configPargrams {
    _distance_fee_1.distanceKey = @"distance_fee_1";
    _distance_fee_1.value = _distance_fee_1.distance_amount;
    NSDictionary *distance_fee_1_parm = @{
        @"distance_title_1":_distance_fee_1.title,
        @"distance_kilometre_1":@(_distance_fee_1.kilometre)
    };
    [_distance_fee_1.pargrams addEntriesFromDictionary:distance_fee_1_parm];
    
    
    _distance_fee_2.distanceKey = @"distance_fee_2";
    _distance_fee_2.value = _distance_fee_2.distance_amount;
    NSDictionary *distance_fee_2_parm = @{
        @"distance_title_2":_distance_fee_2.title,
        @"distance_kilometre_2":@(_distance_fee_2.kilometre)
    };
    [_distance_fee_2.pargrams addEntriesFromDictionary:distance_fee_2_parm];
    
    
    _distance_fee_3.distanceKey = @"distance_fee_3";
    _distance_fee_3.value = _distance_fee_3.distance_amount;
    NSDictionary *distance_fee_3_parm = @{
        @"distance_title_3":_distance_fee_3.title,
        @"distance_kilometre_3":@(_distance_fee_3.kilometre)
    };
    [_distance_fee_3.pargrams addEntriesFromDictionary:distance_fee_3_parm];
    
    
    _distance_add_fee.distanceKey = @"distance_add_fee";
    _distance_add_fee.value = _distance_add_fee.distance_amount;
    NSDictionary *distance_add_fee_parm = @{
        @"distance_add_title":_distance_add_fee.title,
        @"distance_add_kilometre":@(_distance_add_fee.kilometre)
    };
    [_distance_add_fee.pargrams addEntriesFromDictionary:distance_add_fee_parm];
    
    //    订单
    _distance_reward_fee_1.distanceKey = @"order_reward_1";
    _distance_reward_fee_1.orderKey = @"order_amount_1";
    
    NSDictionary *orderDict = @{
        _distance_reward_fee_1.distanceKey:_distance_reward_fee_1.distance_amount,
        _distance_reward_fee_1.orderKey :_distance_reward_fee_1.order_amount
    };
    [_distance_reward_fee_1.pargrams addEntriesFromDictionary:orderDict];
    
    _distance_reward_fee_2.distanceKey = @"order_reward_2";
    _distance_reward_fee_2.orderKey = @"order_amount_2";
    
    NSDictionary *order2Dict = @{
        _distance_reward_fee_2.distanceKey:_distance_reward_fee_2.distance_amount,
        _distance_reward_fee_2.orderKey :_distance_reward_fee_2.order_amount
    };
    [_distance_reward_fee_2.pargrams addEntriesFromDictionary:order2Dict];
    
    
    _distance_reward_fee_3.distanceKey = @"order_reward_3";
    _distance_reward_fee_3.orderKey = @"order_amount_3";
    NSDictionary *order3Dict = @{
        _distance_reward_fee_3.distanceKey:_distance_reward_fee_3.distance_amount?:@"",
        _distance_reward_fee_3.orderKey :_distance_reward_fee_3.order_amount
    };
    [_distance_reward_fee_3.pargrams addEntriesFromDictionary:order3Dict];
    
    // 时间
    _consume_reward_fee_1.distanceKey = @"consum_reward_1";
    _consume_reward_fee_1.startTimeKey = @"consume_start_time_1";
    _consume_reward_fee_1.endTimeKey = @"consume_end_time_1";
    NSDictionary *time1Dict = @{
        _consume_reward_fee_1.distanceKey:_consume_reward_fee_1.distance_amount,
        _consume_reward_fee_1.startTimeKey :_consume_reward_fee_1.start_time,
        _consume_reward_fee_1.endTimeKey :_consume_reward_fee_1.end_time,
    };
    [_consume_reward_fee_1.pargrams addEntriesFromDictionary:time1Dict];
    
    _consume_reward_fee_2.distanceKey = @"consum_reward_2";
    _consume_reward_fee_2.startTimeKey = @"consume_start_time_2";
    _consume_reward_fee_2.endTimeKey = @"consume_end_time_2";
    NSDictionary *time2Dict = @{
        _consume_reward_fee_2.distanceKey:_consume_reward_fee_2.distance_amount,
        _consume_reward_fee_2.startTimeKey :_consume_reward_fee_2.start_time,
        _consume_reward_fee_2.endTimeKey :_consume_reward_fee_2.end_time,
    };
    [_consume_reward_fee_2.pargrams addEntriesFromDictionary:time2Dict];
    
    _consume_reward_fee_3.distanceKey = @"consum_reward_3";
    _consume_reward_fee_3.startTimeKey = @"consume_start_time_3";
    _consume_reward_fee_3.endTimeKey = @"consume_end_time_3";
    NSDictionary *time3Dict = @{
        _consume_reward_fee_3.distanceKey:_consume_reward_fee_3.distance_amount,
        _consume_reward_fee_3.startTimeKey :_consume_reward_fee_3.start_time,
        _consume_reward_fee_3.endTimeKey :_consume_reward_fee_3.end_time,
    };
    [_consume_reward_fee_3.pargrams addEntriesFromDictionary:time3Dict];
    
    _consume_reward_fee_4.distanceKey = @"consum_reward_4";
    _consume_reward_fee_4.startTimeKey = @"consume_start_time_4";
    _consume_reward_fee_4.endTimeKey = @"consume_end_time_4";
    NSDictionary *time4Dict = @{
        _consume_reward_fee_4.distanceKey:_consume_reward_fee_4.distance_amount,
        _consume_reward_fee_4.startTimeKey :_consume_reward_fee_4.start_time,
        _consume_reward_fee_4.endTimeKey :_consume_reward_fee_4.end_time,
    };
    [_consume_reward_fee_4.pargrams addEntriesFromDictionary:time4Dict];
    
//    第三方配送
    _tp_distance_fee_1.distanceKey = @"tp_distance_fee_1";
    _tp_distance_fee_1.value = _tp_distance_fee_1.distance_amount;
    NSDictionary *tp_distance_fee_1_parm = @{
        @"tp_distance_title_1":_tp_distance_fee_1.title,
        @"tp_distance_kilometre_1":@(_tp_distance_fee_1.kilometre)
    };
    [_tp_distance_fee_1.pargrams addEntriesFromDictionary:tp_distance_fee_1_parm];
    
    
    _tp_distance_fee_2.distanceKey = @"tp_distance_fee_2";
    _tp_distance_fee_2.value = _tp_distance_fee_2.distance_amount;
    NSDictionary *tp_distance_fee_2_parm = @{
        @"tp_distance_title_2":_tp_distance_fee_2.title,
        @"tp_distance_kilometre_2":@(_tp_distance_fee_2.kilometre)
    };
    [_tp_distance_fee_2.pargrams addEntriesFromDictionary:tp_distance_fee_2_parm];
    
    
    _tp_distance_fee_3.distanceKey = @"tp_distance_fee_3";
    _tp_distance_fee_3.value = _tp_distance_fee_3.distance_amount;
    NSDictionary *tp_distance_fee_3_parm = @{
        @"tp_distance_title_3":_tp_distance_fee_3.title,
        @"tp_distance_kilometre_3":@(_tp_distance_fee_3.kilometre)
    };
    [_tp_distance_fee_3.pargrams addEntriesFromDictionary:tp_distance_fee_3_parm];
    
    
    _tp_distance_add_fee.distanceKey = @"tp_distance_add_fee";
    _tp_distance_add_fee.value = _tp_distance_add_fee.distance_amount;
    NSDictionary *tp_distance_add_parm = @{
        @"tp_distance_add_title":_tp_distance_add_fee.title,
        @"tp_distance_add_kilometre":@(_tp_distance_add_fee.kilometre)
    };
    [_tp_distance_add_fee.pargrams addEntriesFromDictionary:tp_distance_add_parm];
}

@end

@implementation HLFeeBaseInfo

- (NSMutableDictionary *)pargrams {
    if (!_pargrams) {
        _pargrams = [NSMutableDictionary dictionary];
    }
    return _pargrams;
}

- (instancetype)init {
    if (self = [super init]) {
        self.type = HLFeeBaseInfoTypeNormal;
    }
    return self;
}

- (BOOL)check {
    
    if (_limit_min_amount) {
        if (_distance_amount.floatValue < _limit_min_amount.floatValue) {
            _toastStr = [NSString stringWithFormat:@"派单费最少应为%@元",_limit_min_amount];
            return NO;
        }
    }

    return YES;
}

@end

@implementation HLFeeOrderInfo

- (instancetype)init {
    if (self = [super init]) {
        self.type = HLFeeBaseInfoTypeOrder;
    }
    return self;
}

- (BOOL)check {
    if (self.distance_amount.length) {
        if (!_order_amount.length) {
            self.toastStr = @"请输入订单金额";
            return NO;
        }
        if (self.distance_amount.floatValue > _order_amount.floatValue) {
            self.toastStr = @"排单费不能超过订单金额";
            return NO;
        }
    }
    return YES;
}

@end

@implementation HLFeeTimeInfo
- (instancetype)init {
    if (self = [super init]) {
        self.type = HLFeeBaseInfoTypeTime;
    }
    return self;
}

- (BOOL)check {
    if (self.distance_amount.floatValue > 0) {
        if (!_start_time.length && !_end_time.length) {
            self.toastStr = @"请设置消费高峰期时间区间";
            return NO;
        }
        
        if (!_start_time.length) {
            self.toastStr = @"请设置开始时间";
            return NO;
        }
        
        if (!_end_time.length) {
            self.toastStr = @"请设置结束时间";
            return NO;
        }
    }
    return YES;
}

@end

@implementation HLFeeHeaderInfo

- (instancetype)init
{
    self = [super init];
    if (self) {
        _canEdit = YES;
    }
    return self;
}
@end
