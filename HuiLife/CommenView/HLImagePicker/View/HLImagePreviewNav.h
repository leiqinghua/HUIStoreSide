//
//  HLImagePreviewNav.h
//  HuiLife
//
//  Created by 王策 on 2019/11/8.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
@class HLImagePreviewNav;
@protocol HLImagePreviewNavDelegate <NSObject>

- (void)previewNav:(HLImagePreviewNav *)previewNav changedSelected:(BOOL)selected;

- (void)pageBackWithPreviewNav:(HLImagePreviewNav *)previewNav;

@end

@interface HLImagePreviewNav : UIView

@property (nonatomic, weak) id <HLImagePreviewNavDelegate> delegate;

+ (instancetype)previewNav;

- (void)configIndex:(NSInteger)index;

// 隐藏右上角
- (void)hidenIndexView;

@end

NS_ASSUME_NONNULL_END
