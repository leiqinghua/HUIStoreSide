//
//  HLUserExpireView.h
//  HuiLife
//
//  Created by 王策 on 2019/9/3.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef void(^HLUserExpireClickBlock)(void);

@interface HLUserExpireView : UIView

+ (void)showUserExpireUpdateAlertTip:(NSString *)tip clickBlock:(HLUserExpireClickBlock)clickBlock;

@end

NS_ASSUME_NONNULL_END
