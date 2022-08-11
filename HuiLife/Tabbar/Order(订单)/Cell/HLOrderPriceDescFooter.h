//
//  HLOrderPriceDescFooter.h
//  iOS13test
//
//  Created by 雷清华 on 2019/10/31.
//  Copyright © 2019 雷清华. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HLOrderOpetionDelegate.h"
NS_ASSUME_NONNULL_BEGIN

@interface HLOrderPriceDescFooter : UITableViewHeaderFooterView

/// 设置金额
/// @param userMoney 用户收到退款金额
/// @param storeMoney 商家承担退款金额
- (void)configUserPrice:(NSString *)userMoney storePrice:(NSString *)storeMoney;

@property(nonatomic, assign)BOOL isOpen;

@property(nonatomic, weak) id<HLOrderOpetionDelegate> delegate;

@end

NS_ASSUME_NONNULL_END
