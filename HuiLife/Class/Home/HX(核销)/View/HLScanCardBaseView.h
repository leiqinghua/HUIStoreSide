//
//  HLScanCardBaseView.h
//  HuiLife
//
//  Created by 雷清华 on 2020/8/28.
//

#import <UIKit/UIKit.h>

@class HLScanCardGoodInfo;

NS_ASSUME_NONNULL_BEGIN
@interface HLScanCardBaseView : UIView
@property(nonatomic, strong) HLScanCardGoodInfo *goodInfo;
- (void)initSubView;
- (void)tagView:(BOOL)show;
@end
NS_ASSUME_NONNULL_END

//卡
@interface HLScanCardView : HLScanCardBaseView

@end

//卷
@interface HLScanVolumeView : HLScanCardBaseView

@end

//礼品
@interface HLScanGiftView : HLScanCardBaseView

@end
