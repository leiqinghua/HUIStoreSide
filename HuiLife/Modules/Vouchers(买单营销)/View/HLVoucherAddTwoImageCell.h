//
//  HLVoucherAddTwoImageCell.h
//  HuiLife
//
//  Created by 王策 on 2019/8/20.
//

#import "HLBaseInputViewCell.h"

@interface HLVoucherTwoImageInfo : HLBaseTypeInfo

@property (nonatomic, copy) NSString *leftImageUrl;
@property (nonatomic, copy) NSString *rightImageUrl;
@property (nonatomic, strong) UIImage *leftImage;
@property (nonatomic, strong) UIImage *rightImage;

@end

NS_ASSUME_NONNULL_BEGIN

@class HLVoucherAddTwoImageCell;
@protocol HLVoucherAddTwoImageCellDelegate <NSObject>

/// 选择
- (void)twoImageCell:(HLVoucherAddTwoImageCell *)cell selectLeftImage:(BOOL)selectLeft;

@end

@interface HLVoucherAddTwoImageCell : HLBaseInputViewCell

@property (nonatomic, weak) id <HLVoucherAddTwoImageCellDelegate> delegate;

@end

NS_ASSUME_NONNULL_END
