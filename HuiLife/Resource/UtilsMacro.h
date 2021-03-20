//
//  UtilsMacro.h
//  HuiLife
//
//  Created by 闻喜惠生活 on 2018/7/12.
//

#ifndef UtilsMacro_h
#define UtilsMacro_h


#ifdef DEBUG
#define HLLog(FORMAT, ...) fprintf(stderr,"%s:%d\t%s\n",[[[NSString stringWithUTF8String:__FILE__] lastPathComponent] UTF8String], __LINE__, [[NSString stringWithFormat:FORMAT, ##__VA_ARGS__] UTF8String]);
#else
#define HLLog(FORMAT, ...) nil
#endif

#define XM_SAFE_BLOCK(BlockName, ...) ({ !BlockName ? nil : BlockName(__VA_ARGS__); })


// RGB颜色转换（16进制->10进制）
#define UIColorFromRGB(rgbValue)\
\
[UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 \
green:((float)((rgbValue & 0xFF00) >> 8))/255.0 \
blue:((float)(rgbValue & 0xFF))/255.0 \
alpha:1.0]

#define MAS_SHORTHAND
#define MAS_SHORTHAND_GLOBALS

//判断是否是ipad
#define isPad ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad)

/// 分割线颜色
#define SeparatorColor [UIColorFromRGB(0xD9D9D9) colorWithAlphaComponent:0.8]

//屏幕尺寸
#define ScreenW [UIScreen mainScreen].bounds.size.width
#define ScreenH [UIScreen mainScreen].bounds.size.height
//window
#define KEY_WINDOW [UIApplication sharedApplication].keyWindow

//PT
#define FitPTScreen(value) (value)*ScreenW/375.0
#define FitPTScreenH(value) (value)*ScreenH/667.0

#define FitScreenH(value)  isPad?(value)*ScreenH/667.0:FitPTScreen(value)

//weak
#define weakify(var) __weak typeof(var) weak_##var = var;


/// 第一个参数是当下的控制器适配iOS11 一下的，第二个参数表示scrollview或子类
#define AdjustsScrollViewInsetNever(controller,view) if(@available(iOS 11.0, *)) {view.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;} else if([controller isKindOfClass:[UIViewController class]]) {controller.automaticallyAdjustsScrollViewInsets = false;}


//===============================屏幕适配========================================
#define KIsiPhoneX ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(1125, 2436), [[UIScreen mainScreen] currentMode].size) : NO)

//判断iPhoneX
#define IS_IPHONE_X ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(1125, 2436), [[UIScreen mainScreen] currentMode].size)  && !isPad : NO)
//判断iPHoneXr
#define IS_IPHONE_Xr ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(828, 1792), [[UIScreen mainScreen] currentMode].size)  && !isPad : NO)
//判断iPhoneXs
#define IS_IPHONE_Xs ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(1125, 2436), [[UIScreen mainScreen] currentMode].size) && !isPad: NO)
//判断iPhoneXs Max
#define IS_IPHONE_Xs_Max ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(1242, 2688), [[UIScreen mainScreen] currentMode].size)  && !isPad : NO)

//iPhoneX系列
#define Height_StatusBar ((IS_IPHONE_X==YES || IS_IPHONE_Xr ==YES || IS_IPHONE_Xs== YES || IS_IPHONE_Xs_Max== YES) ? 44.0 : 20.0)
#define Height_NavBar ((IS_IPHONE_X==YES || IS_IPHONE_Xr ==YES || IS_IPHONE_Xs== YES || IS_IPHONE_Xs_Max== YES) ? 88.0 :64.0)
#define HIGHT_NavBar_MARGIN ((IS_IPHONE_X==YES || IS_IPHONE_Xr ==YES || IS_IPHONE_Xs== YES || IS_IPHONE_Xs_Max== YES) ? 24.f : 0.f)
#define Height_TabBar ((IS_IPHONE_X==YES || IS_IPHONE_Xr ==YES || IS_IPHONE_Xs== YES || IS_IPHONE_Xs_Max== YES) ? 83.0 : 49.0)
//距离底部的距离
#define Height_Bottom_Margn ((IS_IPHONE_X==YES || IS_IPHONE_Xr ==YES || IS_IPHONE_Xs== YES || IS_IPHONE_Xs_Max== YES) ? 34 : 0)
//微软雅黑字体
#define MicrosoftYaHeiFont(value)  [UIFont fontWithName:@"MicrosoftYaHei" size:FitPTScreenH(value)];

//loading 弹框
#define HLLoading(view) [HLTools showLoadingInView:view];
#define HLHideLoading(view) [HLTools hideLoadingForView:view];
#define HLShowHint(text,view) [HLTools showHint:text inView:view];
#define HLShowText(text) [HLTools showWithText:text];


#ifndef dispatch_main_async_safe
#define dispatch_main_async_safe(block)\
if (dispatch_queue_get_label(DISPATCH_CURRENT_QUEUE_LABEL) == dispatch_queue_get_label(dispatch_get_main_queue())) {\
block();\
} else {\
dispatch_async(dispatch_get_main_queue(), block);\
}
#endif


//微信登录授权key
#define hl_wxAuth_key @"hl_wxAuth_key"

//判断系统版本
#define iOS13Later [UIDevice currentDevice].systemVersion.floatValue >= 13.0

/*
 工号
 */
//#define user_name_key @"user_name_key"
//#define user_password_key @"user_password_key"//密码
//#define user_count_key @"user_count_key"//账号


#define Is_have_message @"isHaveMessage"//是否有未读消息
#define hl_update_date @"hl_update_date"//上次更新日期

/// userdefalut 存放的key值，用以debug环境取出，切换环境
#define NORMAL_SERVER_KEY @"normal_server_key"
#define STORE_SERVER_KEY @"store_server_key"
#define NORMAL_DOMEN_SERVER_KEY @"normal_domen_server_key"

/// 惠生活普通的
#define NORMAL_TEST_SERVER @"https://test.51huilife.cn/HuiLife_Api"
#define NORMAL_MID_SERVER  @"https://mid.sapi.51huilife.cn/HuiLife_Api"
#define NORMAL_PRODUCT_SERVER @"https://sapi.51huilife.cn/HuiLife_Api"

#define STORE_SERVICE_TEST_SERVER @"https://test.p1api.51huilife.com.cn"
#define STORE_SERVICE_MID_SERVER  @"https://mid.sp1api.51huilife.com.cn"
#define STORE_SERVICE_PRODUCT_SERVER @"https://sp1api.51huilife.com.cn"

#define NORMAL_DOMEN_TEST_SERVER @"https://test.51huilife.cn"
#define NORMAL_DOMEN_MID_SERVER  @"https://mid.51huilife.cn"
#define NORMAL_DOMEN_PRODUCT_SERVER @"https://sapi.51huilife.cn"

#define WX_MINIPAGRAM_USERNAME @"gh_82222abcb37f"
//我的顾客导出文件的文件夹
#define kcusExportDir  @"cusExportDir"
//HUI卡 卡密导出文件夹
#define kcardExportDir  @"cardExportDir"

#define HLiOSHandlerGoBack @"HLiOSHandlerGoBack"
#define HLiOSShowLoading @"HLiOSShowLoading"
#define HLiOSHideLoading @"HLiOSHideLoading"
#define HLiOSTokenExpires @"HLiOSTokenExpires"
//跳转页面
#define kiOSPushMethod   @"iOSPushMethod"
//本店收益 /离店收益
#define kiOSOnAOffStoreMethod   @"iOSOnAOffStoreMethod"

#endif /* UtilsMacro_h */
