//
//  HLDeskNumViewCell.h
//  HuiLife
//
//  Created by 雷清华 on 2020/1/13.
// 

#import "HLBaseTableViewCell.h"
#import "HLSubOrderModel.h"
NS_ASSUME_NONNULL_BEGIN

@interface HLOrderImgLbViewCell : HLBaseTableViewCell

@property(nonatomic, copy) NSString *tipImgUrl;

@property(nonatomic, copy) NSString *tip;

- (void)controlSubViewsHidden:(BOOL)hidden;

@end

NS_ASSUME_NONNULL_END
