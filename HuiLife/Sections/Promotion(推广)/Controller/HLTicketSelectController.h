//
//  HLTicketSelectController.h
//  HuiLife
//
//  Created by 闻喜惠生活 on 2019/8/11.
//

#import "HLBaseViewController.h"

NS_ASSUME_NONNULL_BEGIN

typedef void(^HLTicketPromoteBlock)(NSString * name,NSString * price,NSString * Id);

@interface HLTicketSelectController : HLBaseViewController

@property(nonatomic,copy)HLTicketPromoteBlock ticketPromoteBlock;

@end

NS_ASSUME_NONNULL_END
