//
//  HLOrderPriceDescCell.h
//  iOS13test
//
//  Created by 雷清华 on 2019/10/30.
//  Copyright © 2019 雷清华. All rights reserved.
//

#import "HLBaseTableViewCell.h"

NS_ASSUME_NONNULL_BEGIN

@interface HLOrderPriceDescCell : HLBaseTableViewCell

- (void)configUserPrice:(NSString *)userMoney store:(NSString *)storeMoney;

@end

NS_ASSUME_NONNULL_END
