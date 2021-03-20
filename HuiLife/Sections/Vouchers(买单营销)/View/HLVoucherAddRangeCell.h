//
//  HLVoucherAddRangeCell.h
//  HuiLife
//
//  Created by 王策 on 2019/8/7.
//

#import "HLBaseInputViewCell.h"

NS_ASSUME_NONNULL_BEGIN

@class HLVoucherAddRangeInfo;
@class HLVoucherAddRangeCell;
@protocol HLVoucherAddRangeCellDelegate <NSObject>


- (void)rangeCell:(HLBaseInputViewCell *)cell secondDependView:(UIView *)view;

- (void)rangeCell:(HLBaseInputViewCell *)cell thirdDependView:(UIView *)view;


@end

@interface HLVoucherAddRangeCell : HLBaseInputViewCell

@property (nonatomic, weak) id <HLVoucherAddRangeCellDelegate> delegate;

@end

NS_ASSUME_NONNULL_END

@class HLVoucherAddRangeSubInfo;
@interface HLVoucherAddRangeInfo : HLBaseTypeInfo

/// 二级分类
@property (nonatomic, copy) NSArray <HLVoucherAddRangeSubInfo *>*secondArr;
@property (nonatomic, strong) HLVoucherAddRangeSubInfo *secondSubInfo;
@property (nonatomic, copy) NSArray *secondTitleArr;

/// 三级分类
@property (nonatomic, copy) NSArray <HLVoucherAddRangeSubInfo *>*thirdArr;
@property (nonatomic, strong) HLVoucherAddRangeSubInfo *thirdSubInfo;
@property (nonatomic, copy) NSArray *thirdTitleArr;

/// 选择完二级之后，如果三级有数据，置为空
- (void)cleanThridData;


/// 判断当前二级分类是否 == 新的
- (BOOL)secondSubInfoEqualTo:(HLVoucherAddRangeSubInfo *)subInfo;


/// 构建要提交的params
- (void)buildRangParams;

@end

@interface HLVoucherAddRangeSubInfo : NSObject

@property (nonatomic, copy) NSString *manage_name;
@property (nonatomic, copy) NSString *manage_id;
@property (nonatomic, copy) NSString *manage_code;

@end
