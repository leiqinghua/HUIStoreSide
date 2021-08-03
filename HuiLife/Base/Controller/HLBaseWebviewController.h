//
//  HLBaseWebviewController.h
//  HuiLife
//
//  Created by 闻喜惠生活 on 2019/7/31.
//

#import "HLBaseViewController.h"
#import <WebKit/WebKit.h>

NS_ASSUME_NONNULL_BEGIN

//调用js 回调
typedef void(^HLJavaScriptCompletion)(id _Nullable data, NSError * _Nullable error);

@protocol HLBaseWebviewDelegate;

@interface HLBaseWebviewController: HLBaseViewController <HLBaseWebviewDelegate, WKUIDelegate,WKNavigationDelegate,WKScriptMessageHandler>

@property(nonatomic, strong) WKWebView *webview;
//用来做交互管理
@property(nonatomic, strong, readonly) WKUserContentController *userController;
//直接加载
@property(nonatomic, copy) NSString * loadUrl;
//是否隐藏导航栏
@property(nonatomic, assign) BOOL hideNavi;

//oc 调用js
- (void)addUserJavaScriptString:(NSString *)javaScropt completion:(HLJavaScriptCompletion)completion;

- (void)startLoadUrl;

- (void)resetWebViewFrame:(CGRect)frame;

//添加交互方法
- (void)addScriptMessageHandlerWithMethod:(NSString *)method;

- (void)setProgressFrame:(CGRect)frame;

- (void)setWebViewTitle:(NSString *)title;

@end



@protocol HLBaseWebviewDelegate <NSObject>

@optional
//交互方法(子类实现)
- (void)hl_userContentController:(WKUserContentController *)userContentController didReceiveScriptMessage:(WKScriptMessage *)message;

//页面加载完成
- (void)hl_webView:(WKWebView *)webView didFinishNavigation:(WKNavigation *)navigation;

//加载失败
- (void)hl_webView:(WKWebView *)webView didFailNavigationWithError:(NSError *)error;
//返回
- (void)hl_goFront;

- (void)hl_webView:(WKWebView *)webView decidePolicyForNavigationAction:(WKNavigationAction *)navigationAction decisionHandler:(void (^)(WKNavigationActionPolicy))decisionHandler;

@end
NS_ASSUME_NONNULL_END
