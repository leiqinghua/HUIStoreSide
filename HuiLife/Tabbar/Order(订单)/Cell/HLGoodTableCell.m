//
//  HLGoodTableCell.m
//  iOS13test
//
//  Created by 雷清华 on 2019/10/29.
//  Copyright © 2019 雷清华. All rights reserved.
//

#import "HLGoodTableCell.h"

@interface HLGoodTableCell ()

@property (nonatomic, strong) UIImageView *headView;

@property (nonatomic, strong) UILabel *nameLb;

@property (nonatomic, strong) UILabel *numLb;

@property (nonatomic, strong) UILabel *oriPriceLb;

@property (nonatomic, strong) UILabel *priceLb;

@property (nonatomic, strong) UILabel *subLb;

@end

@implementation HLGoodTableCell

- (void)initSubView {
    [super initSubView];
    self.showLine = false;
    [self showArrow:false];
    
    _headView = [[UIImageView alloc]init];
    _headView.layer.cornerRadius = FitPTScreen(5);
    [self.bagView addSubview:_headView];
    [_headView makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(FitPTScreen(11));
        make.centerY.equalTo(self.bagView);
        make.width.height.equalTo(FitPTScreen(48));
    }];
    
    _nameLb = [UILabel hl_regularWithColor:@"#222222" font:14];
    [self.bagView addSubview:_nameLb];
    [_nameLb makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.headView.right).offset(FitPTScreen(10));
        make.top.equalTo(FitPTScreen(18));
    }];
    
    _priceLb = [UILabel hl_regularWithColor:@"#222222" font:14];
    [self.bagView addSubview:_priceLb];
    [_priceLb makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.nameLb);
        make.right.equalTo(FitPTScreen(-11));
    }];
    
    _numLb = [UILabel hl_regularWithColor:@"#999999" font:13];
    [self.bagView addSubview:_numLb];
    [_numLb makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(FitPTScreen(-85));
        make.centerY.equalTo(self.priceLb);
    }];
    
    _oriPriceLb = [UILabel hl_regularWithColor:@"#999999" font:14];
    [self.bagView addSubview:_oriPriceLb];
    [_oriPriceLb makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.priceLb.bottom).offset(FitPTScreen(15));
        make.right.equalTo(self.priceLb);
    }];
    
    UIView *priceLine = [[UIView alloc]init];
    priceLine.backgroundColor = UIColorFromRGB(0x999999);
    [_oriPriceLb addSubview:priceLine];
    [priceLine makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.centerY.width.equalTo(self.oriPriceLb);
        make.height.equalTo(0.7);
    }];
    
    _subLb = [UILabel hl_regularWithColor:@"#999999" font:11];
    [self.bagView addSubview:_subLb];
    [_subLb makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.nameLb);
        make.centerY.equalTo(self.oriPriceLb);
    }];
}

- (void)setGoodModel:(HLOrderGoodModel *)goodModel {
    _goodModel = goodModel;
    [_headView sd_setImageWithURL:[NSURL URLWithString:goodModel.pic] placeholderImage:[UIImage imageNamed:@"logo_list_default"]];
    _nameLb.text = goodModel.title;
    _numLb.text = [NSString stringWithFormat:@"x%ld",goodModel.num];
    _priceLb.text = [NSString moneyPrefixWithMoney:goodModel.pay_price];
    _oriPriceLb.text = [NSString moneyPrefixWithMoney:goodModel.price];
    _subLb.text = goodModel.param;
}

@end
