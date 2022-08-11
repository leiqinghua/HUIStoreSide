//
//  HLStoreSelectViewCell.h
//  HuiLife
//
//  Created by 闻喜惠生活 on 2019/8/13.
//

#import <UIKit/UIKit.h>
#import "HLStoreModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface HLStoreSelectViewCell : UITableViewCell

@property(nonatomic,strong)HLStoreModel * model;

@property(assign,nonatomic)BOOL select;

@end

NS_ASSUME_NONNULL_END
