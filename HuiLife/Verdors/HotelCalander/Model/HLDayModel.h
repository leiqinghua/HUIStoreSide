//
//  HLDayModel.h
//  HuiLife
//
//  Created by 闻喜惠生活 on 2019/3/22.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface HLDayModel : NSObject

@property(strong,nonatomic)NSDate * date;

@property(assign,nonatomic)NSInteger year;

@property(assign,nonatomic)NSInteger month;

@property(assign,nonatomic)NSInteger day;

@property(assign,nonatomic)BOOL isToday;

@property(assign,nonatomic)BOOL isStart;

@property(assign,nonatomic)BOOL isEnd;

//是否选中
@property(assign,nonatomic)BOOL isSelected;
//节日
@property(copy,nonatomic)NSString * festival;

@property(assign,nonatomic)BOOL isFestival;


@end

NS_ASSUME_NONNULL_END
