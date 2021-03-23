//
//  HLBuyCardBottomBuyView.m
//  HuiLife
//
//  Created by 王策 on 2021/3/20.
//

#import "HLBuyCardBottomBuyView.h"

@interface HLBuyCardBottomBuyView ()

@property (nonatomic, strong) UIView *contentV;
@property (nonatomic, strong) UILabel *tipLab;
@property (nonatomic, strong) UILabel *moneyLab;
@property (nonatomic, strong) UIButton *buyBtn;

@end

@implementation HLBuyCardBottomBuyView

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.backgroundColor = UIColor.whiteColor;
        [self creatSubViews];
    }
    return self;
}

- (void)creatSubViews{
    
    self.contentV = [[UIView alloc] init];
    [self addSubview:self.contentV];
    [self.contentV makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.equalTo(0);
        make.height.equalTo(FitPTScreen(55));
    }];
    
    self.tipLab = [[UILabel alloc] init];
    [self.contentV addSubview:self.tipLab];
    self.tipLab.text = @"费用";
    self.tipLab.font = [UIFont systemFontOfSize:FitPTScreen(12)];
    self.tipLab.textColor = [UIColor hl_StringToColor:@"#555555"];
    [self.tipLab makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(FitPTScreen(12));
        make.centerY.equalTo(self.contentV);
    }];
    
    UILabel *symbolLab = [[UILabel alloc] init];
    [self.contentV addSubview:symbolLab];
    symbolLab.text = @"¥";
    symbolLab.font = [UIFont systemFontOfSize:FitPTScreen(14)];
    symbolLab.textColor = [UIColor hl_StringToColor:@"#FF9900"];
    [symbolLab makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.tipLab.right).offset(FitPTScreen(4));
        make.centerY.equalTo(self.tipLab);
    }];
    
    self.moneyLab = [[UILabel alloc] init];
    [self.contentV addSubview:self.moneyLab];
    self.moneyLab.font = [UIFont boldSystemFontOfSize:FitPTScreen(19)];
    self.moneyLab.textColor = [UIColor hl_StringToColor:@"#FF9900"];
    [self.moneyLab makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(symbolLab.right).offset(FitPTScreen(1));
        make.bottom.equalTo(self.tipLab.bottom).offset(FitPTScreen(3));
    }];
    
    UILabel *unitLab = [[UILabel alloc] init];
    [self.contentV addSubview:unitLab];
    unitLab.text = @"元";
    unitLab.font = [UIFont systemFontOfSize:FitPTScreen(12)];
    unitLab.textColor = [UIColor hl_StringToColor:@"#FF9900"];
    [unitLab makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.moneyLab.right).offset(FitPTScreen(1));
        make.centerY.equalTo(symbolLab);
    }];
    
    // 默认0元
    [self configMoney:0];
    
    self.buyBtn = [[UIButton alloc] init];
    [self.contentV addSubview:self.buyBtn];
    self.buyBtn.layer.cornerRadius = FitPTScreen(10);
    self.buyBtn.layer.masksToBounds = YES;
    [self.buyBtn setTitle:@"立即购卡" forState:UIControlStateNormal];
    self.buyBtn.titleLabel.font = [UIFont systemFontOfSize:FitPTScreen(14)];
    [self.buyBtn setTitleColor:UIColor.whiteColor forState:UIControlStateNormal];
    [self.buyBtn setBackgroundImage:[UIImage imageNamed:@"buy_card_btn"] forState:UIControlStateNormal];
    [self.buyBtn makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.contentV);
        make.right.equalTo(FitPTScreen(-12));
        make.width.equalTo(FitPTScreen(160));
        make.height.equalTo(FitPTScreen(42));
    }];
    [self.buyBtn addTarget:self action:@selector(buyBtnClick) forControlEvents:UIControlEventTouchUpInside];
}

- (void)buyBtnClick{
    if (self.delegate) {
        [self.delegate buyButtonClickWithBuyView:self];
    }
}

- (void)configMoney:(double)money{
    
    // 判断是否为整数
    if (money == (NSInteger)money) {
        self.moneyLab.text = [NSString stringWithFormat:@"%.0lf",money];
    }else{
        self.moneyLab.text = [NSString stringWithFormat:@"%.2lf",money];
    }
}

@end
