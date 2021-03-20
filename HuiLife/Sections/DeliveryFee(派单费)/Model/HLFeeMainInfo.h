//
//  HLFeeMainInfo.h
//  HuiLife
//
//  Created by 雷清华 on 2020/5/18.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@class HLFeeBaseInfo;
@class HLFeeOrderInfo;
@class HLFeeTimeInfo;
@class HLFeeHeaderInfo;

typedef enum : NSUInteger {
    HLFeeBaseInfoTypeNormal,
    HLFeeBaseInfoTypeOrder,
    HLFeeBaseInfoTypeTime,
} HLFeeBaseInfoType;


@interface HLFeeMainInfo : NSObject

@property(nonatomic, copy) NSString *title;
@property(nonatomic, copy) NSString *dispatch_title;
//是否开启HUI到家配送服务 0关闭 1开启
@property(nonatomic, assign) BOOL is_dispatch;
@property(nonatomic, copy) NSString *distance_reward_title;
@property(nonatomic, copy) NSString *distance_reward_label;
@property(nonatomic, copy) NSString *consume_reward_title;
@property(nonatomic, copy) NSString *consume_reward_label;
@property(nonatomic, copy) NSString *tp_dispatch_title;
//是否开启第三方配送服务 0关闭 1开启
@property(nonatomic, assign) BOOL is_third_party;
//是否隐藏第三方配送服务模块 0隐藏 1展示，服务端控制
@property(nonatomic, assign) BOOL is_third_party_open;

//时间范围
@property(nonatomic, strong) NSArray *consume_time_set;

@property(nonatomic, strong) HLFeeBaseInfo *distance_fee_1;
@property(nonatomic, strong) HLFeeBaseInfo *distance_fee_2;
@property(nonatomic, strong) HLFeeBaseInfo *distance_fee_3;
//footer
@property(nonatomic, strong) HLFeeBaseInfo *distance_add_fee;


@property(nonatomic, strong) HLFeeOrderInfo* distance_reward_fee_1;
@property(nonatomic, strong) HLFeeOrderInfo* distance_reward_fee_2;
@property(nonatomic, strong) HLFeeOrderInfo* distance_reward_fee_3;

@property(nonatomic, strong) HLFeeTimeInfo *consume_reward_fee_1;
@property(nonatomic, strong) HLFeeTimeInfo *consume_reward_fee_2;
@property(nonatomic, strong) HLFeeTimeInfo *consume_reward_fee_3;
@property(nonatomic, strong) HLFeeTimeInfo *consume_reward_fee_4;

@property(nonatomic, strong) HLFeeBaseInfo *tp_distance_fee_1;
@property(nonatomic, strong) HLFeeBaseInfo *tp_distance_fee_2;
@property(nonatomic, strong) HLFeeBaseInfo *tp_distance_fee_3;
//footer
@property(nonatomic, strong) HLFeeBaseInfo *tp_distance_add_fee;

@property(nonatomic, strong) NSMutableArray *datasource;

@end

@interface HLFeeBaseInfo : NSObject
//最小派单费
@property(nonatomic, copy) NSString* limit_min_amount;
@property(nonatomic, copy) NSString *title;
@property(nonatomic, copy) NSString *label;
@property(nonatomic, copy) NSString * distance_amount;
@property(nonatomic, assign) CGFloat kilometre;
@property(nonatomic, copy) NSString *unit;

@property(nonatomic, copy) NSString *distanceKey;
@property(nonatomic, copy) NSString *value;
@property(nonatomic, strong) NSMutableDictionary *pargrams;
@property(nonatomic, assign) HLFeeBaseInfoType type;
//提示
@property(nonatomic, copy) NSString *toastStr;

- (BOOL)check;
@end

//派单费奖励
@interface HLFeeOrderInfo : HLFeeBaseInfo
@property(nonatomic, copy) NSString * order_amount;
@property(nonatomic, copy) NSString *orderKey;
@end

//消费高峰时间奖励
@interface HLFeeTimeInfo : HLFeeBaseInfo
@property(nonatomic, copy) NSString *start_time;
@property(nonatomic, copy) NSString *end_time;

@property(nonatomic, copy) NSString *startTimeKey;
@property(nonatomic, copy) NSString *endTimeKey;

@end


@interface HLFeeHeaderInfo : NSObject
//隐藏图片
@property(nonatomic, assign) BOOL hideTipV;
//
@property(nonatomic, assign) BOOL hideDesc;
//隐藏开关
@property(nonatomic, assign) BOOL hideSwitch;
//需不需要隐藏整个section
@property(nonatomic, assign) BOOL hideSection;
//是否打开开关
@property(nonatomic, assign) BOOL on;
//是否能编辑
@property(nonatomic, assign) BOOL canEdit;

@property(nonatomic, copy) NSString *title;

@property(nonatomic, copy) NSString *subTitle;

@property(nonatomic, strong) NSMutableArray<HLFeeBaseInfo *> *datasource;

@property(nonatomic, strong) HLFeeBaseInfo *footerInfo;

@property(nonatomic, assign) NSInteger index;
//参数
@property(nonatomic, copy) NSString *mainKey;

@property(nonatomic, strong) id value;

@end

NS_ASSUME_NONNULL_END
