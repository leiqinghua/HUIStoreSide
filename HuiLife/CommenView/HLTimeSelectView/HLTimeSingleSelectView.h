//
//  HLTimeSingleSelectView.h
//  HuiLife
//
//  Created by 王策 on 2019/8/5.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef void(^HLTimeCallBack)(NSString *date);

@interface HLTimeSingleSelectView : UIView

+ (void)showEditTimeView:(NSString *)date startWithToday:(BOOL)startWithToday callBack:(HLTimeCallBack)callBack;

@end

NS_ASSUME_NONNULL_END
