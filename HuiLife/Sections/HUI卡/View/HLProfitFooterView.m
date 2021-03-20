//
//  HLProfitFooterView.m
//  HuiLife
//
//  Created by 雷清华 on 2020/9/24.
//

#import "HLProfitFooterView.h"

@interface HLProfitFooterView ()
@property(nonatomic, strong) UILabel *titleLb;
@property(nonatomic, strong) UILabel *detailLb;
@end

@implementation HLProfitFooterView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self initSubView];
    }
    return self;
}

- (void)initSubView {
    _titleLb = [UILabel hl_singleLineWithColor:@"#222222" font:14 bold:YES];
    [self addSubview:_titleLb];
    [_titleLb makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(FitPTScreen(12));
        make.top.equalTo(FitPTScreen(20));
    }];
    
    _detailLb = [UILabel hl_regularWithColor:@"#9A9A9A" font:12];
    [self addSubview:_detailLb];
    [_detailLb makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(FitPTScreen(12));
        make.top.equalTo(self.titleLb.bottom).offset(FitPTScreen(11));
    }];
    
    _titleLb.text = @"推荐折扣";
    _detailLb.text = @"根据市场店铺整合大数据推荐以下折扣";
}

@end

//折扣
#pragma mark - HLProfitDiscountView
@interface HLProfitDiscountView ()
@property(nonatomic, strong) UIButton *selectBtn;
@property(nonatomic, strong) UIButton *intBtn;
@property(nonatomic, strong) UIButton *dotBtn;
@property(nonatomic, strong) NSMutableArray *buttons;
@end

@implementation HLProfitDiscountView

- (void)buttonClick:(UIButton *)sender {
    if (![sender isEqual:_selectBtn]) {
        _selectBtn.selected = NO;
        [self configButton:_selectBtn];
    }
    sender.selected = YES;
    [self configButton:sender];
    [self configDiscount:sender.titleLabel.text];
    _selectBtn = sender;
}

//减
- (void)delClick {
    
    _selectBtn.selected = NO;
    [self configButton:_selectBtn];
    
    NSInteger dot = [_dotBtn.titleLabel.text integerValue];
    NSInteger num = [_intBtn.titleLabel.text integerValue];
    if (dot > 0) {
        dot --;
        [_dotBtn setTitle:[NSString stringWithFormat:@"%ld",dot] forState:UIControlStateNormal];
    } else {
        if (num > 0) {
            num --;
            [_dotBtn setTitle:@"9" forState:UIControlStateNormal];
            [_intBtn setTitle:[NSString stringWithFormat:@"%ld",num] forState:UIControlStateNormal];
        }
    }
}

//加
- (void)addClick {
    
    _selectBtn.selected = NO;
    [self configButton:_selectBtn];
    
    NSInteger dot = [_dotBtn.titleLabel.text integerValue];
    NSInteger num = [_intBtn.titleLabel.text integerValue];
    if (dot < 9) {
        dot ++;
        [_dotBtn setTitle:[NSString stringWithFormat:@"%ld",dot] forState:UIControlStateNormal];
    } else {
        if (num < 9) {
            num ++;
            [_dotBtn setTitle:@"0" forState:UIControlStateNormal];
            [_intBtn setTitle:[NSString stringWithFormat:@"%ld",num] forState:UIControlStateNormal];
        }
    }
}


- (void)selectAtIndex:(NSInteger)index {
    UIButton *button = [self.buttons objectAtIndex:index];
    [self buttonClick:button];
}

- (void)configButton:(UIButton *)sender{
    if (sender.selected) {
        sender.backgroundColor = UIColorFromRGB(0xFFFAF3);
        sender.layer.borderColor = UIColorFromRGB(0xFD9E30).CGColor;
        sender.layer.borderWidth = 0.5;
    } else {
        sender.backgroundColor = UIColorFromRGB(0xF6F7F9);
        sender.layer.borderColor = UIColor.clearColor.CGColor;
        sender.layer.borderWidth = 0;
    }
}

- (void)configDiscount:(NSString *)discountStr {
    if ([discountStr isEqualToString:@"无折扣"]) {
        [_intBtn setTitle:@"0" forState:UIControlStateNormal];
        [_dotBtn setTitle:@"0" forState:UIControlStateNormal];
        return;
    }
    NSString *discount = [discountStr substringToIndex:(discountStr.length-1)];
//    整数部分
    NSString *intStr = [discount substringWithRange:NSMakeRange(0, 1)];
    NSString *dotStr = @"0";
    if ([discount containsString:@"."]) {
        NSRange dotRange = [discount rangeOfString:@"."];
        dotStr = [discount substringFromIndex:(dotRange.location + 1)];
    }
    [_intBtn setTitle:intStr forState:UIControlStateNormal];
    [_dotBtn setTitle:dotStr forState:UIControlStateNormal];
}

- (void)configDefaultDiscountStr:(NSString *)discountStr {
    NSInteger index = -1;
    for (NSString *text in self.discounts) {
        if ([discountStr isEqualToString:text]) {
            index = [self.discounts indexOfObject:text];
        }
    }
    if (index >= 0) {
        [self selectAtIndex:index];
    } else {
        [self configDiscount:discountStr];
        _selectBtn.selected = NO;
        [self configButton:_selectBtn];
    }
}

