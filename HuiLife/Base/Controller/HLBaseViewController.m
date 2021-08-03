//
//  HLBaseViewController.m
//  HuiLife
//
//  Created by 闻喜惠生活 on 2019/7/31.
//

#import "HLBaseViewController.h"


@interface HLBaseViewController ()

@property(nonatomic,strong) UIButton *backBtn;

@property(nonatomic,strong) UIView *backView;

@property (strong, nonatomic) HLNetWorkFailView *failView;

@end

@implementation HLBaseViewController


- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:false animated:YES];
    if (self.navigationController.childViewControllers.count>1) {
        [self hl_setBackgroundColor:UIColorFromRGB(0xFAFAFA) showLine:false];
        [self hl_hideBack:false];
    }else{
        [self hl_setBackgroundColor:UIColorFromRGB(0xFAFAFA) showLine:false];
    }
    // 页面进入时，改变状态栏类型
    [self setNeedsStatusBarAppearanceUpdate];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initBackButton];
    
    if (self.navigationController.viewControllers.count <= 1) {
        [self hl_hideBack:YES];
    }
    
    self.view.backgroundColor = UIColor.whiteColor;
}

#pragma mark - Override

- (UIStatusBarStyle)preferredStatusBarStyle{
    return self.statusBarStyle;
}

#pragma mark - Public Method

/// 改变状态栏的样式
- (void)hl_resetStatusBarStyle:(UIStatusBarStyle)barStyle{
    self.statusBarStyle = barStyle;
    [self setNeedsStatusBarAppearanceUpdate];
}

-(void)hl_hideBack:(BOOL)hide{
    _backView.hidden = hide;
}

-(void)hl_setBackImage:(NSString *)image{
    [_backBtn setImage:[UIImage imageNamed:image] forState:UIControlStateNormal];
}

/// 展示网络请求失败的页面
- (void)hl_showNetFail:(CGRect)frame callBack:(HLNetClickCallBack)callBack{
    if (!_failView) {
        _failView = [[HLNetWorkFailView alloc] initWithFrame:frame clickCallBack:callBack];
    }
    [self.view addSubview:_failView];
    [self.view bringSubviewToFront:_failView];
}

/// 隐藏网络请求失败的页面
- (void)hl_hideNetFail{
    [_failView removeFromSuperview];
}

- (void)hl_setStatuBarBackgroundColor:(UIColor *)color {
    UIView * statusBar = [[[UIApplication sharedApplication] valueForKey:@"statusBarWindow"] valueForKey:@"statusBar"];
    if ([statusBar respondsToSelector:@selector(setBackgroundColor:)]) {
        statusBar.backgroundColor = color;
    }
}

/// 黑色提示框
- (void)hl_showHint:(NSString *)hint{
    MBProgressHUD *hud = [[MBProgressHUD alloc]initWithView:self.view];
    hud.contentColor = [UIColor whiteColor];
    hud.bezelView.color = [UIColor blackColor];
    hud.mode = MBProgressHUDModeText;
    hud.label.text = hint;
    hud.label.numberOfLines = 0;
    hud.label.font = [UIFont systemFontOfSize:FitPTScreen(14)];
    hud.removeFromSuperViewOnHide = YES;
    [self.view addSubview:hud];
    [hud showAnimated:YES];
    [hud hideAnimated:YES afterDelay:1];
}

/// 展示loading
- (void)hl_showLoading{
    dispatch_main_async_safe(^{
        MBProgressHUD *hud = [[MBProgressHUD alloc] initWithView:self.view];
        hud.mode = MBProgressHUDModeIndeterminate;
        hud.animationType = MBProgressHUDAnimationZoom;
        hud.backgroundView.style = MBProgressHUDBackgroundStyleSolidColor;
        hud.backgroundView.color = [UIColor colorWithWhite:0.f alpha:.2f];
        hud.label.text = @"加载中";
        [self.view addSubview:hud];
        [hud showAnimated:YES];
    });
}

/// 隐藏loading
- (void)hl_hideLoading{
    dispatch_main_async_safe(^{
        MBProgressHUD *hud = [MBProgressHUD HUDForView:self.view];
        if (hud.mode == MBProgressHUDModeIndeterminate) {
            [MBProgressHUD hideHUDForView:self.view animated:NO];
        }
    });
}

//恢复网络后回调方法(由子类实现)
- (void)hl_resetNetworkForAction{
    
}

/// 跳转回栈中指定类型的vc，如果没有，则跳转回上一个页面
- (void)hl_popToControllerWithClassName:(NSArray *)classNameArr{
    for (UIViewController *controller in self.navigationController.viewControllers) {
        for (NSString *className in classNameArr) {
            if ([controller isKindOfClass:NSClassFromString(className)]) {
                [self.navigationController popToViewController:controller animated:YES];
                return;
            }
        }
    }
    // 没有的话，则跳转回上一个页面
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - Private Methods

/// 返回按钮
- (void)initBackButton {
    _backView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 30, 40)];
    UIBarButtonItem *left = [[UIBarButtonItem alloc]initWithCustomView:_backView];
    self.navigationItem.leftBarButtonItem = left;
    
    _backBtn = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 20, 20)];
    _backBtn.center = CGPointMake(5, CGRectGetMaxY(_backView.bounds)/2);
    [_backView addSubview:_backBtn];
    _backBtn.userInteractionEnabled = false;
    [_backBtn setImage:[UIImage imageNamed:@"back_black"] forState:UIControlStateNormal];
   
    UITapGestureRecognizer *backRecognizer = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(hl_goback)];
    [_backView addGestureRecognizer:backRecognizer];
}

- (void)hl_goback{
    [self.view endEditing:YES];
    if (self.navigationController && self.navigationController.viewControllers.count >1) {
        [self.navigationController popViewControllerAnimated:YES];
    }
}


@end
