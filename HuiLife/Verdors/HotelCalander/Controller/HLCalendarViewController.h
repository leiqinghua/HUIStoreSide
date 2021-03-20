//
//  HLCalendarViewController.h
//  HuiLife
//
//  Created by 闻喜惠生活 on 2019/3/21.
//

#import <UIKit/UIKit.h>


typedef void(^HLCalanderComplete)(NSDate *start,NSDate *end);

NS_ASSUME_NONNULL_BEGIN

@interface HLCalendarViewController : UIViewController

-(instancetype)initWithCallBack:(HLCalanderComplete)callBack;

@end

NS_ASSUME_NONNULL_END
