//
//  HLFeatureTableCell.h
//  HuiLife
//
//  Created by 雷清华 on 2020/5/20.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
@class HLFeatureInfo;
@interface HLFeatureTableCell : UITableViewCell

@property(nonatomic, strong) HLFeatureInfo *info;

@end

NS_ASSUME_NONNULL_END
