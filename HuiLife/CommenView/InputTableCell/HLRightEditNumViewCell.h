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

@property (nonatomic, assign) double maxNum;
@property (nonatomic, assign) double minNum;

@end

@interface HLRightEditNumViewCell : HLBaseInputViewCell

@end

NS_ASSUME_NONNULL_END
