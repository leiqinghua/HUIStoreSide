//
//  HLTools+DeviceLogin.h
//  HuiLife
//
//  Created by 闻喜惠生活 on 2019/8/2.
//

#import "HLTools.h"


typedef void(^ReLogin)(void);

@interface HLTools (DeviceLogin)

//404
+(void)shwoMutableDeviceLogin:(ReLogin)login;

//405
+(void)showExpireTokenView;

@end

