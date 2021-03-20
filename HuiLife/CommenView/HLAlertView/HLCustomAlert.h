//
//  HLAlertView.h
//  HuiLifeUserSide
//
//  Created by HuiLife on 2018/9/11.
//  Copyright © 2018年 wce. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^HLCustomAlertCallBack)(NSInteger index);

@interface HLCustomAlert : UIView

@property (copy, nonatomic) NSString *title;
@property (nonatomic, strong) UIColor *titleColor;
@property (nonatomic, strong) UIFont *titleFont;

@property (copy, nonatomic) NSString *message;
@property (nonatomic, strong) UIColor *messageColor;
@property (nonatomic, strong) UIFont *messageFont;

/// 中间的view，可以自定义
@property (nonatomic, strong) UIView *customView;

@property (nonatomic, copy) NSArray *buttonTitles;
@property (nonatomic, copy) NSArray *buttonColors;
@property (nonatomic, strong) UIFont *buttonFont;

@property (nonatomic, copy) HLCustomAlertCallBack callBack;

- (instancetype)initWithContentFrame:(CGRect)contentFrame;

- (void)show;

- (void)hide;

/// 快捷展示
+ (void)showNormalStyleTitle:(NSString *)title message:(NSString *)message buttonTitles:(NSArray *)buttonTitles buttonColors:(NSArray *)buttonColors callBack:(HLCustomAlertCallBack)callBack;

@end
