//
//  HLTextFieldTableCell.h
//  HuiLife
//
//  Created by 闻喜惠生活 on 2019/8/3.
//

#import <UIKit/UIKit.h>
#import "HLBaseInputModel.h"

@interface HLTextFieldTableCell : UITableViewCell

@property(nonatomic,assign)BOOL lineHide;

@property(nonatomic,strong)HLBaseInputModel * inputModel;

@end

