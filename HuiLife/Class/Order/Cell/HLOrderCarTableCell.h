//
//  HLOrderCarTableCell.h
//  iOS13test
//
//  Created by 雷清华 on 2019/11/18.
//  Copyright © 2019 雷清华. All rights reserved.
//

#import "HLBaseTableViewCell.h"

@class HLOrderCarModel;

NS_ASSUME_NONNULL_BEGIN
@interface HLOrderCarTableCell : HLBaseTableViewCell
@property(nonatomic, strong) HLOrderCarModel *carModel;
@end
NS_ASSUME_NONNULL_END
