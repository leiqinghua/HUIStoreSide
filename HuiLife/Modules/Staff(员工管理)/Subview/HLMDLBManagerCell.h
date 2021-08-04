//
//  HLMDLBManagerCell.h
//  HuiLife
//
//  Created by 闻喜惠生活 on 2018/7/23.
//

#import <UIKit/UIKit.h>

@protocol HLMDLBManagerCellDelegate <NSObject>

-(void)didselectcellAt:(NSIndexPath *)index sender:(UIButton *)sender;

-(void)deleteSmallClassAtIndexPath:(NSIndexPath *)index;

@end

@interface HLMDLBManagerCell : UITableViewCell
//是否是选择类别
@property(assign,nonatomic)BOOL isSelect;
//记录当前cell的位置
@property(strong,nonatomic)NSIndexPath *indexpath;

@property(weak,nonatomic)id<HLMDLBManagerCellDelegate> delegate;


-(void)cancelSelect;

-(void)setContentWithDict:(NSDictionary *)dict;

-(void)hideLine:(BOOL)hide;

-(void)setSelectLB:(BOOL)isSelect;
@end
