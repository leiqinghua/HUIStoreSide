//
//  HLHUIMainTableCell.h
//  HuiLife
//
//  Created by 雷清华 on 2020/9/23.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@class HLHUIMainInfo;
@protocol HLHUIMainTableCellDelegate;

@interface HLHUIMainTableCell : UITableViewCell
@property(nonatomic, strong) HLHUIMainInfo *info;
@property(nonatomic, weak) id<HLHUIMainTableCellDelegate>delegate;
@end


@protocol HLHUIMainTableCellDelegate <NSObject>
- (void)mainCell:(HLHUIMainTableCell *)cell moreWithInfo:(HLHUIMainInfo *)info;

@end

NS_ASSUME_NONNULL_END
