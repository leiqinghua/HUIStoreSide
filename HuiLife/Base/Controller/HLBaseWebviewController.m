//
//  HLBaseWebviewController.m
//  HuiLife
//
//  Created by 闻喜惠生活 on 2019/7/31.
//
//返回上一个页面

#import "HLBaseWebviewController.h"

@interface HLBaseWebviewController ()

@property(nonatomic,strong)WKWebViewConfiguration * configuration;

@property(nonatomic,strong)UIProgressView *progressView;

@property(nonatomic, strong,) WKUserContentController *userController;
//记录当前加载的url
@property(nonatomic, copy) NSString * curURL;

@end

@implementation HLBaseWebviewController

- (void)viewWillAppear:(BOOL)animated {
    
}

#pragma mark - public
//oc 调用js
- (void)addUserJavaScriptString:(NSString *)javaScropt completion:(HLJavaScriptCompletion)completion {
    [self.webview evaluateJavaScript:javaScropt completionHandler:^(id _Nullable data, NSError * _Nullable error) {
        if (completion) {
            completion(data,error);
        }
    }];
}

//添加交互方法
- (void)addScriptMessageHandlerWithMethod:(NSString *)method {
    [self.configuration.userContentController addScriptMessageHandler:self name:method];
}

- (void)setLoadUrl:(NSString *)loadUrl {
    _loadUrl = [self appendParamsForUrl:loadUrl];
    _curURL = _loadUrl;
    [self startLoadUrl];
}

- (void)setProgressFrame:(CGRect)frame {
//    高度固定
    self.progressView.frame = CGRectMake(frame.origin.x, frame.origin.y, frame.size.width, FitPTScreen(3));
}

- (void)setWebViewTitle:(NSString *)title {
    [self hl_setTitle:title];
}

/// 拼接完整的h5url
- (NSString *)appendParamsForUrl:(NSString *)url{
    NSMutableString *result = nil;
    if ([url containsString:@"?"]) {
        result = [NSMutableString stringWithString:url];
    } else {
        result = [NSMutableString stringWithFormat:@"%@?",url];
    }
    
    NSString *tokenStr = [NSString stringWithFormat:@"token=%@",[HLAccount shared].token];
    if (![result containsString:tokenStr]) {
        if ([result hasSuffix:@"?"]) {
            [result appendFormat:@"%@",tokenStr];
        } else {
            [result appendFormat:@"&%@",tokenStr];
        }
    }
    
    NSString *iTypeStr = [NSString stringWithFormat:@"iType=%@",[HLTools DeviceName]];
    if (![result containsString:iTypeStr]) {
        if ([result hasSuffix:@"?"]) {
            [result appendFormat:@"%@",iTypeStr];
        } else {
            [result appendFormat:@"&%@",iTypeStr];
        }
    }
    
    NSString *idStr = [NSString stringWithFormat:@"id=%@",[HLAccount shared].userid];
    if (![result containsString:idStr]) {
        if ([result hasSuffix:@"?"]) {
            [result appendFormat:@"%@",idStr];
        } else {
            [result appendFormat:@"&%@",idStr];
        }
    }
    
    NSString *platformStr = @"platform=iOS";
    if (![result containsString:platformStr]) {
        if ([result hasSuffix:@"?"]) {
            [result appendString:platformStr];
        } else {
            [result appendFormat:@"&%@",platformStr];
        }
    }
    return result;
}

- (void)startLoadUrl {
    
    NSURL * url = [NSURL URLWithString:_curURL];
    NSMutableURLRequest * request = [NSMutableURLRequest requestWithURL:url cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:15];
    request.allHTTPHeaderFields = @{
        @"device-name":[HLTools systemDeviceType],      // 手机型号 iphonex
        @"device-alias":[HLTools deviceName],           // xx的iPhone
        @"sdk-version":[HLTools systemVersion],         // 10.2
        @"device-os":@"iOS",                                    // 系统
        @"device-id":[NSString UUID],                           // uuid
        @"app-official":@"ok",
        @"app-version-name":[HLTools appVersion],       // 系统版本号
        @"app-version-code":[[HLTools appVersion] stringByReplacingOccurrencesOfString:@"." withString:@""],     // 构建版本号
        @"language":[HLTools appLanguages],             // app语言
        @"id":[HLAccount shared].userid?:@"",
        @"token":[HLAccount shared].token?:@""
    };
    [self.webview loadRequest:request];
}

- (void)resetWebViewFrame:(CGRect)frame {
    self.webview.frame = frame;
}

