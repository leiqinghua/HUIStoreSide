//
//  HLFinanceTableViewCell.h
//  HuiLife
//
//  Created by 闻喜惠生活 on 2018/12/26.
//

#import <UIKit/UIKit.h>
#import "HLFinanceModel.h"
NS_ASSUME_NONNULL_BEGIN

@interface HLFinanceTableViewCell : UITableViewCell

@property(strong,nonatomic)HLFinanceModel *model;
//用于已入账页面
@property(strong,nonatomic)HLEntriedModel * entriedModel;

@end

NS_ASSUME_NONNULL_END
