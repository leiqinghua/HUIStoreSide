//
//  HLNewOrderViewController.h
//  HuiLife
//
//  Created by 闻喜惠生活 on 2018/12/14.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface HLNewOrderViewController : HLBaseViewController
//从我的顾客跳转
@property(nonatomic, strong) NSDictionary *profitDict;

//离店收益 或 本店收益
- (void)configStoreProfitData;

@end

NS_ASSUME_NONNULL_END
