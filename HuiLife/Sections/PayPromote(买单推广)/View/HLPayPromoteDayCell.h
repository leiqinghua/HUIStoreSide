//
//  HLPayPromoteDayCell.h
//  HuiLife
//
//  Created by 王策 on 2019/8/10.
//

#import "HLBaseInputViewCell.h"

NS_ASSUME_NONNULL_BEGIN

@class HLPayPromoteDaySubInfo;
@interface HLPayPromoteDayInfo : HLBaseTypeInfo

@property (nonatomic, copy) NSString *placeHorder;
@property (nonatomic, copy) NSArray <HLPayPromoteDaySubInfo *>*subInfos;
@property (nonatomic, strong) HLPayPromoteDaySubInfo *selectInfo;
@property (nonatomic, copy) NSArray *titles;

@end

@interface HLPayPromoteDaySubInfo : NSObject

@property (nonatomic, copy) NSString *Id;
@property (nonatomic, copy) NSString *name;

@end

@class HLPayPromoteDayCell;
@protocol HLPayPromoteDayCellDelegate <NSObject>

/// 点击下拉
- (void)dayCell:(HLPayPromoteDayCell *)cell depentView:(UIView *)view;

@end

@interface HLPayPromoteDayCell : HLBaseInputViewCell

@property (nonatomic, weak) id <HLPayPromoteDayCellDelegate> delegate;

- (void)resetImageViewAnimate;

@end

NS_ASSUME_NONNULL_END
