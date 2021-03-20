//
//  HLFeeSectionFooter.h
//  HuiLife
//
//  Created by 雷清华 on 2020/5/18.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
@class HLFeeBaseInfo;
@interface HLFeeSectionFooter : UITableViewHeaderFooterView

@property(nonatomic, assign) BOOL canEdit;
@property(nonatomic, strong) HLFeeBaseInfo *baseInfo;


@end

NS_ASSUME_NONNULL_END
