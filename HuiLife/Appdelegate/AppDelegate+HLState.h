//
//  AppDelegate+HLState.h
//  HuiLife
//
//  Created by 闻喜惠生活 on 2018/12/9.
//

#import "AppDelegate.h"

NS_ASSUME_NONNULL_BEGIN

@interface AppDelegate (HLState)

/// 注册切换状态的通知
- (void)hl_addLoginStateNotify;

@end

NS_ASSUME_NONNULL_END
