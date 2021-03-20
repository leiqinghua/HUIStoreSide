//
//  HLSekillPromoteListCell.h
//  HuiLife
//
//  Created by 王策 on 2019/8/14.
//

#import <UIKit/UIKit.h>
#import "HLSekillPromoteListModel.h"
NS_ASSUME_NONNULL_BEGIN

@class HLSekillPromoteListCell;
@protocol HLSekillPromoteListCellDelegate <NSObject>

- (void)sekillPromoteCell:(HLSekillPromoteListCell *)cell moreBtnClickListModel:(HLSekillPromoteListModel *)listModel;

@end

@interface HLSekillPromoteListCell : UITableViewCell

@property (nonatomic, weak) id <HLSekillPromoteListCellDelegate> delegate;

@property (nonatomic, strong) HLSekillPromoteListModel *listModel;

@end

NS_ASSUME_NONNULL_END
