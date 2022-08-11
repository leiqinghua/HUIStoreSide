//
//  HLSellTimeTableViewCell.m
//  HuiLife
//
//  Created by 雷清华 on 2020/3/30.
//

#import "HLSellTimeTableViewCell.h"

@interface HLSellTimeTableViewCell ()

@property(nonatomic, strong) UILabel *titleLb;

@property(nonatomic, strong) UIButton *allBtn;

@property(nonatomic, strong) UIButton *autoBtn;

@property(nonatomic, strong) UILabel *tipLb;

@property(nonatomic, strong) UIButton *selectBtn;

@end

@implementation HLSellTimeTableViewCell

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
    
    _allBtn = [UIButton hl_regularWithTitle:@" 全时段售卖" titleColor:@"#333333" font:14 image:@"circle_white_border_normal"];
    [_allBtn setImage:[UIImage imageNamed:@"success_oriange"] forState:UIControlStateSelected];
    _allBtn.tag = 0;
    [self.bagView addSubview:_allBtn];
    [_allBtn makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.titleLb.right).offset(FitPTScreen(74));
        make.centerY.equalTo(self.titleLb);
    }];
    
    _autoBtn = [UIButton hl_regularWithTitle:@" 自定义时间" titleColor:@"#333333" font:14 image:@"circle_white_border_normal"];
    [_autoBtn setImage:[UIImage imageNamed:@"success_oriange"] forState:UIControlStateSelected];
    _autoBtn.tag = 1;
    [self.bagView addSubview:_autoBtn];
    [_autoBtn makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.allBtn.right).offset(FitPTScreen(20));
        make.centerY.equalTo(self.titleLb);
    }];
    [_allBtn addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
    [_autoBtn addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
    
    _tipLb = [UILabel hl_regularWithColor:@"#A9A9A9" font:12];
    _tipLb.text = @"超出营业时间用户将不能下单";
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
            _allBtn.selected = YES;
            _autoBtn.selected = NO;
            _selectBtn = _allBtn;
        } else {
            _autoBtn.selected = YES;
            _allBtn.selected = NO;
            _selectBtn = _autoBtn;
        }
    }
}

- (void)buttonClick:(UIButton *)sender {
    sender.selected = YES;
    _selectBtn.selected = NO;
    _selectBtn = sender;
    
    if ([sender isEqual:_allBtn]) {
        _model.values = @[@(0)];
    } else {
        _model.values = @[@(1)];
    }
    if ([self.delegate respondsToSelector:@selector(sellTimeWithModel:clickIndex:)]) {
        [self.delegate sellTimeWithModel:_model clickIndex:sender.tag];
    }
}
@end
