//
//  HLTicketTableViewCell.h
//  HuiLife
//
//  Created by 闻喜惠生活 on 2019/8/5.
//

#import <UIKit/UIKit.h>
#import "HLTicketModel.h"

@protocol HLTicketDelegate;
@interface HLTicketTableViewCell : UITableViewCell

@property(nonatomic,strong)HLTicketModel * model;

@property(nonatomic,assign)BOOL ticketPromote;

@property(nonatomic,strong)UIView * bagView;

@property(nonatomic,weak)id<HLTicketDelegate> mainDelegate;

-(void)initView;

-(void)configureSelectCell;

@end



@protocol HLTicketDelegate <NSObject>

@optional
-(void)ticketCell:(HLTicketTableViewCell *)cell shareWithModel:(HLTicketModel *)model;

@end
