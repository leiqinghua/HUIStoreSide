//
//  HLWXAuthoView.m
//  HuiLife
//
//  Created by 雷清华 on 2019/9/10.
//

#import "HLWXAuthoView.h"

@interface HLWXAuthoView ()

@property(nonatomic,strong)UIView * bagView;

@property(nonatomic,strong)UIView * alertView;

@property(nonatomic,copy)void(^completion)(NSInteger);

@property(nonatomic,strong)UIImageView * headView;

@property(nonatomic,assign)BOOL auth;

@property(nonatomic,copy)NSString * pic;
//未授权视图
@property(nonatomic,strong)UIView* unAuthView;
//授权视图
@property(nonatomic,strong)UIView* authView;

@end

@implementation HLWXAuthoView


+(void)showWXAuthWithAuthed:(BOOL)Auth headPic:(NSString *)pic Completion:(void(^)(NSInteger))completion{
    HLWXAuthoView * authorView = [[HLWXAuthoView alloc]initWithFrame:UIScreen.mainScreen.bounds authed:Auth headPic:pic];
    authorView.completion = completion;
    [KEY_WINDOW addSubview:authorView];
    [authorView showAnimate];
}


-(instancetype)initWithFrame:(CGRect)frame authed:(BOOL)Auth headPic:(NSString *)pic {
    if (self = [super initWithFrame:frame]) {
        _auth = Auth;
        _pic = pic;
        [self initView];
    }
    return self;
}


-(void)updateHeadePic:(NSNotification *)sender{
    
    _unAuthView.hidden = YES;
    [self initAuthView];
    _authView.hidden = false;
    
    NSString * pic = sender.object;
    [_headView sd_setImageWithURL:[NSURL URLWithString:pic] placeholderImage:[UIImage imageNamed:@""]];
}

-(void)initView{
    
    _bagView = [[UIView alloc]initWithFrame:self.bounds];
    _bagView.backgroundColor = [UIColor colorWithWhite:0 alpha:0.0];
    [self addSubview:_bagView];
   
    _alertView = [[UIView alloc]initWithFrame:CGRectMake(0, ScreenH, ScreenW, FitPTScreen(215) + Height_Bottom_Margn)];
    _alertView.backgroundColor = UIColor.whiteColor;
    UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:_alertView.bounds byRoundingCorners:UIRectCornerTopLeft | UIRectCornerTopRight cornerRadii:CGSizeMake(8,8)];
    CAShapeLayer *maskLayer = [[CAShapeLayer alloc] init];
    maskLayer.frame = _alertView.bounds;
    maskLayer.path = maskPath.CGPath;
    _alertView.layer.mask = maskLayer;
    _alertView.layer.masksToBounds = YES;
    [self addSubview:_alertView];
    
    [HLNotifyCenter addObserver:self selector:@selector(updateHeadePic:) name:HLUpdateWXHeadeNotifi object:nil];
    
//    判断是否微信授权
    
//    未授权
    if (!_auth) {
        
        _unAuthView = [[UIView alloc]initWithFrame:self.alertView.bounds];
        [_alertView addSubview:_unAuthView];
        
        UIImageView * wxLogo = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"wx"]];
        [_unAuthView addSubview:wxLogo];
        [wxLogo makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(self.unAuthView);
            make.top.equalTo(FitPTScreen(24));
        }];
        
        UILabel * tipLb = [[UILabel alloc]init];
        tipLb.text = @"未绑定微信";
        tipLb.textColor = UIColorFromRGB(0x888888);
        tipLb.font = [UIFont systemFontOfSize:FitPTScreen(13)];
        [_unAuthView addSubview:tipLb];
        [tipLb makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(wxLogo.bottom).offset(FitPTScreen(14));
            make.centerX.equalTo(wxLogo);
        }];
        
        
        UIButton *saveButton = [[UIButton alloc] init];
        saveButton.tag = 0;
        [_unAuthView addSubview:saveButton];
        [saveButton setTitle:@"立即绑定" forState:UIControlStateNormal];
        saveButton.titleLabel.font = [UIFont systemFontOfSize:FitPTScreen(15)];
        [saveButton setTitleColor:UIColor.whiteColor forState:UIControlStateNormal];
        [saveButton setBackgroundImage:[UIImage imageNamed:@"voucher_bottom_btn"] forState:UIControlStateNormal];
        [saveButton makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(self.unAuthView);
            make.bottom.equalTo(FitPTScreen(-11)-Height_Bottom_Margn);
            make.width.equalTo(FitPTScreen(307));
            make.height.equalTo(FitPTScreen(72));
        }];
        [saveButton addTarget:self action:@selector(saveClick:) forControlEvents:UIControlEventTouchUpInside];
        
        return;
    }
