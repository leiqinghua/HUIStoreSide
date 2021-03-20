//
//  NotificationService.m
//  HLNotificationExtension
//
//  Created by 闻喜惠生活 on 2018/9/15.
//

#import "NotificationService.h"
#import "JPushNotificationExtensionService.h"
#import <AVFoundation/AVFoundation.h>
#import "HLAudioPlayManager.h"

#ifdef NSFoundationVersionNumber_iOS_9_x_Max

@interface NotificationService (){
    
}
@property (nonatomic, strong) void (^contentHandler)(UNNotificationContent *contentToDeliver);
@property (nonatomic, strong) UNMutableNotificationContent *bestAttemptContent;

@end

@implementation NotificationService

- (void)didReceiveNotificationRequest:(UNNotificationRequest *)request withContentHandler:(void (^)(UNNotificationContent * _Nonnull))contentHandler {
    self.contentHandler = contentHandler;
    self.bestAttemptContent = [request.content mutableCopy];
    //发送本地通知
//    dispatch_semaphore_t semphore = dispatch_semaphore_create(0);
//    dispatch_time_t time = dispatch_time(DISPATCH_TIME_NOW, 0.5 * NSEC_PER_SEC);
//    [self registerLocalNotiWithSound:@"123.mp3" completion:^{
//        dispatch_after(time, dispatch_get_main_queue(), ^{
//            dispatch_semaphore_signal(semphore);
//        });
//    }];
//    dispatch_semaphore_wait(semphore, DISPATCH_TIME_FOREVER);
//    self.contentHandler(self.bestAttemptContent);
    
    
    if (@available(iOS 12.1, *)) {
        [self apnsDeliverWith:request];
        self.contentHandler(self.bestAttemptContent);
    } else {
        //不能播放固定音频
        NSUserDefaults *userDefault = [[NSUserDefaults alloc]initWithSuiteName:@"group.HuiLift"];
        NSString *yy = [userDefault objectForKey:@"is_yy"];
        NSDictionary *userInfo = request.content.userInfo;
        NSDictionary *aps = userInfo[@"aps"];
        if ([yy integerValue] == 1 && [aps[@"sodm"] integerValue] == 1) {
            [[HLAudioPlayManager share] startSpeak:[NSString stringWithFormat:@"%@",self.bestAttemptContent.body] finished:^{
                [self apnsDeliverWith:request];
                self.contentHandler(self.bestAttemptContent);
            }];
            return;
        }
        [self apnsDeliverWith:request];
        self.contentHandler(self.bestAttemptContent);
    }
}

//当超时后（30s），系统会回调这个方法，如果没有修改完推送内容，系统会转发原来的推送，
//在此方法中可以指定当系统强制终止修改时 ，做相应的处理
- (void)serviceExtensionTimeWillExpire {
    self.contentHandler(self.bestAttemptContent);
}

- (void)apnsDeliverWith:(UNNotificationRequest *)request {
    [JPushNotificationExtensionService jpushSetAppkey:@"fddc9c75ea71d8bc6ec135cf"];
    [JPushNotificationExtensionService jpushReceiveNotificationRequest:request with:^ {
        self.contentHandler(self.bestAttemptContent);
    }];
}

//注册本地通知
- (void)registerLocalNotiWithSound:(NSString *)name completion:(void(^)(void))completion {
//    请求用户授权
    [[UNUserNotificationCenter currentNotificationCenter]requestAuthorizationWithOptions:UNAuthorizationOptionSound completionHandler:^(BOOL granted, NSError * _Nullable error) {
        if (!granted) return ;
//        授权成功
        //创建通知内容
        UNMutableNotificationContent *content = [[UNMutableNotificationContent alloc]init];
        content.title = @"";
        content.subtitle = @"";
        content.body = @"";
        content.sound = [UNNotificationSound soundNamed:name];
//        创建通知触发
        /**
         触发器分为4种:
         1、UNPushNotificationTrigger//通过苹果服务器发送,用于远程推送
         2、UNTimeIntervalNotificationTrigger//在一定时间后触发
         3、UNCalendarNotificationTrigger//在某天某时触发
         4、UNLocationNotificationTrigger//在进入或离开某个区域触发
         */
        UNTimeIntervalNotificationTrigger *trigger = [UNTimeIntervalNotificationTrigger triggerWithTimeInterval:0.01 repeats:NO];
        //创建通知请求
        UNNotificationRequest *request = [UNNotificationRequest requestWithIdentifier:@"identifier" content:content trigger:trigger];
//        加入通知中心
        [[UNUserNotificationCenter currentNotificationCenter]addNotificationRequest:request withCompletionHandler:^(NSError * _Nullable error) {
            if (completion) {
                completion();
            }
        }];
    }];
}
#endif
@end
