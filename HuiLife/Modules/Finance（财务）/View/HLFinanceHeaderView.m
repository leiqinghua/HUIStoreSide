//
//  HLFinanceHeaderView.m
//  HuiLife
//
//  Created by 闻喜惠生活 on 2018/12/26.
//

#import "HLFinanceHeaderView.h"
#import "HLShowCalenderView.h"

#import "NSDate+HLCalendar.h"

@interface HLFinanceHeaderView()<HLFinanceButtonDelegate>

@property(strong,nonatomic)UIView * calenderView;

@property(strong,nonatomic)UILabel *balance;

@property (strong,nonatomic)NSArray * titles;

@property(strong,nonatomic)NSMutableArray<HLFinanceButton *> * buttons;

@end

@implementation HLFinanceHeaderView

-(void)changeFrameWithUp:(BOOL)up superView:(UIView*)view{
    _isUp = up;
    [_calenderView removeFromSuperview];
    if (up) {
        [view addSubview:_calenderView];
        [_calenderView makeConstraints:^(MASConstraintMaker *make) {
            make.left.width.equalTo(view);
            make.top.equalTo(Height_NavBar);
            make.height.equalTo(FitPTScreenH(40));
        }];
        return;
    }
    [self addSubview:_calenderView];
    [_calenderView makeConstraints:^(MASConstraintMaker *make) {
        make.left.width.equalTo(self);
        make.bottom.equalTo(self);
        make.height.equalTo(FitPTScreenH(40));
    }];
}

-(instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        [self initSubView];
    }
    return self;
}

-(void)initSubView{
    self.backgroundColor = UIColor.whiteColor;
    UIImageView * imageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, ScreenW, FitPTScreenH(250))];
    imageView.image = [UIImage imageNamed:@"bag_tx_header"];
    [self addSubview:imageView];
    
    UILabel * tipLable = [[UILabel alloc]init];
    tipLable.textAlignment = NSTextAlignmentCenter;
    tipLable.font = [UIFont systemFontOfSize:FitPTScreenH(13)];
    tipLable.text = @"要提现金额 （元）";
    tipLable.textColor = UIColorFromRGB(0xFFFFFF);
    [self addSubview:tipLable];
    [tipLable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self);
        make.top.equalTo(FitPTScreenH(88));
    }];
    
    _balance = [[UILabel alloc]init];
    _balance.textAlignment = NSTextAlignmentCenter;
    _balance.font = [UIFont systemFontOfSize:FitPTScreenH(30)];
    _balance.text = @"0.0";
    _balance.textColor = UIColorFromRGB(0xFFFFFF);
    [self addSubview:_balance];
    [_balance mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self);
        make.top.equalTo(tipLable.mas_bottom).offset(FitPTScreenH(14));
    }];
    
    UIButton * withdraw = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, FitPTScreen(17), FitPTScreenH(19))];
    withdraw.backgroundColor = [UIColor whiteColor];
    withdraw.layer.cornerRadius = FitPTScreenH(16);
    [withdraw setTitle:@"我要提现" forState:UIControlStateNormal];
    [withdraw setTitleColor:UIColorFromRGB(0xFF7D5E) forState:UIControlStateNormal];
    withdraw.titleLabel.font=[UIFont systemFontOfSize:FitPTScreenH(12)];
    [self addSubview:withdraw];
    [withdraw addTarget:self action:@selector(liJiTixian:) forControlEvents:UIControlEventTouchUpInside];
    [withdraw mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self);
        make.top.equalTo(self.balance.mas_bottom).offset(FitPTScreenH(23));
        make.width.equalTo(FitPTScreen(107));
        make.height.equalTo(FitPTScreenH(34));
    }];
    
    CGFloat width = self.bounds.size.width / 3;
    CGFloat hight = FitPTScreenH(80);
    
    for (int i= 0; i<self.titles.count; i++) {
        HLFinanceButton * button = [[HLFinanceButton alloc]initWithTitle:self.titles[i] type:i==0? HLFinanceButtonFirstType:HLFinanceButtonNormalType];
        button.tag = i;
        button.delegate = self;
        [self addSubview:button];
        [self.buttons addObject:button];
        [button makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(i*width);
            make.top.equalTo(imageView.mas_bottom);
            make.width.equalTo(width);
            make.height.equalTo(hight);
        }];
    }
    
    _calenderView = [[UIView alloc]init];
    _calenderView.backgroundColor = [UIColor hl_StringToColor:@"#F8F8F8"];
    [self addSubview:_calenderView];
    [_calenderView makeConstraints:^(MASConstraintMaker *make) {
        make.left.width.equalTo(self);
        make.bottom.equalTo(self);
        make.height.equalTo(FitPTScreenH(40));
    }];

    UIView * tip = [[UIView alloc]init];
    tip.backgroundColor =[UIColor hl_StringToColor:@"#FF8D26"];
    tip.layer.cornerRadius = FitPTScreenH(1);
    [_calenderView addSubview:tip];
    [tip makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(FitPTScreen(20));
        make.centerY.equalTo(self.calenderView);
        make.width.equalTo(FitPTScreen(5));
        make.height.equalTo(FitPTScreenH(15));
    }];

    UILabel * tipLable2 = [[UILabel alloc]init];
    tipLable2.font = [UIFont systemFontOfSize:FitPTScreenH(15)];
    tipLable2.text = @"日流水";
    tipLable2.textColor = UIColorFromRGB(0x989898);
    [self.calenderView addSubview:tipLable2];
    [tipLable2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.calenderView);
        make.left.equalTo(FitPTScreen(38));
    }];

    UIButton * calender = [[UIButton alloc]init];
    [calender setImage:[UIImage imageNamed:@"calender_grey"] forState:UIControlStateNormal];
    [self.calenderView addSubview:calender];
    [calender makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(FitPTScreen(-20));
        make.centerY.equalTo(self.calenderView);
        make.width.height.equalTo(FitPTScreenH(20));
    }];
    [calender addTarget:self action:@selector(calenderClick:) forControlEvents:UIControlEventTouchUpInside];
    
}

