//
//  HLStatuAlert.h
//  HuiLife
//
//  Created by 雷清华 on 2020/9/11.
// 状态弹框

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface HLStatuAlert : UIView

+ (void)showWithStatuPic:(NSString *)pic message:(NSString *)message callBack:(void(^)(void))callBack ;

@end

NS_ASSUME_NONNULL_END
