//
//  HLWXManage.h
//  HLPayManage_Example
//
//  Created by 王策 on 2019/9/2.
//  Copyright © 2019 王策. All rights reserved.
//

#import "HLPayConfig.h"
#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface HLWXManage : NSObject

/**
 注册微信AppKey
 
 @param wxAppKey 微信AppKey
 */
+ (void)registWxAppKey:(NSString *)wxAppKey urlLinks:(NSString *)urlLinks;

/**
 处理url
 
 @param url url
 @return 结果
 */
- (BOOL)handleOpenURL:(NSURL*)url;

- (BOOL)handleOpenUniversalLink:(NSUserActivity *)userActivity;

/**
 检查是否有微信客户端
 
 @return 是否存在
 */
- (BOOL)wxAppIsInstalled;

/**
 准备支付
 
 @param payParams 微信支付需要的参数
 @param finishBlock 支付完成的回调
 */
- (void)prepareWXPayWithPayParams:(NSDictionary *)payParams
                      finishBlock:(HLPayFinishBlock)finishBlock;

/**
 单纯的分享文字, req.bText = YES
 
 @param text 要分享的文字
 @param scene 要分享的场景
 */
+ (void)shareToWXWithText:(NSString *)text scene:(HLSceneType)scene;

/**
 分享多媒体消息 req.bText = NO
 
 @param title 分享的标题
 @param description 分享的内容
 @param image 分享的小图片
 @param link 分享的链接
 @param scene 分享的场景
 */
+ (void)shareToWXWithTitle:(NSString *)title
               description:(NSString *)description
                     image:(UIImage *)image
                      link:(NSString *)link
                     scene:(HLSceneType)scene;


/**
 单纯的分享图片

 @param image 图片
 @param scene 分享的场景
 */
+ (void)shareToWXWithImage:(UIImage *)image scene:(HLSceneType)scene;


/**
 分享小程序

 @param userName 小程序username
 @param title 标题
 @param description 内容
 @param image 图片
 @param webpageUrl 低版本网页链接
 @param path 小程序页面的路径 不填默认拉起小程序首页
 */
+ (void)shareToWXWithMiniProgramUserName:(NSString *)userName title:(NSString *)title description:(NSString *)description image:(UIImage *)image webpageUrl:(NSString *)webpageUrl path:(NSString *)path;


/// 跳转微信小程序
/// @param userName 小程序username
/// @param path 小程序页面的路径 不填默认拉起小程序首页
/// @param json 额外信息
+ (void)jumpToWXMiniProgramWithUserName:(NSString *)userName path:(NSString *)path json:(NSString *)json;

/**
 //请求授权

 @param scope 应用授权作用域，如获取用户个人信息则填写snsapi_userinfo
 @param state
 
 用于保持请求和回调的状态，授权请求后原样带回给第三方。该参数可用于防止csrf攻击（跨站请求伪造攻击），建议第三方带上该参数，可设置为简单的随机数加session进行校验
 */
-(void)sendAuthRequestWithScope:(NSString *)scope state:(NSString *)state finishBlock:(HLAuthFinishBlock)finishBlock;

@end

NS_ASSUME_NONNULL_END
