//
//  HLVoucherQueryInfo.h
//  HuiLife
//
//  Created by 王策 on 2019/9/4.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@class HLVoucherQueryBankInfo;
@class HLVoucherQueryProvinceInfo;
@class HLVoucherQueryCityInfo;
@class HLVoucherQueryAreaInfo;

@interface HLVoucherQueryInfo : NSObject

@property (nonatomic, copy) NSArray<HLVoucherQueryBankInfo *> *bank_list;
@property (nonatomic, copy) NSArray<HLVoucherQueryProvinceInfo *> *city_list;

///// ***** 下面是一些逻辑 *********
/// 判断选择的市是否有区的数据
@property (nonatomic, assign) BOOL hasAreaData;

/// 获取省的title数组，这个获取一次就可以了
@property (nonatomic, copy) NSArray *provinceTitleArr;

/// 银行title数组
@property (nonatomic, copy) NSArray *bankTitleArr;

/// 当前的市数组
@property (nonatomic, copy) NSArray *cityArr;
@property (nonatomic, copy) NSArray *cityTitleArr;

/// 当前的区数组
@property (nonatomic, copy) NSArray *areaArr;
@property (nonatomic, copy) NSArray *areaTitleArr;

/// 选择省之后，重置市数组和区数组
- (void)resetCityArrAndClearAreaArrWithIndex:(NSInteger)index;

/// 选择市之后，重置区数组
- (void)resetAreaArrWithIndex:(NSInteger)index;

@end

@interface HLVoucherQueryBankInfo : NSObject

@property (nonatomic, copy) NSString *bank_id;
@property (nonatomic, copy) NSString *bank_name;

@end

@interface HLVoucherQueryProvinceInfo : NSObject

@property (nonatomic, copy) NSString *area_id;
@property (nonatomic, copy) NSString *area_name;
@property (nonatomic, copy) NSString *bank_city_code;
@property (nonatomic, copy) NSArray<HLVoucherQueryCityInfo *> *area_children;

@end

@interface HLVoucherQueryCityInfo : NSObject

@property (nonatomic, copy) NSString *area_id;
@property (nonatomic, copy) NSString *area_name;
@property (nonatomic, copy) NSString *bank_city_code;
@property (nonatomic, copy) NSArray<HLVoucherQueryAreaInfo *> *area_children;

@end

@interface HLVoucherQueryAreaInfo : NSObject

@property (nonatomic, copy) NSString *area_id;
@property (nonatomic, copy) NSString *area_name;
@property (nonatomic, copy) NSString *bank_city_code;

@end

NS_ASSUME_NONNULL_END
