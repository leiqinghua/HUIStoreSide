//
//  UIViewController+SetBackGroundUI.h
//  HuiLife
//
//  Created by 闻喜惠生活 on 2018/7/12.
//

#import <UIKit/UIKit.h>

@interface UIViewController (SetBackGroundUI)<UINavigationControllerDelegate,UIGestureRecognizerDelegate>

/**
 设置controller背景图片
 
 @param image 图片
 */
- (void)hl_setBackgroundImage:(UIImage *)image;


- (void)hl_setTitleAttributes;
/**

 */
- (void)hl_hideNavcationBar;

/**
 设置滑动手势可用
 */
-(void)hl_interactivePopGestureRecognizerUseable;

/**
 设置导航栏透明
 */
- (void)hl_setTransparentNavtion;

/**
 设置标题内容和标题颜色
 
 @param title 标题内容
 @param color 标题颜色
 */
- (void)hl_setTitle:(NSString *)title andTitleColor :(UIColor *)color;


//设置标题内容（默认颜色）
-(void)hl_setTitle:(NSString *)title;

/**
 设置导航栏背景色
 */
- (void)hl_setBackgroundColor:(UIColor *)color;

/**
 设置导航栏背景色,是否隐藏底部横线
 */

-(void)hl_setBackgroundColor:(UIColor *)color showLine:(BOOL)show;

//导航栏渐变色
-(void)hl_GradientColor:(UIColor *)color;

/**
 把自己从导航控制器中移除
 */
- (void)hl_removeFromNav;

-(void)hl_removeAll;

-(void)hl_removeOthers;

//push到某个控制器
-(void)hl_pushToController:(UIViewController *)controller;

//父控制器
- (UIViewController *)fatherController;

@end
