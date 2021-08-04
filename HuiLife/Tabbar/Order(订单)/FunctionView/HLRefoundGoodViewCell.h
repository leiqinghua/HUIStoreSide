//
//  HLRefoundGoodViewCell.h
//  HuiLife
//
//  Created by 闻喜惠生活 on 2018/12/25.
//

#import <UIKit/UIKit.h>
#import "HLRefundGoodModel.h"

@class HLRefoundGoodViewCell;

@protocol HLRefoundGoodViewCellDelegate <NSObject>

-(void)cell:(HLRefoundGoodViewCell*)cell changeNumWithModel:(HLRefundGoodModel*)model;

@end

@interface HLRefoundGoodViewCell : UITableViewCell

@property(strong,nonatomic)HLRefundGoodModel * goodModel;

@property(weak,nonatomic)id<HLRefoundGoodViewCellDelegate>delegate;

@property(assign,nonatomic)BOOL selectAll;

@end

