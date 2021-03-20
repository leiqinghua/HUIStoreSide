//
//  HLMonthModel.h
//  HuiLife
//
//  Created by 闻喜惠生活 on 2019/3/22.
//

#import <Foundation/Foundation.h>
#import "HLDayModel.h"
NS_ASSUME_NONNULL_BEGIN

@interface HLMonthModel : NSObject
//所属年份
@property(assign,nonatomic)NSInteger year;
//所属月份
@property(assign,nonatomic)NSInteger month;
//共有多少天
@property(assign,nonatomic)NSInteger totalDay;
//高度
@property(assign,nonatomic)CGFloat hight;

@property(copy,nonatomic)NSString * title;

@property(strong,nonatomic)NSArray<HLDayModel*> * days;
//每个月的第一天是周几
@property(assign,nonatomic)NSInteger firstWeekday;

@end

NS_ASSUME_NONNULL_END
