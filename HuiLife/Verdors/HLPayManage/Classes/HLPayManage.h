//
//  HLPayManage.h
//  HLPayManage_Example
//
//  Created by 王策 on 2019/9/2.
//  Copyright © 2019 王策. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HLWXManage.h"

// 1. 拿到微信开放平台申请的AppKey，在info中添加 URL Types
// 2. info.plist 添加白名单 LSApplicationQueriesSchemes weixin weichat alipay
// 3. 使用分享或支付之前请先调用 注册key的方法

NS_ASSUME_NONNULL_BEGIN

@interface HLPayManage : NSObject


@property (nonatomic, strong) HLWXManage *wxManage;
/**
 获取单例
 
 @return 单例对象
 */
+ (instancetype)shareManage;


/**
 注册key

 @param wxappKey 微信appkey
 @param aliFromScheme 支付宝的fromScheme
 */
+ (void)configWXAppKey:(NSString *)wxappKey urlLinks:(NSString *)urlLinks aliFromScheme:(NSString *)aliFromScheme;

/**
 调用支付
 
 @param params 传进来的支付参数字典
 @param finishBlock 支付完成的回调
 */
- (void)preparePayWithParams:(NSDictionary *)params finishBlock:(HLPayFinishBlock)finishBlock;


/**
 AppDelegate 下面三个方法中使用
 - (BOOL)application:(UIApplication *)application handleOpenURL:(NSURL *)url;
 - (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation;
 - (BOOL)application:(UIApplication *)app openURL:(NSURL *)url options:(NSDictionary<NSString*, id> *)options;

 @param url url
 @param options options
 */
- (BOOL)handleOpenURL:(NSURL *)url options:(NSDictionary<NSString*, id> *)options;


- (BOOL)handleOpenUniversalLink:(NSUserActivity *)userActivity;

@end

NS_ASSUME_NONNULL_END
