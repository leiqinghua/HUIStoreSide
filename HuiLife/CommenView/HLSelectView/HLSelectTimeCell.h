//
//  HLSelectTimeCell.h
//  HuiLife
//
//  Created by 雷清华 on 2018/7/19.
//

#import <UIKit/UIKit.h>

typedef void(^DateSelected)(void);

@interface HLSelectTimeCell : UICollectionViewCell

@property(strong,nonatomic)UILabel *begin;

@property(strong,nonatomic)UILabel *end;

@property(strong,nonatomic)NSArray * dates;

@property(strong,nonatomic)NSArray *configerDates;

@property(copy,nonatomic)DateSelected dateSelected;

-(void)reset;
@end
