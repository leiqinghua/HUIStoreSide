//
//  HLConfirmTIXianView.m
//  HuiLife
//
//  Created by 雷清华 on 2018/7/18.
//

#import "HLConfirmTIXianView.h"

@interface HLConfirmTIXianView()
@property(strong,nonatomic)UIView *blackView;
@property(strong,nonatomic)UILabel *jinE;
@property(strong,nonatomic)UIView *bagView;
@end

@implementation HLConfirmTIXianView

- (instancetype)init
{
    self = [super init];
    if (self) {
        [self createUI];
    }
    return self;
}

-(void)createUI{
    _blackView = [[UIView alloc]init];
    _blackView.backgroundColor = [UIColor blackColor];
    _blackView.alpha = 0.5;
    [self addSubview:_blackView];
    [_blackView makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self);
    }];
    _blackView.userInteractionEnabled = YES;
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tap:)];
    [_blackView addGestureRecognizer:tap];
    
    _bagView = [[UIView alloc]init];
    _bagView.backgroundColor = [UIColor whiteColor];
    [self addSubview:_bagView];
    [_bagView makeConstraints:^(MASConstraintMaker *make) {
        make.left.bottom.width.equalTo(self);
        make.height.equalTo(FitPTScreen(248));
    }];

    UILabel * tixian = [[UILabel alloc]init];
    tixian.textAlignment = NSTextAlignmentCenter;
    tixian.font = [UIFont systemFontOfSize:FitPTScreen(15)];
    tixian.text = @"提现金额";
    tixian.textColor = UIColorFromRGB(0x656565);
    [_bagView addSubview:tixian];
    [tixian mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.bagView).offset(FitPTScreen(30));
        make.top.equalTo(self.bagView.mas_top).offset(FitPTScreen(25));
    }];
//
    _jinE = [[UILabel alloc]init];
    _jinE.textAlignment = NSTextAlignmentLeft;
    _jinE.font = [UIFont systemFontOfSize:FitPTScreen(15)];
    _jinE.text = @"￥119.35";
    _jinE.textColor = UIColorFromRGB(0x656565);
    [_bagView addSubview:_jinE];
    [_jinE mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(tixian);
        make.top.equalTo(tixian.mas_bottom).offset(FitPTScreen(20));
    }];

    UILabel * warnLable = [[UILabel alloc]init];
    warnLable.textAlignment = NSTextAlignmentCenter;
    warnLable.font = [UIFont systemFontOfSize:FitPTScreen(12)];
    warnLable.text = @"单笔提现最高金额2万";
    warnLable.textColor = UIColorFromRGB(0x989898);
    [_bagView addSubview:warnLable];
    [warnLable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.bagView).offset(FitPTScreen(-30));
        make.bottom.equalTo(self.jinE);
    }];
//
    UIView *line = [[UIView alloc]init];
    line.backgroundColor = UIColorFromRGB(0xDDDDDD);
    [_bagView addSubview:line];
    [line makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).offset(FitPTScreen(20));
        make.top.equalTo(self.jinE.mas_bottom).offset(FitPTScreen(25));
        make.width.equalTo(FitPTScreen(335));
        make.height.equalTo(FitPTScreen(1));
    }];
//
    UILabel * fangshi = [[UILabel alloc]init];
    fangshi.textAlignment = NSTextAlignmentCenter;
    fangshi.font = [UIFont systemFontOfSize:FitPTScreen(15)];
    fangshi.text = @"提现方式";
    fangshi.textColor = UIColorFromRGB(0x656565);
    [_bagView addSubview:fangshi];
    [fangshi mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.bagView).offset(FitPTScreen(30));
        make.top.equalTo(line).offset(FitPTScreen(25));
    }];
//
    UIImageView * weixin = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"weixin_logo"]];
    [_bagView addSubview:weixin];
    [weixin makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(fangshi);
        make.top.equalTo(fangshi.mas_bottom).offset(FitPTScreen(20));
    }];
//
    UILabel * expression = [[UILabel alloc]init];
    expression.textAlignment = NSTextAlignmentCenter;
    expression.font = [UIFont systemFontOfSize:FitPTScreen(14)];
    expression.text = @"微信支付";
    expression.textColor = UIColorFromRGB(0x282828);
    [_bagView addSubview:expression];
    [expression mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weixin.mas_right).offset(FitPTScreen(10));
        make.centerY.equalTo(weixin);
    }];
//    //pay_way_select
    UIImageView * payway = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"success_oriange"]];
    [_bagView addSubview:payway];
    [payway makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.bagView).offset(FitPTScreen(-30));
        make.centerY.equalTo(weixin);
    }];

    UIButton * concern = [[UIButton alloc]init];
    [concern setTitle:@"确认" forState:UIControlStateNormal];
    [concern setTitleColor:UIColorFromRGB(0xFFFFFF) forState:UIControlStateNormal];
    concern.backgroundColor =UIColorFromRGB(0xFF8D26);
    concern.titleLabel.font=[UIFont systemFontOfSize:FitPTScreen(15)];
    [_bagView addSubview:concern];
    [concern addTarget:self action:@selector(liJiTixian:) forControlEvents:UIControlEventTouchUpInside];
    [concern mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.bottom.width.equalTo(self.bagView);
        make.height.equalTo(FitPTScreen(44));
    }];
}

-(void)liJiTixian:(UIButton *)sender{
    if (self.delegate) {
        [self.delegate concernTiXian:sender];
    }
}

-(void)setMoney:(NSString *)money{
    _money = money;
    _jinE.text = [NSString stringWithFormat:@"¥%@",_money];
}

-(void)tap:(UITapGestureRecognizer *)sender{
     [self removeFromSuperview];
}

-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
   
}
-(void)dealloc{
    NSLog(@"%s",__func__);
}
@end
