//
//  HLStoreBuyHeadView.h
//  HuiLife
//
//  Created by 王策 on 2019/8/30.
//

#import <UIKit/UIKit.h>
#import "HLStoreBuyMainInfo.h"

NS_ASSUME_NONNULL_BEGIN

@class HLStoreBuyHeadView;
@protocol HLStoreBuyHeadViewDelegate <NSObject>

- (void)selectYearInfoChanged:(HLStoreBuyHeadView *)headView;

@end

@interface HLStoreBuyHeadView : UIView

@property (nonatomic, weak) id <HLStoreBuyHeadViewDelegate> delegate;

- (void)configMainInfo:(HLStoreBuyMainInfo *)mainInfo;

@end

NS_ASSUME_NONNULL_END
