//
//  HLOrderPriceDescFooter.m
//  iOS13test
//
//  Created by 雷清华 on 2019/10/31.
//  Copyright © 2019 雷清华. All rights reserved.
//

#import "HLOrderPriceDescFooter.h"
#import "HLOrderPriceDescView.h"
#import "HLAlertView.h"

@interface HLOrderPriceDescFooter ()

@property(nonatomic, strong)UILabel *userLb;

@property(nonatomic, strong)UILabel *storeLb;

@property(nonatomic, strong)UILabel *userPriceLb;

@property(nonatomic, strong)UILabel *storePriceLb;

@property(nonatomic, strong)UIButton *userDesBtn;

@property(nonatomic, strong)UIButton *storeDesBtn;

@property(nonatomic, strong)UIView *openBtn;

@property(nonatomic, strong)UILabel *openLb;

@property(nonatomic, strong)UIImageView *openView;

@end

@implementation HLOrderPriceDescFooter

- (instancetype)initWithReuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithReuseIdentifier:reuseIdentifier]) {
        [self initSubView];
    }
    return self;
}

- (void)initSubView {
    
    self.contentView.backgroundColor = UIColor.whiteColor;
    
    _userLb = [UILabel hl_regularWithColor:@"#868686" font:14];
    _userLb.text = @"用户收到退款金额";
    [self.contentView addSubview:_userLb];
    
    _storeLb = [UILabel hl_regularWithColor:@"#868686" font:14];
    _storeLb.text = @"商家承担退款金额";
    [self.contentView addSubview:_storeLb];
    
    _userPriceLb = [UILabel hl_singleLineWithColor:@"#FF4040" font:20 bold:YES];;
    [self.contentView addSubview:_userPriceLb];
    
    _storePriceLb = [UILabel hl_singleLineWithColor:@"#FF4040" font:20 bold:YES];;
    [self.contentView addSubview:_storePriceLb];
    
//    _userDesBtn = [UIButton hl_regularWithTitle:@"" titleColor:@"" font:0 image:@"waring_grey_big"];
//    _userDesBtn.tag = 1000;
//    [self.contentView addSubview:_userDesBtn];
//
//    _storeDesBtn = [UIButton hl_regularWithTitle:@"" titleColor:@"" font:0 image:@"waring_grey_big"];
//    _storeDesBtn.tag = 1001;
//    [self.contentView addSubview:_storeDesBtn];
//
//    [_userDesBtn addTarget:self action:@selector(descBtnClick:) forControlEvents:UIControlEventTouchUpInside];
//    [_storeDesBtn addTarget:self action:@selector(descBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    
    [_userLb makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(FitPTScreen(12));
        make.top.equalTo(FitPTScreen(14));
    }];
    
    [_storeLb makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.userLb);
        make.top.equalTo(self.userLb.bottom).offset(FitPTScreen(15));
    }];
    
    [_userPriceLb makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.userLb.right).offset(FitPTScreen(8));
        make.centerY.equalTo(self.userLb);
    }];
    
    [_storePriceLb makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.storeLb.right).offset(FitPTScreen(8));
        make.centerY.equalTo(self.storeLb);
    }];
    
//    [_userDesBtn makeConstraints:^(MASConstraintMaker *make) {
//        make.right.equalTo(FitPTScreen(-135));
//        make.bottom.equalTo(self.userLb);
//    }];
//    
//    [_storeDesBtn makeConstraints:^(MASConstraintMaker *make) {
//        make.centerX.equalTo(self.userDesBtn);
//        make.bottom.equalTo(self.storeLb);
//    }];
    
    _openBtn = [[UIView alloc]init];
    _openBtn.layer.cornerRadius = FitPTScreen(11);
    _openBtn.layer.borderColor = UIColorFromRGB(0xCDCDCD).CGColor;
    _openBtn.layer.borderWidth = FitPTScreen(0.5);
    [self.contentView addSubview:_openBtn];
    [_openBtn makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(FitPTScreen(-11));
        make.centerY.equalTo(self.userLb);
        make.width.equalTo(FitPTScreen(54));
        make.height.equalTo(FitPTScreen(23));
    }];
    UITapGestureRecognizer *openTap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(openBtnClick:)];
    [_openBtn addGestureRecognizer:openTap];
    
    
    _openLb = [UILabel hl_regularWithColor:@"#666666" font:12];
    _openLb.text = @"展开";
    [_openBtn addSubview:_openLb];
    [_openLb makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(FitPTScreen(9));
        make.centerY.equalTo(self.openBtn);
    }];
    
    _openView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"arrow_down_grey_light"]];
    [_openBtn addSubview:_openView];
    [_openView makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(FitPTScreen(-6));
        make.centerY.equalTo(self.openBtn);
    }];

}

- (void)openBtnClick:(UITapGestureRecognizer *)sender {
    self.isOpen = !self.isOpen;
    if ([self.delegate respondsToSelector:@selector(hl_footerViewWithOpenClick:)]) {
        [self.delegate hl_footerViewWithOpenClick:self.isOpen];
    }
}


- (void)descBtnClick:(UIButton *)sender {
    NSString * title = @"";
    NSString * subTitle = @"";
    switch (sender.tag) {
        case 1000:
            title = @"退款金额说明";
            subTitle = @"用户收到退款金额=商品原价/订单原价x用户实付金额 \n 退款方式：原路退回";
            break;
        case 1001:
            title = @"退款金额说明";
            subTitle = @"商家承担退款金额=商品原价/订单原价x（订单折扣价-商家补贴）";
            break;
        default:
            break;
    }
    [HLAlertView alertWithTitle:title subTitltle:subTitle type:HLAlertViewDefaultType];
}

- (void)setIsOpen:(BOOL)isOpen {
    _isOpen = isOpen;
    _openLb.text = _isOpen?@"收起":@"展开";
    _openView.image = [UIImage imageNamed:_isOpen?@"arrow_up_grey":@"arrow_down_grey_light"];
}

- (void)configUserPrice:(NSString *)userMoney storePrice:(NSString *)storeMoney {
    _userPriceLb.attributedText = [self attrWithMoney:userMoney];
    _storePriceLb.attributedText = [self attrWithMoney:storeMoney];
}


- (NSAttributedString *)attrWithMoney:(NSString *)money {
    NSString *moneyText = money;
    if (![money containsString:@"¥"] && ![money containsString:@"￥"]) {
        moneyText = [NSString stringWithFormat:@"¥%@",money];
    }
    NSMutableAttributedString *mutarr = [[NSMutableAttributedString alloc]initWithString:moneyText];
    NSRange tipRange = NSMakeRange(0, 1);
    [mutarr addAttributes:@{NSFontAttributeName : [UIFont systemFontOfSize:FitPTScreen(14)]} range:tipRange];
    return mutarr;
}

@end
