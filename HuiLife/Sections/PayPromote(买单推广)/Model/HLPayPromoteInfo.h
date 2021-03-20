//
//  HLPayPromoteInfo.h
//  HuiLife
//
//  Created by 王策 on 2019/8/13.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface HLPayPromoteInfo : NSObject

// 0 否 1 是
@property (nonatomic, assign) NSInteger status;
@property (nonatomic, assign) NSInteger isOrder;
@property (nonatomic, copy) NSString *firstDiscount;
@property (nonatomic, copy) NSString *preDay;
@property (nonatomic, copy) NSString *preDayTitle;
@property (nonatomic, copy) NSString *preDiscount;
@property (nonatomic, copy) NSString *comDiscount;


@end

NS_ASSUME_NONNULL_END

//status    是    int    是否开启推广
//firstDiscount    是    int    首单折扣
//preDay    是    int    特惠日(1234567代表日)
//preDiscount    是    int    特惠日折扣
//comDiscount    是    int    普通日折扣
//isOrder    是    int    点单外卖享受同等折扣
