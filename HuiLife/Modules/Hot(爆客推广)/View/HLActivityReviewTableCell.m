//
//  HLActivityReviewTableCell.m
//  HuiLife
//
//  Created by 雷清华 on 2020/2/20.
// 活动预览图

#import "HLActivityReviewTableCell.h"
#import "HLHotDetailMainModel.h"

@interface HLActivityReviewTableCell () <WKNavigationDelegate>
{
    NSInteger count;
}
@property(nonatomic, strong) UILabel *tipLb;

@property(nonatomic, strong) WKWebView *wkWebView;

@end

@implementation HLActivityReviewTableCell

- (void)initSubView {
    [super initSubView];
    [self showArrow:NO];
    
    self.backgroundColor = UIColor.clearColor;
    self.bagView.backgroundColor = UIColor.whiteColor;
    self.bagView.layer.cornerRadius = FitPTScreen(10);
    [self.bagView remakeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.contentView).insets(UIEdgeInsetsMake(FitPTScreen(5), FitPTScreen(10), FitPTScreen(5), FitPTScreen(10)));
    }];
    
    UIImageView *tipView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"member_left_tip"]];
    [self.bagView addSubview:tipView];
    [tipView makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(FitPTScreen(12));
        make.top.equalTo(FitPTScreen(15));
    }];
    
    _tipLb = [UILabel hl_singleLineWithColor:@"#222222" font:14 bold:YES];
    _tipLb.text = @"活动预览图";
    [self.bagView addSubview:_tipLb];
    [_tipLb makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(tipView.right).offset(FitPTScreen(10));
        make.centerY.equalTo(tipView);
    }];
    
    _wkWebView = [[WKWebView alloc]init];
    _wkWebView.scrollView.bounces = NO;
    _wkWebView.navigationDelegate = self;
    _wkWebView.scrollView.scrollEnabled = NO;
    _wkWebView.scrollView.showsVerticalScrollIndicator = NO;
    _wkWebView.scrollView.showsHorizontalScrollIndicator = NO;
    [self.bagView addSubview:_wkWebView];
    [_wkWebView makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.tipLb.bottom).offset(FitPTScreen(10));
        make.bottom.equalTo(FitPTScreen(-10));
        make.left.equalTo(FitPTScreen(10));
        make.right.equalTo(FitPTScreen(-10));
    }];
    
}


- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context{
    //    CGSize size = self.wkWebView.scrollView.contentSize;
    //    _mainModel.contentHight = size.height + FitPTScreen(60);
    //    [HLNotifyCenter postNotificationName:HLHotReloadHtmlHightNotifi object:nil];
    //    通知刷新
    
    HLLog(@"Height is changed! new=%@", [change valueForKey:NSKeyValueChangeNewKey]);
    //    NSLog(@"tianxia :%@",NSStringFromCGSize(self.wkWebView.scrollView.contentSize));
}


#pragma mark - WKNavigationDelegate
- (void)webView:(WKWebView *)webView didFinishNavigation:(WKNavigation *)navigation{
    [self prohibitScaleGesture];
    [self.bagView layoutIfNeeded];
    [webView evaluateJavaScript:@"document.body.scrollWidth"completionHandler:^(id _Nullable result,NSError * _Nullable error){
        HLLog(@"scrollHeight高度：%.2f",[result floatValue]);
        CGFloat ratio =  CGRectGetWidth(self.wkWebView.frame) /[result floatValue];
        [webView evaluateJavaScript:@"document.body.scrollHeight"completionHandler:^(id _Nullable result,NSError * _Nullable error){
            HLLog(@"scrollHeight高度：%.2f",[result floatValue]);
            HLLog(@"scrollHeight计算高度：%.2f",[result floatValue]*ratio);
            CGFloat newHeight = [result floatValue]*ratio;
            _mainModel.contentHight = newHeight + FitPTScreen(60);
            [HLNotifyCenter postNotificationName:HLHotReloadHtmlHightNotifi object:nil];
        }];
    }];
}


//禁止捏合手势
- (void)prohibitScaleGesture {
    NSString *injectionJSString = @"var script = document.createElement('meta');"
    "script.name = 'viewport';"
    "script.content=\"width=device-width, user-scalable=no\";"
    "document.getElementsByTagName('head')[0].appendChild(script);";
    [self addUserJavaScriptString:injectionJSString completion:nil];
}

- (void)addUserJavaScriptString:(NSString *)javaScropt completion:(HLJavaScriptCompletion)completion {
    [self.wkWebView evaluateJavaScript:javaScropt completionHandler:^(id _Nullable data, NSError * _Nullable error) {
        if (completion) {
            completion(data,error);
        }
    }];
}

- (void)setMainModel:(HLHotDetailMainModel *)mainModel {
    if (_mainModel) {
        return;
    }
    _mainModel = mainModel;
    [_wkWebView loadHTMLString:mainModel.content baseURL:nil];
}

@end
