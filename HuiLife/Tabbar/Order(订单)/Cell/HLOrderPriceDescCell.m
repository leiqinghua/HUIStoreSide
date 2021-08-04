//
//  HLOrderPriceDescCell.m
//  iOS13test
//
//  Created by 雷清华 on 2019/10/30.
//  Copyright © 2019 雷清华. All rights reserved.
//

#import "HLOrderPriceDescCell.h"
#import "HLOrderPriceDescView.h"
#import "HLAlertView.h"

@interface HLOrderPriceDescCell ()

@property(nonatomic, strong)UILabel *userLb;

@property(nonatomic, strong)UILabel *storeLb;

@property(nonatomic, strong)UILabel *userPriceLb;

@property(nonatomic, strong)UILabel *storePriceLb;

@property(nonatomic, strong)UIButton *userDesBtn;

@property(nonatomic, strong)UIButton *storeDesBtn;

@end

@implementation HLOrderPriceDescCell

- (void)initSubView {
    [super initSubView];
    [self showArrow:false];
        
    _userLb = [UILabel hl_regularWithColor:@"#868686" font:14];
    _userLb.text = @"用户收到退款金额";
    [self.bagView addSubview:_userLb];
    
    _storeLb = [UILabel hl_regularWithColor:@"#868686" font:14];
    _storeLb.text = @"商家承担退款金额";
    [self.bagView addSubview:_storeLb];
    
    _userPriceLb = [UILabel hl_singleLineWithColor:@"#FF4040" font:20 bold:YES];
    [self.bagView addSubview:_userPriceLb];
    
    _storePriceLb = [UILabel hl_singleLineWithColor:@"#FF4040" font:20 bold:YES];
    [self.bagView addSubview:_storePriceLb];
    
    _userDesBtn = [UIButton hl_regularWithTitle:@"" titleColor:@"" font:0 image:@"waring_grey_big"];
    _userDesBtn.tag = 1000;
    [self.bagView addSubview:_userDesBtn];
    
    _storeDesBtn = [UIButton hl_regularWithTitle:@"" titleColor:@"" font:0 image:@"waring_grey_big"];
    _storeDesBtn.tag = 1001;
    [self.bagView addSubview:_storeDesBtn];
    
    [_userDesBtn addTarget:self action:@selector(descBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [_storeDesBtn addTarget:self action:@selector(descBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    
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
    
    [_userDesBtn makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(FitPTScreen(-135));
        make.bottom.equalTo(self.userLb);
    }];
    
    [_storeDesBtn makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.userDesBtn);
        make.bottom.equalTo(self.storeLb);
    }];
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



- (void)configUserPrice:(NSString *)userMoney store:(NSString *)storeMoney {
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
