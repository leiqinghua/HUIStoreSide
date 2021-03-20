//
//  HLTradeTimeViewCell.h
//  HuiLife
//
//  Created by 闻喜惠生活 on 2019/8/11.
//

#import <UIKit/UIKit.h>
#import "HLBaseInputModel.h"

@interface HLTraidTimeInput:HLBaseInputModel

@property(nonatomic,strong)NSArray * weeks;

@property(nonatomic,strong)NSString * weekStr;

@property(nonatomic,strong)NSString * hourStr;

@end

@interface HLTradeTimeViewCell : UITableViewCell

@property(nonatomic,strong)HLBaseInputModel * inputModel;

@end

