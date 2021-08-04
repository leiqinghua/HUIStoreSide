//
//  HLBillViewController.h
//  HuiLife
//
//  Created by 闻喜惠生活 on 2018/12/27.
//

#import <UIKit/UIKit.h>

@interface HLBillViewController : HLBaseViewController
//是否是已结算
@property(assign,nonatomic)BOOL isEntried;

@property(copy,nonatomic)NSString * date;

@end

