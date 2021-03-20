//
//  HLBuniessAlertView.m
//  HuiLife
//
//  Created by 闻喜惠生活 on 2018/11/21.
//

#import "HLBuniessAlertView.h"

#define AnimateTime 0.2

@interface HLBuniessAlertView()

@property (copy,nonatomic)CallBlock callBlock;

@property (strong,nonatomic)HLMineModel * model;

@property (strong,nonatomic)UIView * bagView;

@property(strong,nonatomic)UIView *alertView;

@property(strong,nonatomic)UILabel *nameLable;

@property(strong,nonatomic)UILabel *numLable;

@property(strong,nonatomic)UIButton *callBtn;

@end

@implementation HLBuniessAlertView

+ (void)showWithModel:(HLMineModel *)model call:(CallBlock)callblock{
    HLBuniessAlertView * alertView = [[HLBuniessAlertView alloc]initWithFrame:[UIScreen mainScreen].bounds model:model];
    alertView.callBlock = callblock;
    [KEY_WINDOW addSubview:alertView];
    [alertView alertAnimate];
}

-(instancetype)initWithFrame:(CGRect)frame model:(HLMineModel *)model{
    if (self = [super initWithFrame:frame]) {
        _model = model;
        [self initSubViews];
    }
    return self;
}

- (void)initSubViews{
    _bagView = [[UIView alloc]initWithFrame:self.bounds];
    _bagView.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.5];
    [self addSubview:_bagView];
    
    _alertView = [[UIView alloc]initWithFrame:CGRectMake(0, self.bounds.size.height, ScreenW, FitPTScreen(181))];
    _alertView.backgroundColor = UIColor.whiteColor;
    [self addSubview:_alertView];
    
    UILabel * title = [[UILabel alloc]init];
    title.textColor = UIColorFromRGB(0x282828);
    title.text = @"专属商务员";
    title.font = [UIFont systemFontOfSize:FitPTScreen(17)];
    [_alertView addSubview:title];
    [title makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.alertView);
        make.top.equalTo(FitPTScreen(25));
    }];
//
    UIButton * cancel = [[UIButton alloc]init];
    [cancel setImage:[UIImage imageNamed:@"colse_x_light_grey"] forState:UIControlStateNormal];
    [_alertView addSubview:cancel];
    [cancel makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(title);
        make.right.equalTo(FitPTScreen(-20));
        make.width.height.equalTo(FitPTScreen(40));
    }];
     [cancel addTarget:self action:@selector(cancelClick) forControlEvents:UIControlEventTouchUpInside];
    
    
    UIView * line = [[UIView alloc]init];
    line.backgroundColor = UIColorFromRGB(0xDDDDDD);
    [_alertView addSubview:line];
    [line makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(FitPTScreen(20));
        make.right.equalTo(FitPTScreen(-20));
        make.top.equalTo(FitPTScreen(68));
        make.height.equalTo(FitPTScreen(1));
    }];
    
    _nameLable = [[UILabel alloc]init];
    _nameLable.font = [UIFont systemFontOfSize:FitPTScreen(14)];
    _nameLable.textColor = UIColorFromRGB(0x656565);
    _nameLable.text = _model.name;
    [_alertView addSubview:_nameLable];
    [_nameLable makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(FitPTScreen(30));
        make.top.equalTo(line.mas_bottom).offset(FitPTScreen(25));
    }];
    
    _numLable = [[UILabel alloc]init];
    _numLable.font = [UIFont systemFontOfSize:FitPTScreen(14)];
    _numLable.textColor = UIColorFromRGB(0x282828);
    _numLable.text = _model.phoneNum;
    [_alertView addSubview:_numLable];
    [_numLable makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(FitPTScreen(-30));
        make.centerY.equalTo(self.nameLable);
    }];
    
    _callBtn = [[UIButton alloc]init];
    _callBtn.backgroundColor = UIColorFromRGB(0xFF8D26);
    [_callBtn setTitle:@"电话咨询" forState:UIControlStateNormal];
    [_callBtn setTitleColor:UIColor.whiteColor forState:UIControlStateNormal];
    [_alertView addSubview:_callBtn];
    [_callBtn makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(self.alertView);
        make.height.equalTo(FitPTScreen(49));
    }];
    [_callBtn addTarget:self action:@selector(callClick:) forControlEvents:UIControlEventTouchUpInside];
}

-(void)alertAnimate{
    [UIView animateWithDuration:AnimateTime animations:^{
        CGRect frame = self.alertView.frame;
        frame.origin.y = self.bounds.size.height - frame.size.height;
        self.alertView.frame = frame;
    } completion:^(BOOL finished) {
        
    }];
}


-(void)callClick:(UIButton *)sender{
    [self cancelClick];
    [HLTools callPhone:_model.phoneNum];
    if (self.callBlock) {
        self.callBlock();
    }
}

- (void)cancelClick{
    [UIView animateWithDuration:AnimateTime animations:^{
        CGRect frame = self.alertView.frame;
        frame.origin.y = self.bounds.size.height;
        self.alertView.frame = frame;
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
}

-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self cancelClick];
}
@end
