//
//  HLHotSekillImageViewCell.h
//  HuiLife
//
//  Created by 王策 on 2019/8/7.
//

#import <UIKit/UIKit.h>
#import "HLHotSekillImageModel.h"
NS_ASSUME_NONNULL_BEGIN

@class HLHotSekillImageViewCell;
@protocol HLHotSekillImageViewCellDelegate <NSObject>

/// 点击删除
- (void)imageCell:(HLHotSekillImageViewCell *)cell deleteImageModel:(HLHotSekillImageModel *)imageModel;

/// 点击修改主图
- (void)imageCell:(HLHotSekillImageViewCell *)cell editImageModel:(HLHotSekillImageModel *)imageModel;

/// 点击重新上传
- (void)imageCell:(HLHotSekillImageViewCell *)cell reUploadImageModel:(HLHotSekillImageModel *)imageModel;

@end

@interface HLHotSekillImageViewCell : UICollectionViewCell

@property (nonatomic, weak) id <HLHotSekillImageViewCellDelegate> delegate;

@property (nonatomic, strong) HLHotSekillImageModel *imageModel;

@property (nonatomic, assign) BOOL hideSelect;

@end

NS_ASSUME_NONNULL_END
