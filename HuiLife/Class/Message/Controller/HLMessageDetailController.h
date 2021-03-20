//
//  HLMessageDetailController.h
//  HuiLife
//
//  Created by 闻喜惠生活 on 2018/9/12.
//

#import <UIKit/UIKit.h>
#import "HLMessageListModel.h"

@interface HLMessageDetailController : HLBaseViewController

@property (strong, nonatomic) HLMessageListModel *listModel;

/// 下面两个参数用于收到推送后处理

@property (copy, nonatomic) NSString *order_id;

@property (assign, nonatomic) NSInteger sodm; // 1收款 2退款

@end
