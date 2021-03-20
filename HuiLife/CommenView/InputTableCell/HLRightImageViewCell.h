//
//  HLRightImageViewCell.h
//  HuiLife
//
//  Created by 王策 on 2019/8/4.
//

#import "HLBaseInputViewCell.h"

@interface HLRightImageTypeInfo : HLBaseTypeInfo

/// 选择的图片
@property (nonatomic, strong) UIImage *selectImage;

/// 设置的url
@property (nonatomic, copy) NSString *imageUrl;

/// 右下角展示的count，默认为0，外界不赋值，一直为0，赋值就会显示
@property (nonatomic, assign) NSInteger count;

@end

NS_ASSUME_NONNULL_BEGIN

@interface HLRightImageViewCell : HLBaseInputViewCell

@end

NS_ASSUME_NONNULL_END