- (void)hideProgressView {
    self.progressView.hidden = YES;
}

- (void)showLoading:(BOOL)show {
    if (show){ HLLoading(self.view);}
    else {HLHideLoading(self.view);}
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view addSubview:self.webview];
    [self.view addSubview:self.progressView];
    if (self.hideNavi) {
        [self resetWebViewFrame:CGRectMake(0, 0, ScreenW, ScreenH)];
        self.progressView.frame = CGRectMake(0, Height_StatusBar, ScreenW, FitPTScreen(3));
        [self.navigationController setNavigationBarHidden:YES animated:YES];
    } else {
        [self resetWebViewFrame:CGRectMake(0, Height_NavBar, ScreenW, ScreenH - Height_NavBar)];
        self.progressView.frame = CGRectMake(0, Height_NavBar, ScreenW, FitPTScreen(3));
        [self.navigationController setNavigationBarHidden:false animated:YES];
    }
    [self hl_interactivePopGestureRecognizerUseable];
    
}

//禁止捏合手势
- (void)prohibitScaleGesture {
    NSString *injectionJSString = @"var script = document.createElement('meta');"
    "script.name = 'viewport';"
    "script.content=\"width=device-width, user-scalable=no\";"
    "document.getElementsByTagName('head')[0].appendChild(script);";
    [self addUserJavaScriptString:injectionJSString completion:nil];
}

#pragma mark- WKNavigationDelegate
/* 页面加载完成 */
- (void)webView:(WKWebView *)webView didFinishNavigation:(WKNavigation *)navigation {
    [self prohibitScaleGesture];
    HLHideLoading(self.view);
    [webView.scrollView.mj_header endRefreshing];
    if ([self respondsToSelector:@selector(hl_webView:didFinishNavigation:)]) {
        [self hl_webView:webView didFinishNavigation:navigation];
    }
}

- (void)webView:(WKWebView *)webView didFailProvisionalNavigation:(WKNavigation *)navigation withError:(NSError *)error {
    [webView.scrollView.mj_header endRefreshing];
    HLHideLoading(self.view);
    if ([self respondsToSelector:@selector(hl_webView:didFailNavigationWithError:)]) {
        [self hl_webView:webView didFailNavigationWithError:error];
    }
}

//提交发生错误时调用
- (void)webView:(WKWebView *)webView didFailNavigation:(WKNavigation *)navigation withError:(NSError *)error {
    HLHideLoading(self.view);
    [self.webview.scrollView.mj_header endRefreshing];
    
    if ([self respondsToSelector:@selector(hl_webView:didFailNavigationWithError:)]) {
        [self hl_webView:webView didFailNavigationWithError:error];
    }
}

// 页面开始加载时调用
- (void)webView:(WKWebView *)webView didStartProvisionalNavigation:(WKNavigation *)navigation {
    _curURL = webView.URL.absoluteString;
    HLLog(@"点击页面跳转的url ===> %@",_curURL);
}

//交互管理
#pragma mark -  WKScriptMessageHandler
- (void)userContentController:(WKUserContentController *)userContentController didReceiveScriptMessage:(WKScriptMessage *)message{
    HLLog(@"name:%@\\\\n body:%@\\\\n frameInfo:%@\\\\n",message.name,message.body,message.frameInfo);
    //用message.body获得JS传出的参数体
    //    NSDictionary * parameter = message.body;
    //调用二维码扫描
    if ([self respondsToSelector:@selector(hl_userContentController:didReceiveScriptMessage:)]) {
        [self hl_userContentController:userContentController didReceiveScriptMessage:message];
    }
    
//    跳转页面
    if ([message.name isEqualToString:kiOSPushMethod]) {
        NSDictionary *bodyDict = message.body;
        [HLTools pushAppPageLink:bodyDict[@"iosArdess"] params:bodyDict[@"property"] needBack:NO];
        return;
    }
    
    if ([message.name isEqualToString:HLiOSHandlerGoBack]) {
        if ([self respondsToSelector:@selector(hl_goFront)]) {
            [self hl_goFront];
        }else{
            [self.navigationController popViewControllerAnimated:YES];
        }
        return;
    }
    
    if ([message.name isEqualToString:HLiOSShowLoading]) {
        [self showLoading:YES];
        return;
    }
    
    if ([message.name isEqualToString:HLiOSHideLoading]) {
        [self showLoading:false];
        return;
    }
    
    if ([message.name isEqualToString:HLiOSTokenExpires]) {
        [HLTools shwoMutableDeviceLogin:^{
            [self startLoadUrl];
        }];
        return;
    }
}

