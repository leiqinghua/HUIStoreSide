//
//  HLSellTimeTableViewCell.m
//  HuiLife
//
//  Created by 雷清华 on 2020/3/30.
//

#import "HLTakeOrderTypeViewCell.h"

@interface HLTakeOrderTypeViewCell ()

@property(nonatomic, strong) UILabel *titleLb;

@property(nonatomic, strong) UIButton *autoTakeBtn;

@property(nonatomic, strong) UIButton *manualTakeBtn;

@property(nonatomic, strong) UILabel *tipLb;

@property(nonatomic, strong) UIButton *selectBtn;

@end

@implementation HLTakeOrderTypeViewCell

- (void)initSubView {
    [super initSubView];
    [self showArrow:NO];
    self.showLine = YES;
    _titleLb = [UILabel hl_regularWithColor:@"#333333" font:14];
    [self.bagView addSubview:_titleLb];
    [_titleLb makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(FitPTScreen(13));
        make.top.equalTo(FitPTScreen(19));
    }];
    
    _autoTakeBtn = [UIButton hl_regularWithTitle:@" 自动接单" titleColor:@"#333333" font:14 image:@"circle_white_border_normal"];
    [_autoTakeBtn setImage:[UIImage imageNamed:@"success_oriange"] forState:UIControlStateSelected];
    _autoTakeBtn.tag = 0;
    [self.bagView addSubview:_autoTakeBtn];
    [_autoTakeBtn makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.titleLb.right).offset(FitPTScreen(88));
        make.centerY.equalTo(self.titleLb);
    }];
    
    _manualTakeBtn = [UIButton hl_regularWithTitle:@" 手动接单" titleColor:@"#333333" font:14 image:@"circle_white_border_normal"];
    [_manualTakeBtn setImage:[UIImage imageNamed:@"success_oriange"] forState:UIControlStateSelected];
    _manualTakeBtn.tag = 1;
    [self.bagView addSubview:_manualTakeBtn];
    [_manualTakeBtn makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.autoTakeBtn.right).offset(FitPTScreen(35));
        make.centerY.equalTo(self.titleLb);
    }];
    [_autoTakeBtn addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
    [_manualTakeBtn addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
    
    _tipLb = [UILabel hl_regularWithColor:@"#A9A9A9" font:12];
    _tipLb.text = @"用户下单后商家可选择接单/取消接单";
    [self.bagView addSubview:_tipLb];
    [_tipLb makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.titleLb);
        make.bottom.equalTo(FitPTScreen(-17));
    }];
}

- (void)setModel:(HLSellModel *)model {
    _model = model;
    _titleLb.text = model.title;
    NSArray *values = model.values;
    if (values.count == 1) {
        NSInteger index = [values.firstObject integerValue];
        if (index == 0) {
            _autoTakeBtn.selected = YES;
            _manualTakeBtn.selected = NO;
            _selectBtn = _autoTakeBtn;
        } else {
            _manualTakeBtn.selected = YES;
            _autoTakeBtn.selected = NO;
            _selectBtn = _manualTakeBtn;
        }
    }
}

- (void)buttonClick:(UIButton *)sender {
    sender.selected = YES;
    _selectBtn.selected = NO;
    _selectBtn = sender;
    
    if ([sender isEqual:_autoTakeBtn]) {
        _model.values = @[@(0)];
    } else {
        _model.values = @[@(1)];
    }
}
@end

