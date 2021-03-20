//
//  HLGroupTableViewCell.h
//  HuiLife
//
//  Created by 闻喜惠生活 on 2019/8/14.
//

#import <UIKit/UIKit.h>
#import "HLGroupModel.h"


@class HLGroupTableViewCell;
@protocol HLGroupTableViewCellDelegate <NSObject>

/// 点击更多按钮
- (void)listViewCell:(HLGroupTableViewCell *)cell moreBtnClick:(HLGroupModel *)goodModel;

@end


@interface HLGroupTableViewCell : UITableViewCell

@property(nonatomic,strong)HLGroupModel * groupModel;

@property (nonatomic, weak) id <HLGroupTableViewCellDelegate> delegate;

@property (nonatomic, assign)BOOL select;

@end

