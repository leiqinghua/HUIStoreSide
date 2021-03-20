//
//  HLAssetCollectionViewCell.h
//  HuiLife
//
//  Created by 王策 on 2019/11/6.
//

#import <UIKit/UIKit.h>
#import "HLAsset.h"


NS_ASSUME_NONNULL_BEGIN

@class HLAssetCollectionViewCell;

@protocol HLAssetCollectionViewCellDelegate <NSObject>
@optional
- (void)assetCollectionViewCell:(HLAssetCollectionViewCell *)cell selected:(BOOL)selected;

@end

@interface HLAssetCollectionViewCell : UICollectionViewCell

// 代理
@property (nonatomic, weak) id <HLAssetCollectionViewCellDelegate> delegate;

// 如果外界只是选择一张图片的话，这里为YES，不展示勾选和下标
@property (nonatomic, assign) BOOL onlyPreview;

- (void)configAsset:(HLAsset *)asset arrayIndex:(NSInteger)index;

- (HLAsset *)asset;

- (void)configSelectButtonHidden;

- (void)configSelectStateIndex:(NSInteger)index;

- (void)configBorder:(BOOL)border;

- (void)configResizeTipLab:(BOOL)showTip;

@end

NS_ASSUME_NONNULL_END
