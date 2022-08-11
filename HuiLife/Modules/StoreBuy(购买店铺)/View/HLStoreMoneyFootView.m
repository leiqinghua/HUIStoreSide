//
//  HLStoreMoneyFootView.m
//  HuiLife
//
//  Created by 王策 on 2019/8/30.
//

#import "HLStoreMoneyFootView.h"

@interface HLStoreMoneyFootView ()

@property (nonatomic, strong) UILabel *moneyLab;
@property (nonatomic, strong) UILabel *shengLab;
@property (nonatomic, strong) UIButton *buyBtn;

@end

@implementation HLStoreMoneyFootView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self creatSubUI];
    }
    return self;
}

- (void)creatSubUI{
    
    _moneyLab = [[UILabel alloc] init];
    [self addSubview:_moneyLab];
    _moneyLab.font = [UIFont boldSystemFontOfSize:FitPTScreen(13)];
    _moneyLab.textColor = UIColorFromRGB(0xFF3939);
    [_moneyLab makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(FitPTScreen(8));
        make.left.equalTo(FitPTScreen(13));
    }];
    
    _shengLab = [[UILabel alloc] init];
    [self addSubview:_shengLab];
    _shengLab.font = [UIFont systemFontOfSize:FitPTScreen(11)];
    _shengLab.textColor = UIColorFromRGB(0xA9A9A9);
    [_shengLab makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_moneyLab.bottom).offset(FitPTScreen(2));
        make.left.equalTo(FitPTScreen(15));
    }];
    
    _buyBtn = [[UIButton alloc] init];
    [self addSubview:_buyBtn];
    [_buyBtn setBackgroundImage:[UIImage imageNamed:@"buy_store_btn"] forState:UIControlStateNormal];
    _buyBtn.titleLabel.font = [UIFont systemFontOfSize:FitPTScreen(14)];
    [_buyBtn setTitleColor:UIColor.whiteColor forState:UIControlStateNormal];
    [_buyBtn setTitle:@"立即购买" forState:UIControlStateNormal];
    [_buyBtn makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(FitPTScreen(-13));
        make.width.equalTo(FitPTScreen(115));
        make.height.equalTo(FitPTScreen(37));
        make.top.equalTo(FitPTScreen(11));
    }];
    [_buyBtn addTarget:self action:@selector(buyBtnClick) forControlEvents:UIControlEventTouchUpInside];
    
}

- (void)buyBtnClick{
//    HLShowText(@"您暂无购买权限，请重试");
    if (self.delegate) {
        [self.delegate clickBuyButtonWithFootView:self];
    }
}

- (void)configSaleMoney:(double)saleMoney shengMoney:(NSString *)shengMoney{
    _moneyLab.attributedText = [self formatMoneyWithMoney:saleMoney fontSize:FitPTScreen(23) isBold:YES];
    _shengLab.text = shengMoney;
}

- (NSMutableAttributedString *)formatMoneyWithMoney:(double)money fontSize:(NSInteger)fontSize isBold:(BOOL)isBold{
    UIFont *font = isBold ? [UIFont boldSystemFontOfSize:fontSize] : [UIFont systemFontOfSize:fontSize];
    NSString *allStr = [NSString stringWithFormat:@"￥%.2lf",money];
    NSRange dotRange = [allStr rangeOfString:@"."];
    NSMutableAttributedString *moneyAttr = [[NSMutableAttributedString alloc] initWithString:allStr];
    [moneyAttr addAttribute:NSFontAttributeName value:font range:NSMakeRange(1, dotRange.location - 1)];
    return moneyAttr;
}

@end
