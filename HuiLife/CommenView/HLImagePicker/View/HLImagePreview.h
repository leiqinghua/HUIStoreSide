//
//  HLImagePreview.h
//  HuiLife
//
//  Created by 王策 on 2019/11/7.
//

#import <UIKit/UIKit.h>
#import "HLAsset.h"

NS_ASSUME_NONNULL_BEGIN

@interface HLImagePreview : UIView

@property (nonatomic, strong) PHAsset *asset;

@property (nonatomic, strong, readonly) UIImage *image;

// 外面裁减，或者完成时，需要点击这个
@property (nonatomic, copy) void (^imageProgressUpdateBlock)(double progress);

- (void)recoverSubviews;

@end

NS_ASSUME_NONNULL_END
