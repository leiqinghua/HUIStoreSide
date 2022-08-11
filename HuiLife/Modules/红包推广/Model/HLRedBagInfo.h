//
//  HLRedBagInfo.h
//  HuiLife
//
//  Created by 雷清华 on 2020/11/18.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface HLRedBagInfo : NSObject
@property(nonatomic, copy) NSString *total;
@property(nonatomic, assign) NSInteger num;
//推广时间类型(0:10天 1:30天 2：领完为止)
@property(nonatomic, copy) NSString *timeType;
//推广范围类型(0:本店顾客 1:同城顾客)
@property(nonatomic, assign) NSInteger scopeType;

@property(nonatomic, strong) NSArray *rangTimes;

@end

NS_ASSUME_NONNULL_END
