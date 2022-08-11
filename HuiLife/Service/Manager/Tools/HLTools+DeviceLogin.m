//
//  HLTools+DeviceLogin.m
//  HuiLife
//
//  Created by 闻喜惠生活 on 2019/8/2.
//

#import "HLTools+DeviceLogin.h"
#import "HLLoginController.h"


@implementation HLTools (DeviceLogin)

+ (void)shwoMutableDeviceLogin:(ReLogin)login{
    dispatch_main_async_safe(^{
        [HLTools showAlertWithCallBack:login];
    });
    
}

+ (void)showAlertWithCallBack:(ReLogin)login{

    if ([[UIApplication sharedApplication].delegate.window showTokenView]) {
        return;
    }
    [HLCustomAlert showNormalStyleTitle:@"温馨提示" message:@"登录超时，请重新登录" buttonTitles:@[@"退出登录",@"重新登录"] buttonColors:@[UIColorFromRGB(0x666666),UIColorFromRGB(0xFF9900)] callBack:^(NSInteger index) {
        [self exitLogin];
    }];
    
}

+ (void)showExpireTokenView{
    
    if ([[UIApplication sharedApplication].delegate.window showTokenView]) {
        return;
    }
    [HLCustomAlert showNormalStyleTitle:@"温馨提示" message:@"登录已超时,请重新登录" buttonTitles:@[@"退出登录"] buttonColors:@[UIColorFromRGB(0xFF9900)] callBack:^(NSInteger index) {
        [self exitLogin];
    }];
}

+ (void)exitLogin{
    //退出登录
    [HLNotifyCenter postNotificationName:NOTIFY_LOGIN_STATE object:@(NO)];
    //清除本地信息
    [[HLAccount shared] exitLogin];
}

@end
