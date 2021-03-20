//
//  AppDelegate+HLJPush.m
//  HuiLife
//
//  Created by 闻喜惠生活 on 2018/11/13.
//

#import "AppDelegate+HLJPush.h"
#import "HLAudioPlayManager.h"
#import "HLMessageViewController.h"
#import "HLMessageDetailController.h"
#import "UITabBar+HLBadge.h"
#import "HLBLEManager.h"

static NSString *appKey = @"fddc9c75ea71d8bc6ec135cf";
static NSString *channel = @"App Store";

@implementation AppDelegate (HLJPush)

- (void)hl_registerJPushWithOptions:(NSDictionary *)launchOptions{
    
    //JPUSH
    //notice: 3.0.0 及以后版本注册可以这样写，也可以继续用之前的注册方式
    JPUSHRegisterEntity * entity = [[JPUSHRegisterEntity alloc] init];
    entity.types = JPAuthorizationOptionAlert|JPAuthorizationOptionBadge|JPAuthorizationOptionSound;
    [JPUSHService registerForRemoteNotificationConfig:entity delegate:self];
    
    BOOL isProduction = YES;
#if DEBUG
    isProduction = NO;
#else
    isProduction = YES;
#endif
    [JPUSHService setupWithOption:launchOptions appKey:appKey
                          channel:channel
                 apsForProduction:isProduction
            advertisingIdentifier:nil];
}


- (void)application:(UIApplication *)application
didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken {
    HLLog(@"deviceToken = %@",deviceToken);
    [JPUSHService registerDeviceToken:deviceToken];
}

//注册apns失败
- (void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error {
    //Optional
    HLLog(@"did Fail To Register For Remote Notifications With Error: %@", error);
}

#pragma mark- JPUSHRegisterDelegate
#ifdef NSFoundationVersionNumber_iOS_9_x_Max
// iOS 10 Support
- (void)jpushNotificationCenter:(UNUserNotificationCenter *)center willPresentNotification:(UNNotification *)notification withCompletionHandler:(void (^)(NSInteger))completionHandler  API_AVAILABLE(ios(10.0)){
    
    // Required
    NSDictionary * userInfo = notification.request.content.userInfo;
    
    NSDictionary *aps = userInfo[@"aps"];
    
    if([notification.request.trigger isKindOfClass:[UNPushNotificationTrigger class]]) {
        [JPUSHService handleRemoteNotification:userInfo];//远程推送
        NSString * orderID = userInfo[@"aps"][@"order_id"];
        //打印小票
        [[HLBLEManager shared]printeDataWithOrderId:orderID blueTooth:YES wifiSn:@"" type:2 success:^{
            
        }];
        //如果是12.1 就在这播放声音，10-12 在扩展播放声音
        if (@available(iOS 12.1, *)) {
            if ([HLAccount shared].is_yy && [aps[@"sodm"] integerValue] == 1) {
                NSString * alert = userInfo[@"aps"][@"alert"];
                [[HLAudioPlayManager share]startSpeak:alert];
            }
        }
        [self receiveNotificationForground];
    }
    completionHandler(UNNotificationPresentationOptionSound|UNNotificationPresentationOptionAlert);
}

// iOS 10 Support
- (void)jpushNotificationCenter:(UNUserNotificationCenter *)center didReceiveNotificationResponse:(UNNotificationResponse *)response withCompletionHandler:(void (^)(void))completionHandler API_AVAILABLE(ios(10.0)){
    // Required
    NSDictionary * userInfo = response.notification.request.content.userInfo;
    if (@available(iOS 10.0, *)) {
        if([response.notification.request.trigger isKindOfClass:[UNPushNotificationTrigger class]]) {
            [JPUSHService handleRemoteNotification:userInfo];
            [self clickMessageBackGround:userInfo];
        }
    }
    completionHandler();
}

#endif
//iOS7及以上
- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo fetchCompletionHandler:(void (^)(UIBackgroundFetchResult))completionHandler {
    
    [JPUSHService handleRemoteNotification:userInfo];
    
    NSDictionary *aps = userInfo[@"aps"];
    NSString * storeid = aps[@"order_id"];
    
    if ([UIApplication sharedApplication].applicationState == UIApplicationStateActive) {
        if ([[UIDevice currentDevice].systemVersion doubleValue] < 10.0) {
            // 如果sodm等于1
            if ([HLAccount shared].is_yy && [aps[@"sodm"] integerValue] == 1) {
                NSString * alert = userInfo[@"aps"][@"alert"];
                [[HLAudioPlayManager share]startSpeak:alert];
            }
            [self receiveNotificationForground];
            //打印小票
            [[HLBLEManager shared]printeDataWithOrderId:storeid blueTooth:YES wifiSn:@"" type:2 success:^{
                
            }];
        }
    }else if ([UIApplication sharedApplication].applicationState == UIApplicationStateBackground){
        HLLog(@"程序在后台 或从后台点击通知栏 运行 该方法");
        //在后台的时候 都执行
        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:Is_have_message];
        [[HLBLEManager shared]printeDataWithOrderId:storeid blueTooth:YES wifiSn:@"" type:2 success:^{
            completionHandler(UIBackgroundFetchResultNewData);
        }];
    
    }else{
        HLLog(@"后台处于前台的过度");
        if ([[UIDevice currentDevice].systemVersion doubleValue] < 10.0) {//点击通知栏消息进入
            [self clickMessageBackGround:userInfo];
        }
    }
}

//处理前台收到的消息
-(void)receiveNotificationForground{
    //获取当前控制器
    HLBaseViewController * vc = [HLTools visiableController];
    if (![vc isKindOfClass:[HLMessageViewController class]]) {
        if (![[HLTools rootViewController].tabBar isHaveBadge:2]) {
            [[HLTools rootViewController].tabBar showBadgeOnItemIndex:2];
            //表示有未读消息
            [[NSUserDefaults standardUserDefaults]setBool:YES forKey:Is_have_message];
        }
    }else{//就在消息页面,通知消息页面刷新
        [[NSNotificationCenter defaultCenter]postNotificationName:HLReloadMessagePageNotifi object:nil];
        [[NSUserDefaults standardUserDefaults]setBool:NO forKey:Is_have_message];
    }
}

//点击通知栏消息进入
-(void)clickMessageBackGround:(NSDictionary *)userInfo{
    NSDictionary *apsDict = userInfo[@"aps"];
    if (!apsDict[@"sodm"] || !apsDict[@"order_id"]) {
        return;
    }
    //获取到当前的控制器,跳转到消息详情页面
    UIViewController * currentVC = [HLTools visiableController];
    HLMessageDetailController * detailVC = [[HLMessageDetailController alloc]init];
    detailVC.sodm = [apsDict[@"sodm"] integerValue];
    detailVC.order_id = apsDict[@"order_id"];
    [currentVC hl_pushToController:detailVC];
    if (!currentVC) {
        UINavigationController *navi = self.mainTabBarVC.selectedViewController;
        [navi pushViewController:detailVC animated:YES];
        [[NSUserDefaults standardUserDefaults]setBool:YES forKey:Is_have_message];
    }
}
@end
