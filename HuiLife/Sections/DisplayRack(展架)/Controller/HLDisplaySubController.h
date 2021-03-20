//
//  HLDisplaySubController.h
//  HuiLife
//
//  Created by 雷清华 on 2019/11/25.
//

#import "HLBaseViewController.h"

NS_ASSUME_NONNULL_BEGIN

@class HLDisplayModel;
@class HLDisplaySubController;
@protocol HLDisplaySubControllerDelegate <NSObject>

- (void)displayController:(HLDisplaySubController *)controller selectModel:(HLDisplayModel *)model;

@end

@interface HLDisplaySubController : HLBaseViewController

@property(nonatomic, weak)id<HLDisplaySubControllerDelegate> delegate;

- (void)resetFrame;

- (void)loadListWithClassId:(NSString *)classId type:(NSInteger)type proId:(NSString *)proId;

@end

NS_ASSUME_NONNULL_END
