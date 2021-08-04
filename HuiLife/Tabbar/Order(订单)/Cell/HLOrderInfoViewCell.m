//
//  HLOrderInfoViewCell.m
//  iOS13test
//
//  Created by 雷清华 on 2019/10/29.
//  Copyright © 2019 雷清华. All rights reserved.
//

#import "HLOrderInfoViewCell.h"

@interface HLOrderInfoViewCell ()

@property(nonatomic, strong) UILabel *orderNumLb;

@property(nonatomic, strong) UIImageView *orderTypeV;

@property(nonatomic, strong) UILabel *orderTypeLb;

@property(nonatomic, strong) UILabel *stateLb;

@end

@implementation HLOrderInfoViewCell

- (void)initSubView {
    [super initSubView];
    self.showLine = YES;
    [self showArrow:false];
    
    _orderNumLb = [UILabel hl_regularWithColor:@"#444444" font:14];
    [self.bagView addSubview:_orderNumLb];
    [_orderNumLb makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(FitPTScreen(10));
        make.centerY.equalTo(self.bagView);
    }];
    
    _orderTypeV = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"order_type_bg"]];
    [self.bagView addSubview:_orderTypeV];
    [_orderTypeV makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.orderNumLb.right).offset(FitPTScreen(8));
        make.centerY.equalTo(self.orderNumLb);
    }];
    
    _orderTypeLb = [UILabel hl_regularWithColor:@"#AE734A" font:11];
    [_orderTypeLb setAdjustsFontSizeToFitWidth:YES];
    _orderTypeLb.textAlignment = NSTextAlignmentCenter;
    [_orderTypeV addSubview:_orderTypeLb];
    [_orderTypeLb makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.centerY.equalTo(self.orderTypeV);
        make.left.equalTo(self.orderTypeV).offset(5);
        make.right.equalTo(self.orderTypeV).offset(-5);
    }];
    
    _stateLb = [UILabel hl_regularWithColor:@"#FF8604" font:13];
    [self.bagView addSubview:_stateLb];
    [_stateLb makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(FitPTScreen(-10));
        make.centerY.equalTo(self.bagView);
    }];
}

- (void)setOrderModel:(HLBaseOrderModel *)orderModel {
    _orderModel = orderModel;
    _orderNumLb.attributedText = [self attrWithOrder:orderModel.order_id];
    _orderTypeLb.text = orderModel.orderType;
    _stateLb.text = orderModel.state;
}

- (NSAttributedString *)attrWithOrder:(NSString *)orderNum {
    NSString *text = [NSString stringWithFormat:@"订单号：%@",orderNum];
    NSRange range = [text rangeOfString:@"订单号："];
    NSMutableAttributedString *mutrr = [[NSMutableAttributedString alloc]initWithString:text];
    [mutrr addAttributes:@{NSForegroundColorAttributeName:UIColorFromRGB(0x666666)} range:range];
    return mutrr;
}

@end
