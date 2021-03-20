//
//  AppDelegate+HLBugly.m
//  HuiLife
//
//  Created by 闻喜惠生活 on 2018/11/14.
//

#import "AppDelegate+HLBugly.h"
#import <Bugly/Bugly.h>

@implementation AppDelegate (HLBugly)

-(void)hl_registerBugly{
    //腾讯bugly
    BuglyConfig *config = [[BuglyConfig alloc] init];
    //非正常退出事件
    config.unexpectedTerminatingDetectionEnable = YES;
    //卡顿监控
    config.blockMonitorEnable = YES;
    config.debugMode = YES;
    config.symbolicateInProcessEnable = YES;
#if DEBUG
    config.channel = @"DEBUG";
#else
    config.channel = @"AppStore";
#endif
    [Bugly startWithAppId:@"a1fe8ff93c" config:config];
}

@end
