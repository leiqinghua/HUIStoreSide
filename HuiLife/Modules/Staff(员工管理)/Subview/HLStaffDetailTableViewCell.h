//
//  HLStaffDetailTableViewCell.h
//  HuiLife
//
//  Created by 闻喜惠生活 on 2018/10/18.
//

#import <UIKit/UIKit.h>
#import "HLStaffDetailModel.h"

@interface HLStaffDetailTableViewCell : UITableViewCell

@property (strong,nonatomic)HLStaffDetailModel * model;

@property (strong,nonatomic)NSIndexPath * indexPath;

@property (strong,nonatomic)NSMutableDictionary * pargram;


@end

