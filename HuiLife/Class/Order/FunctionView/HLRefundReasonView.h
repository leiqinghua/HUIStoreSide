//
//  HLRefundReasonView.h
//  HuiLife
//
//  Created by 闻喜惠生活 on 2019/1/24.
//

#import <UIKit/UIKit.h>

typedef void(^SelectReason)(NSInteger index);

@interface HLRefundReasonView : UIView

@property(copy,nonatomic)SelectReason select;

@end

