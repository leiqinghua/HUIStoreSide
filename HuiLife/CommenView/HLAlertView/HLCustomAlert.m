//
//  HLAlertView.m
//  HuiLifeUserSide
//
//  Created by HuiLife on 2018/9/11.
//  Copyright © 2018年 wce. All rights reserved.
//

#import "HLCustomAlert.h"

#define kTopMarginH FitPTScreen(5)
#define kBottomViewH FitPTScreen(50)
#define kTitleLabelH FitPTScreen(30)

@interface HLCustomAlert ()

@property (strong, nonatomic) UIView *mainView;

@property (strong, nonatomic) UILabel *titleLab;

@property (strong, nonatomic) UIView *bottomV;

@property (nonatomic, assign) CGRect contentFrame;

@end

@implementation HLCustomAlert


/// 快捷展示
+ (void)showNormalStyleTitle:(NSString *)title message:(NSString *)message buttonTitles:(NSArray *)buttonTitles buttonColors:(NSArray *)buttonColors callBack:(HLCustomAlertCallBack)callBack{
    HLCustomAlert *alertView = [[HLCustomAlert alloc] initWithContentFrame:CGRectMake(0, 0, FitPTScreen(280), FitPTScreen(150))];
    alertView.title = title;
    alertView.message = message;
    alertView.buttonTitles = buttonTitles;
    alertView.buttonColors = buttonColors;
    alertView.callBack = callBack;
    [alertView show];
}

- (instancetype)initWithContentFrame:(CGRect)contentFrame{
    self = [super initWithFrame:CGRectMake(0, 0, ScreenW, ScreenH)];
    if (self) {
        _contentFrame = contentFrame;
        self.backgroundColor = [UIColor colorWithWhite:0.0 alpha:0];
        
        self.titleFont = [UIFont systemFontOfSize:FitPTScreen(16)];
        self.titleColor = UIColorFromRGB(0x333333);
        
        self.messageFont = [UIFont systemFontOfSize:FitPTScreen(14)];
        self.messageColor = UIColorFromRGB(0x999999);
        
        self.buttonFont = [UIFont systemFontOfSize:FitPTScreen(15)];
        
        [self initSubViews];
    }
    return self;
}

- (void)initSubViews{
    // 主要视图
    _mainView = [[UIView alloc] initWithFrame:self.contentFrame];
    _mainView.center = CGPointMake(ScreenW/2, ScreenH/2);
    [self addSubview:_mainView];
    _mainView.backgroundColor = UIColor.whiteColor;
    _mainView.layer.cornerRadius = FitPTScreen(11);
    _mainView.layer.masksToBounds = YES;
    
    _titleLab = [[UILabel alloc] initWithFrame:CGRectMake(0, kTopMarginH, _mainView.frame.size.width, kTitleLabelH)];
    [_mainView addSubview:_titleLab];
    _titleLab.textAlignment = NSTextAlignmentCenter;
    
    _bottomV = [[UIView alloc] initWithFrame:CGRectMake(0, _mainView.frame.size.height - kBottomViewH, _mainView.frame.size.width, kBottomViewH)];
    [_mainView addSubview:_bottomV];
}

- (void)willMoveToSuperview:(UIView *)newSuperview{
    [super willMoveToSuperview:newSuperview];
    
    // 按钮
    CGFloat itemWidth = _mainView.bounds.size.width / _buttonTitles.count;
    for (NSInteger i = 0; i < _buttonTitles.count; i++) {
        UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(itemWidth * i, 0, itemWidth, _bottomV.frame.size.height)];
        [button setTitle:_buttonTitles[i] forState:UIControlStateNormal];
        [button setTitleColor:_buttonColors[i] forState:UIControlStateNormal];
        button.titleLabel.font = self.buttonFont;
        [_bottomV addSubview:button];
        button.tag = i;
        [button addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    
    // 判断有没有title
    if (self.title.length == 0) {
        self.titleLab.frame = CGRectMake(0, kTopMarginH, 0, 0);
        self.titleLab.hidden = YES;
    }else{
        self.titleLab.frame = CGRectMake(0, kTopMarginH, _mainView.frame.size.width, kTitleLabelH);
        self.titleLab.textColor = self.titleColor;
        self.titleLab.font = self.titleFont;
        self.titleLab.text = self.title;
    }
    
    // 判断有没有中间的view
    if (self.customView) {
        self.customView.frame = CGRectMake(0, CGRectGetMaxY(self.titleLab.frame), self.mainView.frame.size.width, self.mainView.frame.size.height - CGRectGetMaxY(self.titleLab.frame) - kBottomViewH);
        [self.mainView addSubview:self.customView];
    }else{
        UILabel *messageLab = [[UILabel alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(self.titleLab.frame), self.mainView.frame.size.width, self.mainView.frame.size.height - CGRectGetMaxY(self.titleLab.frame) - kBottomViewH)];
        [_mainView addSubview:messageLab];
        messageLab.text = _message;
        messageLab.numberOfLines = 0;
        messageLab.textAlignment = NSTextAlignmentCenter;
        messageLab.textColor = self.messageColor;
        messageLab.font = self.messageFont;
    }

    // 顶部横线
    UIView *topLine = [[UIView alloc] initWithFrame:CGRectMake(FitPTScreen(17), 0, _bottomV.frame.size.width - FitPTScreen(34), FitPTScreen(1))];
    [_bottomV addSubview:topLine];
    topLine.backgroundColor = UIColorFromRGB(0xEDEDED);
    
    // 中间分隔线
    if(_buttonTitles.count == 2){
        UIView *centerLine = [[UIView alloc] initWithFrame:CGRectMake(0, 0, FitPTScreen(1), FitPTScreen(15))];
        centerLine.center = CGPointMake(_bottomV.frame.size.width/2, _bottomV.frame.size.height/2);
        [_bottomV addSubview:centerLine];
        centerLine.backgroundColor = UIColorFromRGB(0xEDEDED);
    }
}

- (void)buttonClick:(UIButton *)sender{
    [self hide];
    if (self.callBack) {
        self.callBack(sender.tag);
    }
}



#pragma mark - Public Method

- (void)show{
    [[[UIApplication sharedApplication].delegate window] addSubview:self];
    [self.mainView hl_addPopAnimation];
    [UIView animateWithDuration:0.25 animations:^{
        self.backgroundColor = [UIColor colorWithWhite:0.0 alpha:0.3];
    }];
}

- (void)hide{
    [self endEditing:YES];
    [self removeFromSuperview];
}

@end
