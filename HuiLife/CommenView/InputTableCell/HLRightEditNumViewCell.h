//
//  HLRightEditNumViewCell.h
//  HuiLife
//
//  Created by 雷清华 on 2020/9/27.
//

#import "HLBaseInputViewCell.h"

NS_ASSUME_NONNULL_BEGIN

@interface HLRightEditNumInfo :HLBaseTypeInfo

@property(nonatomic, copy) NSString *rightTip;
//整数部分最小值
@property(nonatomic, assign) NSInteger intMin;
//小数部分最小值
@property(nonatomic, assign) NSInteger dotMin;

@end

@interface HLRightEditNumViewCell : HLBaseInputViewCell

@end

NS_ASSUME_NONNULL_END
