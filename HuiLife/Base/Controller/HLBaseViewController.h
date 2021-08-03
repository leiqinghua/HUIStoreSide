//
//  HLBaseViewController.h
//  HuiLife
//
//  Created by 闻喜惠生活 on 2019/7/31.
//

#import <UIKit/UIKit.h>
#import "HLNetWorkFailView.h"

NS_ASSUME_NONNULL_BEGIN

@interface HLBaseViewController : UIViewController

@property (nonatomic, assign) UIStatusBarStyle statusBarStyle;

/// 修改状态栏的颜色
-(void)hl_setStatuBarBackgroundColor:(UIColor *)color;

/// 黑色提示框
- (void)hl_showHint:(NSString *)hint;

/// 展示loading
- (void)hl_showLoading;

/// 隐藏loading
- (void)hl_hideLoading;

///恢复网络后回调方法(由子类实现)
- (void)hl_resetNetworkForAction;

- (void)hl_goback;

//隐藏返回按钮
- (void)hl_hideBack:(BOOL)hide;

//设置返回按钮的图片
- (void)hl_setBackImage:(NSString *)image;

/// 跳转回栈中指定类型的vc，如果没有，则跳转回上一个页面
- (void)hl_popToControllerWithClassName:(NSArray *)classNameArr;

/// 改变状态栏的样式
- (void)hl_resetStatusBarStyle:(UIStatusBarStyle)barStyle;

/// 展示网络请求失败的页面
- (void)hl_showNetFail:(CGRect)frame callBack:(HLNetClickCallBack)callBack;

/// 隐藏网络请求失败的页面
- (void)hl_hideNetFail;
@end

NS_ASSUME_NONNULL_END
