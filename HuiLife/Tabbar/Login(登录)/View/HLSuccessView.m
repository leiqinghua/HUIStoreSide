//
//  HLSuccessView.m
//  HuiLife
//
//  Created by 雷清华 on 2019/8/28.
//

#import "HLSuccessView.h"

@interface HLSuccessView ()

@property(nonatomic,copy)NSString * tipImage;

@property(nonatomic,copy)NSString * title;

@property(nonatomic,copy)NSString * buttonTitle;

@property(nonatomic,copy)void(^completion)(void) ;

@property(nonatomic,strong)UIView * bagView;

@property(nonatomic,strong)UIView * alertView;

@end

@implementation HLSuccessView

+(void)registerSuccessWithCompletion:(void(^)(void))completion{
    [self alertWithImage:@"success_yellow" title:@"注册成功！" buttonTitle:@"立即前往登录" completion:completion];
}

+(void)alertWithImage:(NSString *)tip title:(NSString *)title buttonTitle:(NSString *)buttonTitle completion:(void(^)(void))completion{
    HLSuccessView * successView = [[HLSuccessView alloc]initWithFrame:UIScreen.mainScreen.bounds Image:tip title:title buttonTitle:buttonTitle completion:completion];
    [KEY_WINDOW addSubview:successView];
    [successView showAnimate:YES];
}
//
-(instancetype)initWithFrame:(CGRect)frame Image:(NSString *)tip title:(NSString *)title buttonTitle:(NSString *)buttonTitle completion:(void(^)(void))completion{
    if (self = [super initWithFrame:frame]) {
        _title = title;
        _tipImage = tip;
        _buttonTitle = buttonTitle;
        _completion = completion;
        [self initView];
    }
    return self;
}

-(void)initView{
    _bagView = [[UIView alloc]initWithFrame:self.bounds];
    _bagView.backgroundColor = [UIColor colorWithWhite:0 alpha:0];
    [self addSubview:_bagView];
    
    _alertView = [[UIView alloc]init];
    _alertView.backgroundColor = UIColor.whiteColor;
    _alertView.layer.cornerRadius = FitPTScreen(17);
    [self addSubview:_alertView];
    [_alertView makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.centerY.equalTo(self);
        make.width.equalTo(FitPTScreen(198));
        make.height.equalTo(FitPTScreen(201));
    }];
    
    UIImageView * tipView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:_tipImage]];
    [_alertView addSubview:tipView];
    [tipView makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.alertView);
        make.top.equalTo(FitPTScreen(30));
    }];
    
    UILabel * tipLb = [[UILabel alloc]init];
    tipLb.text = _title;
    tipLb.textColor = UIColorFromRGB(0x333333);
    tipLb.font = [UIFont systemFontOfSize:FitPTScreen(14)];
    [_alertView addSubview:tipLb];
    [tipLb makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.alertView);
        make.top.equalTo(tipView.bottom).offset(FitPTScreen(10));
    }];
    
    UIButton * button = [[UIButton alloc]init];
    [button setBackgroundImage:[UIImage imageNamed:@"register_btn_bg"] forState:UIControlStateNormal];
    [button setTitle:_buttonTitle forState:UIControlStateNormal];
    button.titleLabel.font = [UIFont systemFontOfSize:FitPTScreen(14)];
    [_alertView addSubview:button];
    [button makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(tipLb.bottom).offset(FitPTScreen(10));
        make.centerX.equalTo(self.alertView);
        make.width.equalTo(FitPTScreen(155));
        make.height.equalTo(FitPTScreen(64));
    }];
    [button addTarget:self action:@selector(buttonClick) forControlEvents:UIControlEventTouchUpInside];
}

-(void)buttonClick{
    [self hideAnimate:YES];
    if (self.completion) {
        self.completion();
    }
}

-(void)showAnimate:(BOOL)animate{
    if (!animate) return;
    _alertView.alpha = 0.0;
    _alertView.transform = CGAffineTransformMakeScale(0.5, 0.5);
    [UIView animateWithDuration:0.25 animations:^{
        self.bagView.backgroundColor = [UIColor colorWithWhite:0 alpha:0.4];
        self.alertView.alpha = 1.0;
        self.alertView.transform = CGAffineTransformMakeScale(1.05, 1.05);
    } completion:^(BOOL finished) {
        [UIView animateWithDuration:0.2 animations:^{
            self.alertView.transform = CGAffineTransformIdentity;
        } completion:^(BOOL finished) {
            
        }];
    }];
}

-(void)hideAnimate:(BOOL)animate{
    if (!animate) [self removeFromSuperview];
    
    [UIView animateWithDuration:0.25 animations:^{
        self.bagView.backgroundColor = [UIColor colorWithWhite:0 alpha:0];
        self.alertView.alpha = 0.0;
        self.alertView.transform = CGAffineTransformMakeScale(0.9, 0.9);
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
    
}
@end
