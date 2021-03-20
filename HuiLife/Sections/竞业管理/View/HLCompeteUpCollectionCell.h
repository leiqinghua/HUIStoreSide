//
//  HLCompeteUpCollectionCell.h
//  HuiLife
//
//  Created by 雷清华 on 2020/11/11.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
@protocol HLCompeteCollectionDelegate;
@class HLCompeteUpPageInfo;
@class HLCompeteStoreInfo;

@interface HLCompeteUpCollectionCell : UICollectionViewCell

@property(nonatomic, strong) HLCompeteUpPageInfo *pageInfo;

@property(nonatomic, weak) id<HLCompeteCollectionDelegate> delegate;

@end

@protocol HLCompeteCollectionDelegate <NSObject>
//上下拉刷新
- (void)upCollectionCell:(HLCompeteUpCollectionCell *)cell down:(BOOL)down;

//上下架
- (void)upCollectionCellUpdate:(HLCompeteStoreInfo *)storeInfo;

@end

NS_ASSUME_NONNULL_END