- (void)initSubView {
    [super initSubView];
    UILabel *tipLb = [UILabel hl_regularWithColor:@"#9A9A9A" font:12];
    tipLb.text = @"自定义折扣";
    [self addSubview:tipLb];
    [tipLb makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(FitPTScreen(13));
        make.bottom.equalTo(FitPTScreen(-44));
    }];
    
    UIButton *delBtn = [UIButton hl_regularWithTitle:@"-" titleColor:@"#343434" font:15 image:@""];;
    [delBtn hl_addCornerRadius:FitPTScreen(4) bounds:CGRectMake(0, 0, FitPTScreen(40), FitPTScreen(35))  byRoundingCorners:UIRectCornerTopLeft | UIRectCornerBottomLeft];
    delBtn.backgroundColor = UIColorFromRGB(0xF2F3F5);
    [self addSubview:delBtn];
    [delBtn makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(tipLb.right).offset(FitPTScreen(10));
        make.centerY.equalTo(tipLb);
        make.size.equalTo(CGSizeMake(FitPTScreen(40), FitPTScreen(35)));
    }];
    
    _intBtn = [UIButton hl_regularWithTitle:@"0" titleColor:@"#343434" font:15 image:@""];
    _intBtn.backgroundColor = UIColorFromRGB(0xF2F3F5);
    [self addSubview:_intBtn];
    [_intBtn makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(delBtn.right).offset(FitPTScreen(1.5));
        make.centerY.equalTo(tipLb);
        make.size.equalTo(CGSizeMake(FitPTScreen(50), FitPTScreen(35)));
    }];
    
    UILabel *dotLb = [UILabel hl_regularWithColor:@"#343434" font:13];
    dotLb.text = @".";
    [self addSubview:dotLb];
    [dotLb makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.intBtn.right).offset(FitPTScreen(3.5));
        make.top.equalTo(self.intBtn).offset(FitPTScreen(23));
    }];
    
    _dotBtn = [UIButton hl_regularWithTitle:@"1" titleColor:@"#343434" font:15 image:@""];
    _dotBtn.backgroundColor = UIColorFromRGB(0xF2F3F5);
    [self addSubview:_dotBtn];
    [_dotBtn makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(dotLb.right).offset(FitPTScreen(3.5));
        make.centerY.equalTo(tipLb);
        make.size.equalTo(CGSizeMake(FitPTScreen(50), FitPTScreen(35)));
    }];
    
    UIButton *addBtn = [UIButton hl_regularWithTitle:@"+" titleColor:@"#343434" font:15 image:@""];
    [addBtn hl_addCornerRadius:FitPTScreen(4) bounds:CGRectMake(0, 0, FitPTScreen(40), FitPTScreen(35))  byRoundingCorners:UIRectCornerTopRight | UIRectCornerBottomRight];
    addBtn.backgroundColor = UIColorFromRGB(0xF2F3F5);
    [self addSubview:addBtn];
    [addBtn makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.dotBtn.right).offset(FitPTScreen(1.5));
        make.centerY.equalTo(tipLb);
        make.size.equalTo(CGSizeMake(FitPTScreen(40), FitPTScreen(35)));
    }];
    
    [delBtn addTarget:self action:@selector(delClick) forControlEvents:UIControlEventTouchUpInside];
    [addBtn addTarget:self action:@selector(addClick) forControlEvents:UIControlEventTouchUpInside];
    
    UILabel *discountTipLb = [UILabel hl_regularWithColor:@"#343434" font:13];
    discountTipLb.text = @"折";
    [self addSubview:discountTipLb];
    [discountTipLb makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(addBtn.right).offset(FitPTScreen(6.5));
        make.centerY.equalTo(tipLb);
    }];
}

- (void)setDiscounts:(NSArray *)discounts {
    if (_discounts.count) return;
    _discounts = discounts;
    CGFloat width = FitPTScreen(80);
    CGFloat hight = FitPTScreen(30);
    for (NSInteger index = 0; index < discounts.count; index ++) {
        NSInteger row = index / 4; //所处行
        NSInteger col = index % 4;
        UIButton *button = [UIButton hl_regularWithTitle:discounts[index] titleColor:@"#343434" font:13 image:@""];
        button.layer.cornerRadius = FitPTScreen(2);
        button.tag = index;
        [button setTitleColor:UIColorFromRGB(0xFE9E30) forState:UIControlStateSelected];
        button.backgroundColor = UIColorFromRGB(0xF6F7F9);
        [self addSubview:button];
        [button makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(FitPTScreen(13) + (width + FitPTScreen(10))*col);
            make.top.equalTo(self.detailLb.bottom).offset(FitPTScreen(10) + (hight + FitPTScreen(10))*row);
            make.size.equalTo(CGSizeMake(width, hight));
        }];
        [self.buttons addObject:button];
        [button addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
    }
}

- (NSMutableArray *)buttons {
    if (!_buttons) {
        _buttons = [NSMutableArray array];
    }
    return _buttons;
}

- (NSString *)discount {
    return [NSString stringWithFormat:@"%@.%@",_intBtn.titleLabel.text,_dotBtn.titleLabel.text];
}

@end
