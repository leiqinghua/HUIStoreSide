//
//  HLStatuAlert.m
//  HuiLife
//
//  Created by 雷清华 on 2020/9/11.
//

#import "HLStatuAlert.h"

@interface HLStatuAlert ()
@property(nonatomic, strong) NSString *pic;
@property(nonatomic, strong) NSString *message;
@property(nonatomic, strong) UIView *bagView;
@property(nonatomic, strong) UIView *alertView;
@property(nonatomic, strong) UIImageView *picImV;
@property(nonatomic, strong) UILabel *mesgLb;
@property(nonatomic, copy) void(^optionCallBack)(void);
@end

@implementation HLStatuAlert

+ (void)showWithStatuPic:(NSString *)pic message:(NSString *)message callBack:(void(^)(void))callBack {
    HLStatuAlert *statuAlert = [[HLStatuAlert alloc]initWithFrame:UIScreen.mainScreen.bounds];
    statuAlert.pic = pic;
    statuAlert.message = message;
    statuAlert.optionCallBack = callBack;
    [KEY_WINDOW addSubview:statuAlert];
    [statuAlert showAlert];
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self initSubView];
    }
    return self;
}

- (void)initSubView {
    self.backgroundColor = UIColor.clearColor;
    _bagView = [[UIView alloc]initWithFrame:self.bounds];
    _bagView.backgroundColor = [UIColor colorWithWhite:0 alpha:0];
    [self addSubview:_bagView];
    
    _alertView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, FitPTScreen(250), FitPTScreen(172))];
    _alertView.center = self.center;
    _alertView.backgroundColor = UIColor.whiteColor;
    _alertView.layer.cornerRadius = FitPTScreen(6);
    [self addSubview:_alertView];
    
    _picImV = [[UIImageView alloc]init];
    [_alertView addSubview:_picImV];
    [_picImV makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(FitPTScreen(22));
        make.centerX.equalTo(self.alertView);
    }];
    
    _mesgLb = [UILabel hl_lableWithColor:@"#555555" font:14 bold:NO numbers:2];
    [self.alertView addSubview:_mesgLb];
    [_mesgLb makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.picImV.bottom).offset(FitPTScreen(15));
        make.centerX.equalTo(self.alertView);
        make.width.lessThanOrEqualTo(FitPTScreen(130));
    }];
    
    UIView *line = [[UIView alloc]init];
    line.backgroundColor = UIColorFromRGB(0xEDEDED);
    [self.alertView addSubview:line];
    [line makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(FitPTScreen(15));
        make.right.equalTo(FitPTScreen(-15));
        make.bottom.equalTo(FitPTScreen(-45));
        make.height.equalTo(0.5);
    }];
    
    UIButton *knowBtn = [UIButton hl_regularWithTitle:@"知道了" titleColor:@"#FF6316" font:14 image:@""];
    [self.alertView addSubview:knowBtn];
    [knowBtn makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(line.bottom);
        make.left.equalTo(FitPTScreen(5));
        make.right.bottom.equalTo(FitPTScreen(-5));
    }];
    [knowBtn addTarget:self action:@selector(knowClick) forControlEvents:UIControlEventTouchUpInside];
}

- (void)setPic:(NSString *)pic {
    _picImV.image = [UIImage imageNamed:pic];
}

- (void)setMessage:(NSString *)message {
    NSMutableParagraphStyle *style = [[NSMutableParagraphStyle alloc]init];
    style.lineSpacing = 3;
    NSAttributedString *mesgAtrr = [[NSAttributedString alloc]initWithString:message attributes:@{NSParagraphStyleAttributeName:style}];
    _mesgLb.attributedText = mesgAtrr;
}

- (void)showAlert {
    [UIView animateWithDuration:0.25 animations:^{
        self.bagView.backgroundColor = [UIColor colorWithWhite:0 alpha:0.5];
    }];
    [_alertView hl_addPopAnimation];
}

- (void)hide {
    [self removeFromSuperview];
}

- (void)knowClick {
    if (self.optionCallBack) {
        self.optionCallBack();
    }
    [self hide];
}


@end
