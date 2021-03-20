//
//  HLBaseDateModel.h
//  HuiLife
//
//  Created by 闻喜惠生活 on 2019/3/26.
//

#import <Foundation/Foundation.h>
#import "HLMonthModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface HLBaseDateModel : NSObject

@property(strong,nonatomic)NSArray<HLMonthModel*>*months;

@property(strong,nonatomic,nullable)HLDayModel *startModel;

@property(strong,nonatomic,nullable)HLDayModel *endModel;
//共选择了多少天
@property(assign,nonatomic)NSInteger selectedDays;

+(instancetype)shared;

@end

NS_ASSUME_NONNULL_END
