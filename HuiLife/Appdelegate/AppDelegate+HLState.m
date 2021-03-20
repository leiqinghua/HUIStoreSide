//
//  AppDelegate+HLState.m
//  HuiLife
//
//  Created by 闻喜惠生活 on 2018/12/9.
//

#import "AppDelegate+HLState.h"
#import "HLLoginController.h"
#import "MainTabBarController.h"
#import "HLNavigationController.h"

@implementation AppDelegate (HLState)

/// 注册切换状态的通知
- (void)hl_addLoginStateNotify{
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    self.window.backgroundColor = [UIColor whiteColor];
    [HLNotifyCenter addObserver:self selector:@selector(loginStateChanged:) name:NOTIFY_LOGIN_STATE object:nil];
}

-(void)loginStateChanged:(NSNotification *)sender{

    BOOL isLogin = [sender.object boolValue];
    self.window.rootViewController = nil;
    
    if (!isLogin) {//如果没有登录过
        HLLoginController * login = [[HLLoginController alloc]init];
        HLNavigationController * navi = [[HLNavigationController alloc]initWithRootViewController:login];
        self.window.rootViewController = navi;
        [self.window.layer addAnimation:[self changeAnimate] forKey:@"animation"];
    }else{
        MainTabBarController * tabar = [[MainTabBarController alloc]init];
        self.mainTabBarVC = tabar;
        self.window.rootViewController = tabar;
        [self.window.layer addAnimation:[self changeAnimate] forKey:@"animation"];
        [self.window makeKeyAndVisible];
    }
}

- (CATransition *)changeAnimate{
    CATransition *transition = [[CATransition alloc] init];
    transition.duration = 0.5;
    transition.type = kCATransitionReveal;
    transition.subtype = kCATransitionFromBottom;
    transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionDefault];
    return transition;
}

-(void)dealloc{
    [HLNotifyCenter removeObserver:self name:NOTIFY_LOGIN_STATE object:nil];
}

@end
