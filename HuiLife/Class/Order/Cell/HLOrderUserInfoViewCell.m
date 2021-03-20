//
//  HLOrderUserInfoViewCell.m
//  iOS13test
//
//  Created by 雷清华 on 2019/10/29.
//  Copyright © 2019 雷清华. All rights reserved.
//

#import "HLOrderUserInfoViewCell.h"

@interface HLOrderUserInfoViewCell ()

@property(nonatomic, strong) UIImageView *vipImgV;

@property(nonatomic, strong) UILabel *phoneLb;

@property(nonatomic, strong) UIButton *phoneBtn;
//自提
@property(nonatomic, strong) UIButton *selfBtn;

@end

@implementation HLOrderUserInfoViewCell

- (void)initSubView {
    [super initSubView];
    self.showLine = YES;
    [self showArrow:false];
    
    _vipImgV = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"vip_huiCard"]];
    [self.bagView addSubview:_vipImgV];
    [_vipImgV makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(FitPTScreen(10));
        make.top.equalTo(FitPTScreen(20));
    }];
    
    _phoneLb = [UILabel hl_regularWithColor:@"#222222" font:14];
    _phoneLb.userInteractionEnabled = YES;
    [self.bagView addSubview:_phoneLb];
    [_phoneLb makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.vipImgV.right).offset(FitPTScreen(5));
        make.centerY.equalTo(self.vipImgV);
    }];
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(callClick)];
    [_phoneLb addGestureRecognizer:tap];
    
    _phoneBtn = [UIButton hl_regularWithTitle:@"" titleColor:@"" font:0 image:@"phone_green"];
    [self.bagView addSubview:_phoneBtn];
    [_phoneBtn makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(FitPTScreen(-12));
        make.centerY.equalTo(self.phoneLb);
        make.width.height.equalTo(FitPTScreen(30));
    }];
    [_phoneBtn addTarget:self action:@selector(callClick) forControlEvents:UIControlEventTouchUpInside];
    
//
    [self.bagView addSubview:_selfBtn];
    [_selfBtn makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(10);
        make.bottom.equalTo(FitPTScreen(-15));
    }];
    
}

- (void)setOrderModel:(HLBaseOrderModel *)orderModel {
    _orderModel = orderModel;
    _vipImgV.hidden = (_orderModel.isVip.integerValue == 0 || !orderModel.mobile.length);
    _phoneBtn.hidden = !_orderModel.mobile.length;
    _phoneLb.text = [HLTools getMiddleHideTextWithPhoneNum:orderModel.mobile];
    if (_orderModel.isVip.integerValue) {
        [_phoneLb remakeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.vipImgV.right).offset(FitPTScreen(5));
            make.centerY.equalTo(self.vipImgV);
        }];
    } else {
        [_phoneLb remakeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(FitPTScreen(9));
            make.top.equalTo(FitPTScreen(20));
        }];
    }
    
    if ([orderModel isKindOfClass:[HLScanOrderModel class]]) {
        HLScanOrderModel *model = (HLScanOrderModel *)orderModel;
        BOOL isSelf = (model.selfTime.length && model.is_send.integerValue == 3);
        _selfBtn.hidden = !isSelf;
        if (!_selfBtn.hidden) {
             _selfBtn = [UIButton hl_regularWithTitle:@"" titleColor:@"#868686" font:14 image:@"order_user_self"];
        }
        [_selfBtn setTitle:[NSString stringWithFormat:@" 自提时间：%@",model.selfTime] forState:UIControlStateNormal];
    }
}

- (void)callClick {
    if (self.orderModel.mobile.length) {
        [HLTools callPhone:self.orderModel.mobile];
    }
}

@end
