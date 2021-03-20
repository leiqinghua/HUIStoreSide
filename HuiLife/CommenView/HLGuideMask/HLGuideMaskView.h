//
//  HLGuideMaskView.h
//  HuiLife
//
//  Created by 王策 on 2019/10/15.
//

#import <UIKit/UIKit.h>
#import "HLGuideMaskDefine.h"
#import "HLGuideLayout.h"

NS_ASSUME_NONNULL_BEGIN

@interface HLGuideMaskView : UIView

- (void)drawWithGuideLayout:(HLGuideLayout *)guideLayout clickBlock:(HLGuideMaskClickBlock)clickBlock;

- (void)drawWithGuideLayoutArr:(NSArray <HLGuideLayout *>*)guideLayouts clickBlock:(HLGuideMaskClickBlock)clickBlock;

@end

NS_ASSUME_NONNULL_END
