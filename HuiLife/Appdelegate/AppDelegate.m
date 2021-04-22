//
//  AppDelegate.m
//  HuiLife
//
//  Created by 雷清华 on 2018/7/10.
//

#import "AppDelegate.h"
#import "IFlyMSC/IFlyMSC.h"
#import "HLAreaCache.h"
#import "AppDelegate+HLBugly.h"
#import "UITabBar+HLBadge.h"
#import "AppDelegate+HLJPush.h"
#import "AppDelegate+HLState.h"
#import <BaiduMapAPI_Base/BMKBaseComponent.h>//引入base相关所有的头文件
#import "HLMessageViewController.h"
#import <BMKLocationkit/BMKLocationComponent.h>
#import "AppDelegate+Network.h"
#import "AvoidCrash.h"
#import "HLJDAPIManager.h"

static NSString *appKey = @"fddc9c75ea71d8bc6ec135cf";
static NSString *channel = @"App Store";
static NSString *urlLinks = @"https://sapi.51huilife.cn/Hstoreversion/";
static NSString *wxAppKey = @"wx78999ba7073ec23c";

@interface AppDelegate ()<BMKLocationAuthDelegate>{
   
}

@end

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    //设置跟视图控制器
    [self hl_addLoginStateNotify];
    
    [self hl_configNetWork];
    
    /* 是否自动登录 */
    [HLNotifyCenter postNotificationName:NOTIFY_LOGIN_STATE object:@([HLAccount shared].isLogin)];
 
    //升级
    [HLTools updateVersionFromServer];
    
    //讯飞
    [self registerIFly];
    //推送
    [self hl_registerJPushWithOptions:launchOptions];
    
    //bugly
    [self hl_registerBugly];
//    百度地图
    [self registerBaiduMap];

//    注册微信API
    [HLPayManage configWXAppKey:wxAppKey urlLinks:urlLinks aliFromScheme:@""];
    
//    注册京东API
    [[HLJDAPIManager manager] registerJDAPI];
    
    // 防止普通crash
    [AvoidCrash becomeEffective];
    
    return YES;
}

//注册讯飞
- (void)registerIFly{
    NSString *initString = [[NSString alloc] initWithFormat:@"appid=%@", @"5b9a38bf"];
    [IFlySpeechUtility createUtility:initString];
}

- (void)registerBaiduMap{
    BMKMapManager *mapManager = [[BMKMapManager alloc] init];
    // 如果要关注网络及授权验证事件，请设定generalDelegate参数
    [mapManager start:@"6yn3g18HWistEfd5zKgraD8UWaX6gwG2"  generalDelegate:nil];
    [[BMKLocationAuth sharedInstance] checkPermisionWithKey:@"6yn3g18HWistEfd5zKgraD8UWaX6gwG2" authDelegate:self];
}

- (BOOL)application:(UIApplication *)application handleOpenURL:(NSURL *)url {
    return [[HLPayManage shareManage] handleOpenURL:url options:@{}];
}

- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation {
    return [[HLPayManage shareManage] handleOpenURL:url options:@{}];
}

// NOTE: 9.0以后使用新API接口
- (BOOL)application:(UIApplication *)app openURL:(NSURL *)url options:(NSDictionary<NSString*, id> *)options
{
    return [[HLPayManage shareManage] handleOpenURL:url options:options];
}

- (BOOL)application:(UIApplication *)application continueUserActivity:(NSUserActivity *)userActivity restorationHandler:(void (^)(NSArray<id<UIUserActivityRestoring>> * _Nullable))restorationHandler {
    return [[HLPayManage shareManage] handleOpenUniversalLink:userActivity];
}

- (void)onCheckPermissionState:(BMKLocationAuthErrorCode)iError{
    
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    /* 通过后台接口检查更新 */
    [HLTools updateVersionFromServer];
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    //进入前台的时候判断(点APP图标进来)
    HLBaseViewController * vc = [HLTools visiableController];
    if (![vc isKindOfClass:[HLMessageViewController class]]) {
        if ([[NSUserDefaults standardUserDefaults]boolForKey:Is_have_message]) {
            [_mainTabBarVC.tabBar showBadgeOnItemIndex:3];
        }
    }else{
        [[NSNotificationCenter defaultCenter]postNotificationName:HLReloadMessagePageNotifi object:nil];
    }
}

@end