- (void)webView:(WKWebView *)webView decidePolicyForNavigationAction:(WKNavigationAction *)navigationAction decisionHandler:(void (^)(WKNavigationActionPolicy))decisionHandler {
    
    if ([self respondsToSelector:@selector(hl_webView:decidePolicyForNavigationAction:decisionHandler:)]) {
        [self hl_webView:webView decidePolicyForNavigationAction:navigationAction decisionHandler:decisionHandler];
        return;
    }
    decisionHandler(WKNavigationActionPolicyAllow);
}



#pragma mark - WKUIDelegate
// 在JS端调用alert函数时，会触发此代理方法。
// JS端调用alert时所传的数据可以通过message拿到
// 在原生得到结果后，需要回调JS，是通过completionHandler回调
- (void)webView:(WKWebView *)webView runJavaScriptAlertPanelWithMessage:(NSString *)message initiatedByFrame:(WKFrameInfo *)frame completionHandler:(void (^)(void))completionHandler {
    [HLTools showWithText:message];
    completionHandler();
}

#pragma mark - KVO回馈
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context {
    if ([keyPath isEqualToString:@"estimatedProgress"] &&[_webview isEqual:object] ) {
        [self.progressView setAlpha:1];
        BOOL animated = self.webview.estimatedProgress > self.progressView.progress;
        [self.progressView setProgress:self.webview.estimatedProgress
                              animated:animated];
        if (self.webview.estimatedProgress >= 1.0f) {
            [UIView animateWithDuration:0.3f delay:0.3f options:UIViewAnimationOptionCurveEaseOut animations:^{
                [self.progressView setAlpha:0.0f];
            } completion:^(BOOL finished) {
                [self.progressView setProgress:0.0f animated:NO];
            }];
        }
    } else if ([keyPath isEqualToString:@"title"] && [_webview isEqual:object]) {
        [self hl_setTitle:_webview.title];
    } else {
         [super observeValueForKeyPath:keyPath ofObject:object change:change context:context];
    }

}


#pragma mark - SET&GET
- (WKWebView *)webview {
    if (!_webview) {
        _webview = [[WKWebView alloc]initWithFrame:CGRectMake(0, 0, ScreenW, ScreenH) configuration:self.configuration];
        _webview.backgroundColor = UIColor.whiteColor;
        //UI代理
        _webview.UIDelegate = self;
        // 导航代理
        _webview.navigationDelegate = self;
        //添加进度条和 title 的kvo
        [_webview addObserver:self forKeyPath:@"estimatedProgress" options:NSKeyValueObservingOptionNew context:nil];
        [_webview addObserver:self forKeyPath:@"title" options:NSKeyValueObservingOptionNew context:nil];
        MJRefreshNormalHeader * header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
            [self.webview reload];
        }];
        _webview.scrollView.mj_header = header;
        
        AdjustsScrollViewInsetNever(self,_webview.scrollView);
    }
    return _webview;
}

- (WKWebViewConfiguration *)configuration {
    if (!_configuration) {
        _configuration = [[WKWebViewConfiguration alloc]init];
        _configuration.userContentController = self.userController;
        // 是使用h5的视频播放器在线播放, 还是使用原生播放器全屏播放
        _configuration.allowsInlineMediaPlayback = YES;
    }
    return _configuration;
}

- (WKUserContentController *)userController {
    if (!_userController) {
        _userController = [[WKUserContentController alloc]init];
        [_userController addScriptMessageHandler:self name:HLiOSHandlerGoBack];
        [_userController addScriptMessageHandler:self name:HLiOSHideLoading];
        [_userController addScriptMessageHandler:self name:HLiOSShowLoading];
        [_userController addScriptMessageHandler:self name:HLiOSTokenExpires];
        [_userController addScriptMessageHandler:self name:kiOSPushMethod];
    }
    return _userController;
}

//创建进度条
- (UIProgressView *)progressView {
    if (!_progressView) {
        _progressView = [[UIProgressView alloc]initWithFrame:CGRectMake(0, Height_StatusBar, ScreenW, FitPTScreen(3))];
        _progressView.backgroundColor = [UIColor  clearColor];
        _progressView.trackTintColor = UIColor.clearColor;
        _progressView.progressTintColor = UIColorFromRGB(0xFFAB19);
    }
    return _progressView;
}

- (void)dealloc {
    [_webview removeObserver:self forKeyPath:@"estimatedProgress" context:nil];
    [_webview removeObserver:self forKeyPath:@"title" context:nil];
}

@end
