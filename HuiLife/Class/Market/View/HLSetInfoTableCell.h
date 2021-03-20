//
//  HLSetInfoTableCell.h
//  HuiLife
//
//  Created by 闻喜惠生活 on 2019/8/3.
//

#import <UIKit/UIKit.h>
#import "HLSetModel.h"
#import "HLTradeTimeViewCell.h"

@class HLSetInfoTableCell;
@protocol HLSetInfoTableCellDelegate <NSObject>

-(void)infoCell:(HLSetInfoTableCell *)cell selectWithModel:(HLBaseInputModel *)model;

@end

@interface HLSetInfoTableCell : UITableViewCell

@property(nonatomic,strong)HLSetModel * mainModel;

@property(nonatomic,weak)id<HLSetInfoTableCellDelegate> delegate;

@end

