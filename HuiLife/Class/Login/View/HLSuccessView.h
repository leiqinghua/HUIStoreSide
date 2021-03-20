//
//  HLSuccessView.h
//  HuiLife
//
//  Created by 雷清华 on 2019/8/28.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface HLSuccessView : UIView

+(void)registerSuccessWithCompletion:(void(^)(void))completion;

+(void)alertWithImage:(NSString *)tip title:(NSString *)title buttonTitle:(NSString *)buttonTitle completion:(void(^)(void))completion;

@end

NS_ASSUME_NONNULL_END
