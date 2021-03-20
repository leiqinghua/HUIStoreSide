//
//  HLCarMarketViewCell.h
//  HuiLife
//
//  Created by 闻喜惠生活 on 2019/8/8.
//

#import <UIKit/UIKit.h>
#import "HLCardListModel.h"


@protocol HLCardMarketDelegate;
@interface HLCarMarketViewCell : UITableViewCell
//推广
@property(nonatomic,assign)BOOL isPromote;

@property(nonatomic,strong)UIImageView * bgView;

@property(nonatomic,strong)HLCardListModel * baseModel;

@property(nonatomic,weak)id<HLCardMarketDelegate>delegate;

-(void)initView;

-(void)configSelectCell;

@end


@protocol HLCardMarketDelegate <NSObject>

-(void)cardMarkcetCell:(HLCarMarketViewCell *)cell shareWithModel:(HLCardListModel *)model;

@end
