//
//  HLRightDownSelectCell.h
//  HuiLife
//
//  Created by 王策 on 2019/8/6.
//

#import "HLBaseInputViewCell.h"

NS_ASSUME_NONNULL_BEGIN
@class HLDownSelectSubInfo;
@interface HLDownSelectInfo : HLBaseTypeInfo

@property (nonatomic, strong) NSArray <HLDownSelectSubInfo *>*subInfos;
@property (nonatomic, copy) NSArray *titles;
@property (nonatomic, strong) HLDownSelectSubInfo *selectSubInfo;

- (void)buildParams;

@end

@interface HLDownSelectSubInfo : NSObject

@property (nonatomic, copy) NSString *Id;
@property (nonatomic, copy) NSString *name;

+ (instancetype)subInfoWithId:(NSString *)Id name:(NSString *)name;

@end

@class HLRightDownSelectCell;
@protocol HLRightDownSelectCellDelegate <NSObject>

- (void)downSeletCell:(HLRightDownSelectCell *)cell selectInfo:(HLDownSelectInfo *)selectInfo appendView:(UIView *)view;

@end

@interface HLRightDownSelectCell : HLBaseInputViewCell

@property (nonatomic, weak) id <HLRightDownSelectCellDelegate> delegate;

@end

NS_ASSUME_NONNULL_END
