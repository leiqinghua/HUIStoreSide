//
//  HLPushListViewCell.h
//  HuiLife
//
//  Created by 王策 on 2021/4/26.
//

#import <UIKit/UIKit.h>
#import "HLPushListModel.h"

@class HLPushListViewCell;
@protocol HLPushListViewCellDelegate <NSObject>

//- ()

@end

NS_ASSUME_NONNULL_BEGIN

@interface HLPushListViewCell : UITableViewCell

@property (nonatomic, strong) HLPushListModel *listModel;

@property (nonatomic, assign) id <HLPushListViewCellDelegate> delegate;

@end

NS_ASSUME_NONNULL_END
