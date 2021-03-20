//
//  HLBillHeaderView.m
//  HuiLife
//
//  Created by 闻喜惠生活 on 2018/12/27.
//

#import "HLBillHeaderView.h"

@interface HLBillHeaderView()
//0 待入账 1，已入账
@property(assign,nonatomic)NSInteger type;

@property(strong,nonatomic)UILabel* state;

@property(strong,nonatomic)UILabel* money;

@property(strong,nonatomic)UILabel* detail;

@property(strong,nonatomic)UILabel* statu;

@property(strong,nonatomic)UILabel* express;

@property(strong,nonatomic)UIView* bagView;

@end

@implementation HLBillHeaderView

-(instancetype)initWithFrame:(CGRect)frame type:(NSInteger)type{
    if (self = [super initWithFrame:frame]) {
        _type = type;
        [self initSubView];
    }
    return self;
}

-(void)initSubView{
    
    self.backgroundColor = UIColor.clearColor;
    
    _bagView = [[UIView alloc]init];
    _bagView.backgroundColor = UIColor.whiteColor;
    _bagView.layer.cornerRadius = FitPTScreen(8);
    [self addSubview:_bagView];
    [_bagView makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self).insets(UIEdgeInsetsMake(FitPTScreen(15), FitPTScreen(13), FitPTScreen(11), FitPTScreen(13)));
    }];
    
    _state = [[UILabel alloc]init];
    _state.text = @"今日";
    _state.font = [UIFont systemFontOfSize:FitPTScreen(15)];
    _state.textColor = UIColorFromRGB(0x333333);
    [_bagView addSubview:_state];
    [_state mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(FitPTScreen(10));
        make.top.equalTo(FitPTScreen(15));
    }];
    
    _money = [[UILabel alloc]init];
    _money.text = @"+7,318.11";
    _money.font = [UIFont systemFontOfSize:FitPTScreen(16)];
    _money.textColor = UIColorFromRGB(0x222222);
    [_bagView addSubview:_money];
    [_money mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(FitPTScreen(-11));
        make.centerY.equalTo(self.state);
    }];
    
    _detail = [[UILabel alloc]init];
    _detail.text = @"收入￥9,830.22  | 支出￥2,512.14";
    _detail.font = [UIFont systemFontOfSize:FitPTScreen(13)];
    _detail.textColor = UIColorFromRGB(0x666666);
    [_bagView addSubview:_detail];
    [_detail mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.state);
        make.top.equalTo(self.state.bottom).offset(FitPTScreen(19));
    }];
    
    _statu = [[UILabel alloc]init];
    _statu.text = _type == 0?@"待结算":@"已结算";
    _statu.font = [UIFont systemFontOfSize:FitPTScreen(14)];
    _statu.textColor = UIColorFromRGB(0xFF8E16);
    [_bagView addSubview:_statu];
    [_statu mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.money);
        make.centerY.equalTo(self.detail);
    }];
    
    if (self.type == 1) {
        return;
    }
    
    UIButton * tip = [[UIButton alloc]init];
    [tip setImage:[UIImage imageNamed:@"waring_oriange"] forState:UIControlStateNormal];
    [_bagView addSubview:tip];
    [tip makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.state);
        make.top.equalTo(self.detail.mas_bottom).offset(FitPTScreen(12));
    }];
    
    _express = [[UILabel alloc]init];
    _express.font = [UIFont systemFontOfSize:FitPTScreen(13)];
    _express.textColor = UIColorFromRGB(0x555555);
    _express.text = @"账单日期+1天转入结算";
    [_bagView addSubview:_express];
    [_express mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(tip.right).offset(FitPTScreen(10));
        make.centerY.equalTo(tip);
    }];
}

-(void)setDate:(NSString *)date{
    _state.text = date;
}

-(void)setInfo:(NSDictionary *)info{
    _info = info;
    _money.text = info[@"keti"];
    NSMutableString * detail = [NSMutableString string];
    if ([info[@"shouru"] hl_isAvailable]) {
        [detail appendFormat:@"收入￥%@",info[@"shouru"]];
    }
    if ([info[@"zhichu"] hl_isAvailable]) {
        [detail appendFormat:@"  支出￥%@",info[@"zhichu"]];
    }
    _detail.text = detail;
    _statu.text = info[@"name"];
    
}
@end
