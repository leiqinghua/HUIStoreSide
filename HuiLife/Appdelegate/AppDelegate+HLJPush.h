//
//  AppDelegate+HLJPush.h
//  HuiLife
//
//  Created by 闻喜惠生活 on 2018/11/13.
//

#import "AppDelegate.h"
#import "JPUSHService.h"
// iOS10注册 APNs 所需头文件
#ifdef NSFoundationVersionNumber_iOS_9_x_Max
#import <UserNotifications/UserNotifications.h>

#endif

@interface AppDelegate (HLJPush)<JPUSHRegisterDelegate>

- (void)hl_registerJPushWithOptions:(NSDictionary *)launchOptions;

@end

