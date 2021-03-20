//
//  HLCalanderTableViewCell.h
//  HuiLife
//
//  Created by 闻喜惠生活 on 2019/3/22.
//

#import <UIKit/UIKit.h>
#import "HLBaseDateModel.h"


@interface HLCalanderDayCell :UICollectionViewCell

@property(strong,nonatomic)HLDayModel * dayModel;

@end

NS_ASSUME_NONNULL_BEGIN

@interface HLCalanderTableViewCell : UITableViewCell

@property(strong,nonatomic)HLBaseDateModel *baseModel;

@property(strong,nonatomic)HLMonthModel * model;

@end

NS_ASSUME_NONNULL_END


