//
//  HLReviewFailAlert.h
//  HuiLife
//
//  Created by 雷清华 on 2020/12/23.
//

#import "HLBaseViewController.h"

NS_ASSUME_NONNULL_BEGIN
@class HLStatuFailInfo;
@interface HLReviewFailAlert : HLBaseViewController
@property(nonatomic, strong) HLStatuFailInfo *info;
@property(nonatomic, copy) void(^reCommitBlock)(void);
@end

NS_ASSUME_NONNULL_END
