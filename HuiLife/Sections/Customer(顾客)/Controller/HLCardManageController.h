//
//  HLCardManageController.h
//  HuiLife
//
//  Created by 雷清华 on 2020/9/4.
//

#import "HLBaseViewController.h"

NS_ASSUME_NONNULL_BEGIN

@interface HLCardManageController : HLBaseViewController

@end

@protocol HLCardManageHeaderDelegate;
@interface HLCardManageHeader : UITableViewHeaderFooterView

@property(nonatomic, weak) id<HLCardManageHeaderDelegate>delegate;

@end


@protocol HLCardManageHeaderDelegate <NSObject>
//编辑
- (void)manageHeader:(HLCardManageHeader *)header textEdit:(NSString *)text;
//搜索
- (void)manageHeader:(HLCardManageHeader *)header search:(NSString *)text;

@end
NS_ASSUME_NONNULL_END


