//
//  HLCalanderWeekView.h
//  HuiLife
//
//  Created by 闻喜惠生活 on 2019/3/21.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef void(^HLCalanderCancel)(void);

@interface HLCalanderWeekView : UIView

-(instancetype)initWithFrame:(CGRect)frame callBack:(HLCalanderCancel) callBack;

@end

NS_ASSUME_NONNULL_END
