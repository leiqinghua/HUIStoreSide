//
//  HLBuniessAlertView.h
//  HuiLife
//
//  Created by 闻喜惠生活 on 2018/11/21.
//

#import <UIKit/UIKit.h>
#import "HLMineModel.h"

typedef void(^CallBlock)(void);
NS_ASSUME_NONNULL_BEGIN

@interface HLBuniessAlertView : UIView

+(void)showWithModel:(HLMineModel *)model call:(CallBlock)callblock;

@end

NS_ASSUME_NONNULL_END
