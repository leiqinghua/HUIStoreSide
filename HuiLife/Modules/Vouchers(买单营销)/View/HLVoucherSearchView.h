//
//  HLVoucherSearchView.h
//  HuiLife
//
//  Created by 王策 on 2019/9/4.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@class HLVoucherSearchView;
@protocol HLVoucherSearchViewDelegate <NSObject>

- (void)searchBtnClickWithSearchView:(HLVoucherSearchView *)searchView;

@end

@interface HLVoucherSearchView : UIView

@property (nonatomic, weak) id <HLVoucherSearchViewDelegate> delegate;

- (NSString *)searchWord;

- (void)clearSearchWord;

// 配置是否可以点击搜索
- (void)configSearchBtnEnabled:(BOOL)enable;

@end

NS_ASSUME_NONNULL_END
