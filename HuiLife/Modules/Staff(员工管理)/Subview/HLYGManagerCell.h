//
//  HLYGManagerCell.h
//  HuiLife
//
//  Created by 闻喜惠生活 on 2018/7/20.
//

#import <UIKit/UIKit.h>
#import "HLStaffModel.h"
#import "HLStoreModel.h"

@interface HLYGManagerCell : UITableViewCell

@property(strong,nonatomic)UIImageView * selectImg;

//是否是选择门店
@property(assign,nonatomic)BOOL  isSelect;

//是否是门店列表
//@property(assign,nonatomic)BOOL isMDList;

//当选中cell的时候改变selectImg的状态
-(void)setCellSelected:(BOOL)select;

//------------修改-------------------
//员工model
@property(strong,nonatomic)HLStaffModel * staffModel;

@property(strong,nonatomic)HLStoreModel * storeModel;


@end
