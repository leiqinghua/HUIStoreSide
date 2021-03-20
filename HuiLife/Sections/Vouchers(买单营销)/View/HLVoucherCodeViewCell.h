//
//  HLVoucherCodeViewCell.h
//  HuiLife
//
//  Created by 王策 on 2019/8/4.
//

#import <UIKit/UIKit.h>
#import "HLVoucherCodeInfo.h"

@class HLVoucherCodeViewCell;
@protocol HLVoucherCodeViewCellDelegate <NSObject>

/// 删除二维码
- (void)codeViewCell:(HLVoucherCodeViewCell *)cell deleteCodeInfo:(HLVoucherCodeInfo *)codeInfo;

/// 下载图片
- (void)codeViewCell:(HLVoucherCodeViewCell *)cell downImgUrl:(NSString *)imgUrl;

@end

NS_ASSUME_NONNULL_BEGIN

@interface HLVoucherCodeViewCell : UICollectionViewCell

@property (nonatomic, weak) id <HLVoucherCodeViewCellDelegate> delegate;

@property (nonatomic, strong) HLVoucherCodeInfo *codeInfo;

@end

NS_ASSUME_NONNULL_END
