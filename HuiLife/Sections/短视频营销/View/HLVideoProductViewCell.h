//
//  HLVideoProductViewCell.h
//  HuiLife
//
//  Created by 王策 on 2021/4/23.
//

#import <UIKit/UIKit.h>
#import "HLVideoProductModel.h"
NS_ASSUME_NONNULL_BEGIN

@interface HLVideoProductViewCell : UITableViewCell

@property (nonatomic, strong) HLVideoProductModel *model;

// 选择的pro_id，如果匹配，那么显示已选择
@property (nonatomic, copy) NSString *pro_id;

/// 是否展示原价
@property (nonatomic, assign) BOOL showOrinalPrice;

@end

NS_ASSUME_NONNULL_END