- (void)liJiTixian:(UIButton *)sender{
    if ([_balance.text floatValue]<1.0) {
        [HLTools showWithText:@"无可提现金额,最少提现一元"];
        return;
    }
    if ([self.delegate respondsToSelector:@selector(hlFinanceWithMoney:)]) {
        [self.delegate hlFinanceWithMoney:_balance.text];
    }
}

- (void)calenderClick:(UIButton *)sender{
    [HLShowCalenderView calenderViewWithFrame:CGRectMake(0, 0, ScreenW, ScreenH) callBack:^(NSString *year, NSString *month, NSString *day) {
        [HLShowCalenderView remove];
        NSString * date = [NSString stringWithFormat:@"%@-%@-%@",year,month,day];
        NSDate * curDate = [NSDate date];
        if (year.integerValue == [curDate dateYear] && month.integerValue == [curDate dateMonth] && day.integerValue == [curDate dateDay]) {
            date = @"今天";
        }
        
        if ([self.delegate respondsToSelector:@selector(selectDateWithDate:)]) {
            [self.delegate selectDateWithDate:date];
        }
    } touch:nil];
    
    [HLNotifyCenter postNotificationName:HLStatuBarHidenNotifi object:@YES];
}

#pragma mark- HLFinanceButtonDelegate
-(void)clickFinanceButton:(HLFinanceButton *)sender{
    if ([self.delegate respondsToSelector:@selector(clickFinanceButton:)]) {
        [self.delegate clickFinanceButton:sender];
    }
}

-(NSArray *)titles{
    if (!_titles) {
        _titles = @[@"总资产",@"已结算",@"待结算"];
    }
    return _titles;
}

-(NSMutableArray<HLFinanceButton *> *)buttons{
    if (!_buttons) {
        _buttons = [NSMutableArray array];
    }
    return _buttons;
}

-(void)setInfo:(NSDictionary *)info{
    _info = info;
    _balance.text = [info[@"ktx_money"] hl_isAvailable]?info[@"ktx_money"]:@"";
    NSArray * values = @[info[@"totle_money"],info[@"yrz_money"],info[@"drz_money"]];
    for (int i =0 ; i<self.buttons.count; i++) {
        HLFinanceButton * button = self.buttons[i];
        button.value.text = values[i];
    }
}


@end
