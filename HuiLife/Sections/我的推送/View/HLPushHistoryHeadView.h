//
//  HLPushHistoryHeadView.h
//  HuiLife
//
//  Created by 王策 on 2021/4/26.
//

#import <UIKit/UIKit.h>
#import "HLPushHistoryModel.h"
NS_ASSUME_NONNULL_BEGIN

@interface HLPushHistoryHeadView : UIView

@property (nonatomic, copy) void(^pushBtnClick)(void);

- (void)confgiDataModel:(HLPushHistoryModel *)model;

@end

NS_ASSUME_NONNULL_END
