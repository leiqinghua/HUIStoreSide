//
//  HLRegisterViewCell.h
//  HuiLife
//
//  Created by 雷清华 on 2019/8/27.
//

#import <UIKit/UIKit.h>
#import "HLInfoModel.h"


@protocol HLRegisterViewCellDelegate <NSObject>

@optional

-(void)yzmClickWithInfo:(HLInfoModel *)info sender:(UIButton *)sender;

@end



@interface HLRegisterViewCell : UITableViewCell

@property(nonatomic,strong)HLInfoModel * infoModel;

@property(nonatomic,weak)id<HLRegisterViewCellDelegate>delegate;

@end

