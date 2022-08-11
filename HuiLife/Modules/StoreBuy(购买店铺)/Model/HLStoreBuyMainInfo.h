//
//  HLStoreBuyMainInfo.h
//  HuiLife
//
//  Created by 王策 on 2019/8/30.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN
@class HLStoreBuyTypeInfo;
@class HLStoreBuyYearInfo;

@interface HLStoreBuyMainInfo : NSObject

@property (nonatomic, copy) NSString *zhifubutton;
@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *titleDesc;

@property (nonatomic, copy) NSArray<HLStoreBuyYearInfo *> *ruleData;
@property (nonatomic, copy) NSArray<HLStoreBuyTypeInfo *> *zhifuData;

- (HLStoreBuyYearInfo *)selectYearInfo;
- (HLStoreBuyTypeInfo *)selectTypeInfo;

/// 控制选中第一个年份 还有 支付方式
- (void)configDefaultSelectYearAndPayType;


@end

@interface HLStoreBuyYearInfo : NSObject

@property (nonatomic, assign) NSInteger Id;
@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSString *priceUnit;
@property (nonatomic, copy) NSString *grayDesc;
@property (nonatomic, copy) NSString *discount;
@property (nonatomic, assign) double price;

/// 自己加的
@property (nonatomic, assign) BOOL select;

@end

@interface HLStoreBuyTypeInfo : NSObject

@property (nonatomic, copy) NSString *value;
@property (nonatomic, copy) NSString *payment_id;

@property (nonatomic, copy) NSString *image;
@property (nonatomic, assign) BOOL select;

@property (nonatomic, assign) BOOL showInput;

@end

NS_ASSUME_NONNULL_END
