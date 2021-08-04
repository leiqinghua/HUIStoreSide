//
//  HLOrderGoodModel.h
//  iOS13test
//
//  Created by 雷清华 on 2019/10/30.
//  Copyright © 2019 雷清华. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface HLOrderGoodModel : NSObject

@property(nonatomic, assign) NSInteger num;

@property(nonatomic, copy) NSString *param;

@property(nonatomic, copy) NSString *pay_price;

@property(nonatomic, copy) NSString *pic;

@property(nonatomic, copy) NSString *price;

@property(nonatomic, copy) NSString *title;

@end

NS_ASSUME_NONNULL_END

NS_ASSUME_NONNULL_BEGIN
//汽车服务
@interface HLOrderCarModel : NSObject

//商品名称
@property (copy, nonatomic) NSString *title;
//商品图片
@property (copy, nonatomic) NSString *pic;

//汽车类型
@property (copy, nonatomic) NSString *chexing;

//服务次数
@property (copy, nonatomic) NSString *fw_num;

//核销时间
@property (copy, nonatomic) NSString *hexiao_time;

/**
 洗车预约时间
 */
@property (copy, nonatomic) NSString *reserve_time;

/**
 汽车类型： 服务次数：
 */
@property (copy, nonatomic) NSString *descText;

/**
 预约时间：
 */
@property (copy, nonatomic) NSString *timetext;

@end
NS_ASSUME_NONNULL_END

NS_ASSUME_NONNULL_BEGIN
//hui 卡
@interface HLHUICardGoodInfo : NSObject
@property(nonatomic, assign) NSInteger num;
@property(nonatomic, copy) NSString *pay_price;
@property(nonatomic, copy) NSString *pic;
@property(nonatomic, copy) NSString *price;
@property(nonatomic, copy) NSString *title;
@end
NS_ASSUME_NONNULL_END
