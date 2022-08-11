//
//  HLStoreDetailTableViewCell.h
//  HuiLife
//
//  Created by 闻喜惠生活 on 2018/10/22.
//

#import <UIKit/UIKit.h>
#import "HLStoreDetailModel.h"
#import "HLTextFieldCheckInputNumberTool.h"

@interface HLStoreDetailTableViewCell : UITableViewCell

@property (strong,nonatomic)HLStoreDetailModel * model;

@property (strong,nonatomic)NSIndexPath * indexPath;

@property (strong,nonatomic)HLTextFieldCheckInputNumberTool * tool;

@property (strong,nonatomic)NSMutableDictionary * pargram;

@end

