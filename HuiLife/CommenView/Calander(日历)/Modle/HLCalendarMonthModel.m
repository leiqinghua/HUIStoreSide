//
//  HLCalendarMonthModel.m
//  HuiLife
//
//  Created by 闻喜惠生活 on 2018/12/21.
//

#import "HLCalendarMonthModel.h"
#import "NSDate+HLCalendar.h"

@implementation HLCalendarMonthModel

- (instancetype)initWithDate:(NSDate *)date {
    
    if (self = [super init]) {
        _monthDate = date;
        _totalDays = [self setupTotalDays];
        _firstWeekday = [self setupFirstWeekday];
        _year = [self setupYear];
        _month = [self setupMonth];
    }
    return self;
}

- (NSInteger)setupTotalDays {
    return [_monthDate totalDaysInMonth];
}

- (NSInteger)setupFirstWeekday {
    return [_monthDate firstWeekDayInMonth];
}

- (NSInteger)setupYear {
    return [_monthDate dateYear];
}

- (NSInteger)setupMonth {
    return [_monthDate dateMonth];
}

@end
