//
//  HLWithDrawalHead.m
//  HuiLife
//
//  Created by 王策 on 2019/9/10.
//

#import "HLWithDrawalHead.h"

@interface HLWithDrawalHead ()

@property (nonatomic, strong) UILabel *moneyShowLab;

@end

@implementation HLWithDrawalHead

- (instancetype)init {
    self = [super init];
    if (self) {
        [self creatSubViews];
    }
    return self;
}

- (void)creatSubViews {
    
    UIImageView *bgImgV = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"bag_head"]];
    [self addSubview:bgImgV];
    bgImgV.contentMode = UIViewContentModeScaleToFill;
    [bgImgV makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(UIEdgeInsetsZero);
    }];
    
    _moneyShowLab = [[UILabel alloc] init];
    [self addSubview:_moneyShowLab];
    [_moneyShowLab makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self);
        make.top.equalTo(Height_NavBar + FitPTScreen(25));
    }];
    
//    UILabel *tipLab = [[UILabel alloc] init];
//    [self addSubview:tipLab];
//    tipLab.text = @"(提现现金为实际到账的金额)";
//    tipLab.font = [UIFont systemFontOfSize:FitPTScreen(11)];
//    tipLab.textColor = UIColorFromRGB(0xFFFFFF);
//    [tipLab makeConstraints:^(MASConstraintMaker *make) {
//        make.centerX.equalTo(self);
//        make.top.equalTo(_moneyShowLab.bottom).offset(FitPTScreen(5));
//    }];
}

/// 配置可提现金额
- (void)configCanWithdrawMoney:(double)money{
//    NSString *moneyStr = [NSString hl_stringWithNoZeroMoney:money];
    NSString *moneyStr = [NSString stringWithFormat:@"%.2lf",money];
    NSString *moneyShowStr = [NSString stringWithFormat:@"可提现余额：%@元", moneyStr];
    NSMutableAttributedString *attr = [[NSMutableAttributedString alloc] initWithString:moneyShowStr attributes:@{NSFontAttributeName: [UIFont boldSystemFontOfSize:FitPTScreen(16)], NSForegroundColorAttributeName: UIColor.whiteColor}];
    [attr addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:FitPTScreen(30)] range:[moneyShowStr rangeOfString:moneyStr]];
    _moneyShowLab.attributedText = attr;
}

@end
