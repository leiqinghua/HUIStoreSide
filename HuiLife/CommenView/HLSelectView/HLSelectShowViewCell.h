//
//  HLSelectShowViewCell.h
//  HuiLife
//
//  Created by 闻喜惠生活 on 2018/7/19.
//

#import <UIKit/UIKit.h>
#import "HLFilterView.h"

@interface HLSelectShowViewCell : UICollectionViewCell

@property(strong,nonatomic)HLFilterModel * model;

@property(strong,nonatomic)UILabel * title;

-(void)setUIDefault:(BOOL)isDefault;
@end
