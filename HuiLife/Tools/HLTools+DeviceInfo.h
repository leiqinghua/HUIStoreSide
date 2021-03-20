//
//  HLTools+DeviceInfo.h
//  HuiLife
//
//  Created by 闻喜惠生活 on 2019/8/2.
//

#import "HLTools.h"

@interface HLTools (DeviceInfo)

+(NSString *)DeviceName;

/**
 获取手机型号
 
 @return 手机型号
 */
+ (NSString *)systemDeviceType;

/**
 获取app版本
 @return 版本号
 */
+ (NSString *)appVersion;

/**
 获取设备类型
 @return iPhone
 */
+ (NSString *)deviceModel;

/**
 获取设备名称
 @return 设备名称，xx的iPhone
 */
+ (NSString *)deviceName;

/**
 获取系统的名称
 @return 系统的名称，iOS
 */
+ (NSString *)systemName;

/**
 获取手机系统版本号
 @return 系统版本号，10.2
 */
+ (NSString *)systemVersion;

/**
 build版本号
 
 @return 1
 */
+ (NSString *)buildVersion;

/// 语言
+ (NSString*)appLanguages;

@end

