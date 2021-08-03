//
//  HLSetShopControlView.h
//  HuiLife
//
//  Created by 王策 on 2021/4/21.
//

#import <UIKit/UIKit.h>
#import "HLSetStoreModel.h"

@class HLSetShopControlView;

@protocol HLSetShopControlViewDelegate <NSObject>

/// 点击添加门店
- (void)addStoreWithControlView:(HLSetShopControlView *)controlView;

/// 点击删除
- (void)controlView:(HLSetShopControlView *)controlView deleteWithStoreModel:(HLSetStoreModel *)storeModel successBlock:(void(^)(void))successBlock;

/// 点击编辑
- (void)controlView:(HLSetShopControlView *)controlView editWithStoreModel:(HLSetStoreModel *)storeModel;

@end

NS_ASSUME_NONNULL_BEGIN

@interface HLSetShopControlView : UIView

@property (nonatomic, weak) id <HLSetShopControlViewDelegate> delegate;

- (void)hide;

- (void)configStores:(NSArray <HLSetStoreModel *>*)stores canAdd:(BOOL)canAdd;

@end

NS_ASSUME_NONNULL_END
