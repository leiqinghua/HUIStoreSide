//
//  HLOrderQrcodeView.m
//  HuiLife
//
//  Created by 雷清华 on 2020/7/23.
//

#import "HLOrderQrcodeView.h"

@interface HLOrderQrcodeView ()

@property(nonatomic, strong) UIView *coverView;
@property(nonatomic, strong) UIImageView *qrcodeView;
@property(nonatomic, strong) UIView *alertView;
@property(nonatomic, strong) UIImage *qrcode;
@property(nonatomic, strong) UIButton *closeBtn;
@end

@implementation HLOrderQrcodeView

+ (void)showWithQrcode:(NSString *)qrcode {
    [[SDWebImageDownloader sharedDownloader] downloadImageWithURL:[NSURL URLWithString:qrcode] options:SDWebImageDownloaderUseNSURLCache progress:nil completed:^(UIImage * _Nullable image, NSData * _Nullable data, NSError * _Nullable error, BOOL finished) {
        
        if (error) {
            return;
        }
        
        HLOrderQrcodeView *codeView = [[HLOrderQrcodeView alloc]initWithFrame:UIScreen.mainScreen.bounds qrcode:image];
        [[UIApplication sharedApplication].delegate.window addSubview:codeView];
        [codeView show];
    }];
}

- (instancetype)initWithFrame:(CGRect)frame qrcode:(UIImage *)qrcode
{
    self = [super initWithFrame:frame];
    if (self) {
        _qrcode = qrcode;
        [self initSubView];
    }
    return self;
}

- (void)initSubView {
    _coverView = [[UIView alloc]initWithFrame:self.bounds];
    _coverView.backgroundColor = [UIColor colorWithWhite:0 alpha:0];
    [self addSubview:_coverView];
    
    _alertView = [[UIView alloc]initWithFrame:CGRectMake(0, FitPTScreen(170), FitPTScreen(207), FitPTScreen(237))];
    _alertView.backgroundColor = UIColor.whiteColor;
    _alertView.center = CGPointMake(CGRectGetMidX(self.bounds), CGRectGetMidY(_alertView.frame));
    _alertView.layer.cornerRadius = FitPTScreen(6);
    [self addSubview:_alertView];
    _alertView.alpha = 0;
    
    _qrcodeView = [[UIImageView alloc]init];
    _qrcodeView.image = _qrcode;
    _qrcodeView.frame = CGRectMake(FitPTScreen(38), FitPTScreen(33), FitPTScreen(130), FitPTScreen(130));
    [_alertView addSubview:_qrcodeView];
    
    UILabel *tipLb = [[UILabel alloc]init];
    tipLb.textColor = UIColorFromRGB(0x999999);
    tipLb.font = [UIFont systemFontOfSize:FitPTScreen(12)];
    tipLb.numberOfLines = 2;
    tipLb.textAlignment = NSTextAlignmentCenter;
    tipLb.text = @"待骑手扫一扫\n快速取货";
    [_alertView addSubview:tipLb];
    [tipLb makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_qrcodeView.bottom).offset(FitPTScreen(18));
        make.centerX.equalTo(self.alertView);
    }];
    
    _closeBtn = [[UIButton alloc]init];
    [_closeBtn setImage:[UIImage imageNamed:@"close_x_circle_white"] forState:UIControlStateNormal];
    [self addSubview:_closeBtn];
    [_closeBtn makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self);
        make.top.equalTo(_alertView.bottom).offset(FitPTScreen(37));
    }];
    [_closeBtn addTarget:self action:@selector(closeClick) forControlEvents:UIControlEventTouchUpInside];
    _closeBtn.alpha = 0;
}

- (void)closeClick {
    [self hide];
}

- (void)show {
    _alertView.alpha = 1;
    _closeBtn.alpha = 1;
    [_alertView hl_addPopAnimation];
    [UIView animateWithDuration:0.25 animations:^{
        _coverView.backgroundColor = [UIColor colorWithWhite:0 alpha:0.6];
    } completion:nil];
}

- (void)hide {
    [UIView animateWithDuration:0.25 animations:^{
        _coverView.backgroundColor = [UIColor colorWithWhite:0 alpha:0];
        _alertView.alpha = 0;
        _closeBtn.alpha = 0;
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
}
@end
