//
//  HLAddressSearchView.h
//  HuiLife
//
//  Created by 王策 on 2019/9/29.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@class HLAddressSearchView;
@protocol HLAddressSearchViewDelegate <NSObject>

- (void)searchView:(HLAddressSearchView *)searchView editChanged:(NSString *)inputText canSearch:(BOOL)canSearch;

@end

@interface HLAddressSearchView : UIView

@property (nonatomic, weak) id <HLAddressSearchViewDelegate> delegate;

- (NSString *)inputText;

@end

NS_ASSUME_NONNULL_END
