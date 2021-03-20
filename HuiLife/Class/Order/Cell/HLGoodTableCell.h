//
//  HLGoodTableCell.h
//  iOS13test
//
//  Created by 雷清华 on 2019/10/29.
//  Copyright © 2019 雷清华. All rights reserved.
//

#import "HLBaseTableViewCell.h"
#import "HLOrderGoodModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface HLGoodTableCell : HLBaseTableViewCell

@property(nonatomic, strong) HLOrderGoodModel *goodModel;

@end

NS_ASSUME_NONNULL_END
