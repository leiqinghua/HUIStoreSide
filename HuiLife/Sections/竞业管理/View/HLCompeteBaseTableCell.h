//
//  HLCompeteBaseTableCell.h
//  HuiLife
//
//  Created by 雷清华 on 2020/11/11.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
@class HLCompeteStoreInfo;

typedef void(^CompeteUpDownCallBack)(HLCompeteStoreInfo *);

@interface HLCompeteBaseTableCell : UITableViewCell

@property(nonatomic, strong) HLCompeteStoreInfo *storeInfo;

@property(nonatomic, copy) CompeteUpDownCallBack upDownCallBack;

@end

NS_ASSUME_NONNULL_END