//    已授权
    [self initAuthView];
}



-(void)initAuthView{
    //授权
    
    if (_authView) return;
    
    _authView = [[UIView alloc]initWithFrame:self.alertView.bounds];
    [_alertView addSubview:_authView];
    
    _headView = [[UIImageView alloc]init];
    [_headView sd_setImageWithURL:[NSURL URLWithString:_pic] placeholderImage:[UIImage imageNamed:@""]];
    _headView.layer.cornerRadius = FitPTScreen(56)/2;
    [_authView addSubview:_headView];
    [_headView makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.authView);
        make.top.equalTo(FitPTScreen(21));
        make.width.height.equalTo(FitPTScreen(56));
    }];
    
    UILabel * botTipLb = [[UILabel alloc]init];
    botTipLb.text = @"即将提现至您的微信账号";
    botTipLb.textColor = UIColorFromRGB(0x888888);
    botTipLb.font = [UIFont systemFontOfSize:FitPTScreen(13)];
    [_authView addSubview:botTipLb];
    [botTipLb makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.headView.bottom).offset(FitPTScreen(16));
        make.centerX.equalTo(self.headView);
    }];
    
    
    UIButton *changeBtn = [[UIButton alloc] init];
    [_authView addSubview:changeBtn];
    changeBtn.tag = 1;
    [changeBtn setTitle:@"换个账号" forState:UIControlStateNormal];
    changeBtn.titleLabel.font = [UIFont systemFontOfSize:FitPTScreen(15)];
    [changeBtn setTitleColor:UIColorFromRGB(0xFF8517) forState:UIControlStateNormal];
    changeBtn.layer.cornerRadius = FitPTScreen(9);
    changeBtn.layer.borderColor =UIColorFromRGB(0xFF8517).CGColor;
    changeBtn.layer.borderWidth = FitPTScreen(0.8);
    [changeBtn makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(FitPTScreen(41));
        make.bottom.equalTo(FitPTScreen(-28)-Height_Bottom_Margn);
        make.width.equalTo(FitPTScreen(131));
        make.height.equalTo(FitPTScreen(42));
    }];
    
    UIButton *concernBtn = [[UIButton alloc] init];
    [_authView addSubview:concernBtn];
    concernBtn.tag = 2;
    [concernBtn setTitle:@"确定" forState:UIControlStateNormal];
    concernBtn.titleLabel.font = [UIFont systemFontOfSize:FitPTScreen(15)];
    [concernBtn setTitleColor:UIColor.whiteColor forState:UIControlStateNormal];
    [concernBtn setBackgroundImage:[UIImage imageNamed:@"bag_btn_min_oriange"] forState:UIControlStateNormal];
    concernBtn.layer.cornerRadius = FitPTScreen(9);
    [concernBtn makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(FitPTScreen(-41));
        make.bottom.equalTo(FitPTScreen(-28)-Height_Bottom_Margn);
        make.width.equalTo(FitPTScreen(131));
        make.height.equalTo(FitPTScreen(42));
    }];
    
    [changeBtn addTarget:self action:@selector(saveClick:) forControlEvents:UIControlEventTouchUpInside];
    [concernBtn addTarget:self action:@selector(saveClick:) forControlEvents:UIControlEventTouchUpInside];
}


-(void)saveClick:(UIButton *)sender{
//    if (sender.tag != 0) {
//         [self hideAnimate];
//    }
    [self hideAnimate];
    if (self.completion) {
        self.completion(sender.tag);
    }
}

-(void)showAnimate{
    [UIView animateWithDuration:0.3 animations:^{
        self.bagView.backgroundColor = [UIColor colorWithWhite:0 alpha:0.4];
        CGRect frame = self.alertView.frame;
        frame.origin.y = ScreenH - ( FitPTScreen(215) + Height_Bottom_Margn);
        self.alertView.frame = frame;
    }];
}

-(void)hideAnimate{
    [UIView animateWithDuration:0.3 animations:^{
        self.bagView.backgroundColor = [UIColor colorWithWhite:0 alpha:0];
        CGRect frame = self.alertView.frame;
        frame.origin.y = ScreenH;
        self.alertView.frame = frame;
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
}

-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self hideAnimate];
}
@end
