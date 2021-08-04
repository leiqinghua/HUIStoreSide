//
//  HLUserExpireView.m
//  HuiLife
//
//  Created by 王策 on 2019/9/3.
//

#import "HLUserExpireView.h"

@interface HLUserExpireView ()

@property (strong, nonatomic) UIImageView *mainImgV;

@property (copy, nonatomic) NSString *title;

@property (copy, nonatomic) NSString *content;

@property (copy, nonatomic) NSString *tips;

@property (assign, nonatomic) BOOL mustUpdate;

@property (copy, nonatomic) HLUserExpireClickBlock clickBlock;

@end

@implementation HLUserExpireView

+ (void)showUserExpireUpdateAlertTip:(NSString *)tip clickBlock:(HLUserExpireClickBlock)clickBlock {
    
    for (UIView *subView in KEY_WINDOW.subviews) {
        if ([subView isKindOfClass:[HLUserExpireView class]]) {
            return;
        }
    }
    
    HLUserExpireView *expireView = [[HLUserExpireView alloc] initWithFrame:CGRectMake(0, 0, ScreenW, ScreenH) tips:tip];
    expireView.clickBlock = clickBlock;
    [expireView show];
}

- (instancetype)initWithFrame:(CGRect)frame tips:(NSString *)tips{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor colorWithWhite:0.0 alpha:0.0];
        _tips = tips;
        [self initSubViews];
    }
    return self;
}

- (void)initSubViews {
    
    // 构建主视图
    CGFloat leftMargin = FitPTScreen(52);
    _mainImgV = [[UIImageView alloc] initWithFrame:CGRectMake(leftMargin, 0, ScreenW - 2 * leftMargin, FitPTScreen(294))];
    [self addSubview:_mainImgV];
    _mainImgV.userInteractionEnabled = YES;
    _mainImgV.center = CGPointMake(ScreenW / 2, ScreenH / 2);
    _mainImgV.image = [UIImage imageNamed:@"user_expire_bg"];
    
    UIImageView *tipImgV = [[UIImageView alloc] init];
    [_mainImgV addSubview:tipImgV];
    tipImgV.image = [UIImage imageNamed:@"user_expire_tip"];
    [tipImgV makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(_mainImgV);
        make.height.equalTo(FitPTScreen(15));
        make.width.equalTo(FitPTScreen(171));
        make.top.equalTo(FitPTScreen(157));
    }];
    
    // 提示label
    UILabel *tipLab = [[UILabel alloc] init];
    [_mainImgV addSubview:tipLab];
    tipLab.textColor = UIColorFromRGB(0x999999);
    tipLab.numberOfLines = 2;
    tipLab.textAlignment = NSTextAlignmentCenter;
    tipLab.font = [UIFont systemFontOfSize:FitPTScreen(13)];
    [tipLab makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(FitPTScreen(10));
        make.right.equalTo(FitPTScreen(-10));
        make.top.equalTo(tipImgV.bottom).offset(FitPTScreen(15));
    }];
    tipLab.text = _tips ?: @"您的账户已到期\n开通账户可享用商+号所有功能";
    
    UIButton *openBtn = [[UIButton alloc] init];
    [_mainImgV addSubview:openBtn];
    [openBtn setBackgroundImage:[UIImage imageNamed:@"user_expire_open"] forState:UIControlStateNormal];
    [openBtn addTarget:self action:@selector(hide) forControlEvents:UIControlEventTouchUpInside];
    [openBtn setTitle:@"立即开通有效期" forState:UIControlStateNormal];
    [openBtn setTitleColor:UIColor.whiteColor forState:UIControlStateNormal];
    openBtn.titleLabel.font = [UIFont systemFontOfSize:FitPTScreen(13)];
    openBtn.titleEdgeInsets = UIEdgeInsetsMake(0, 0, FitPTScreen(2), 0);
    [openBtn makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self);
        make.width.equalTo(FitPTScreen(186));
        make.height.equalTo(FitPTScreen(51));
        make.top.equalTo(tipLab.bottom).offset(FitPTScreen(15));
    }];
    [openBtn addTarget:self action:@selector(buttonClick) forControlEvents:UIControlEventTouchUpInside];
}

- (void)buttonClick {
    if (!_mustUpdate) {
        [self hide];
    }
    if (self.clickBlock) {
        self.clickBlock();
    }
}

#pragma mark - Public Method

- (void)show {
    [[[UIApplication sharedApplication].delegate window] addSubview:self];
    // 添加弹出动画
    [self.mainImgV hl_addPopAnimation];
    [UIView animateWithDuration:0.25
                     animations:^{
                         self.backgroundColor = [UIColor colorWithWhite:0.0 alpha:0.3];
                     }];
}

- (void)hide {
    [self endEditing:YES];
    [self removeFromSuperview];
}

@end
