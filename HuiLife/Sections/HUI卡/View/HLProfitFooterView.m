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

// 首单折扣 & 日常折扣 footer
#pragma mark - HLProfitDiscountView

@interface HLProfitDiscountView ()
@property(nonatomic, strong) UIButton *selectBtn;
@property(nonatomic, strong) UITextField *intInput;
@property(nonatomic, strong) UITextField *dotInput;
@property(nonatomic, strong) NSMutableArray *buttons;
@property (nonatomic, strong) NSString *maxDiscounnt;
@property (nonatomic, strong) NSString *minDiscounnt;

@end

@implementation HLProfitDiscountView

//- (instancetype)initWithFrame:(CGRect)frame
//{
//    self = [super initWithFrame:frame];
//    if (self) {
//
//    }
//    return self;
//}

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
    
    [self.intInput endEditing:YES];
    [self.dotInput endEditing:YES];
    
    _selectBtn.selected = NO;
    [self configButton:_selectBtn];
    
    if(self.discount.doubleValue <= 1.0) return;;
    
    NSInteger dot = [_dotInput.text integerValue];
    NSInteger num = [_intInput.text integerValue];
    if (dot > 0) {
        dot--;
        _dotInput.text = [NSString stringWithFormat:@"%ld",dot];
    } else {
        if (num > 0) {
            num--;
            _dotInput.text = @"9";
            _intInput.text = [NSString stringWithFormat:@"%ld",num];
        }
    }
}

//加
- (void)addClick {
    
    [self.intInput endEditing:YES];
    [self.dotInput endEditing:YES];
    
    _selectBtn.selected = NO;
    [self configButton:_selectBtn];
    
    if(self.discount.doubleValue >= 9.5) return;;
    
    NSInteger dot = [_dotInput.text integerValue];
    NSInteger num = [_intInput.text integerValue];
    if (dot < 9) {
        dot++;
        _dotInput.text = [NSString stringWithFormat:@"%ld",dot];
    } else {
        if (num < 9) {
            num++;
            _dotInput.text = @"0";
            _intInput.text = [NSString stringWithFormat:@"%ld",num];
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
        _intInput.text = @"0";
        _dotInput.text = @"0";
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
    _intInput.text = intStr;
    _dotInput.text = dotStr;
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

- (void)inputChanged:(UITextField *)sender{
    if (sender.text.length > 1) {
        sender.text = [sender.text substringToIndex:1];
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
    
    _intInput = [[UITextField alloc] init];
    [self addSubview:_intInput];
    _intInput.textAlignment = NSTextAlignmentCenter;
    _intInput.textColor = UIColorFromRGB(0x343434);
    _intInput.font = [UIFont systemFontOfSize:15];
    _intInput.backgroundColor = UIColorFromRGB(0xF2F3F5);
    [_intInput makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(delBtn.right).offset(FitPTScreen(1.5));
        make.centerY.equalTo(tipLb);
        make.size.equalTo(CGSizeMake(FitPTScreen(50), FitPTScreen(35)));
    }];
    _intInput.keyboardType = UIKeyboardTypeNumberPad;
    [_intInput addTarget:self action:@selector(inputChanged:) forControlEvents:UIControlEventEditingChanged];
    
    UILabel *dotLb = [UILabel hl_regularWithColor:@"#343434" font:13];
    dotLb.text = @".";
    [self addSubview:dotLb];
    [dotLb makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.intInput.right).offset(FitPTScreen(3.5));
        make.top.equalTo(self.intInput).offset(FitPTScreen(23));
    }];
    
    _dotInput = [[UITextField alloc] init];
    [self addSubview:_dotInput];
    _dotInput.textAlignment = NSTextAlignmentCenter;
    _dotInput.textColor = UIColorFromRGB(0x343434);
    _dotInput.font = [UIFont systemFontOfSize:15];
    _dotInput.keyboardType = UIKeyboardTypeNumberPad;
    _dotInput.backgroundColor = UIColorFromRGB(0xF2F3F5);
    [_dotInput makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(dotLb.right).offset(FitPTScreen(3.5));
        make.centerY.equalTo(tipLb);
        make.size.equalTo(CGSizeMake(FitPTScreen(50), FitPTScreen(35)));
    }];
    [_dotInput addTarget:self action:@selector(inputChanged:) forControlEvents:UIControlEventEditingChanged];

    
    UIButton *addBtn = [UIButton hl_regularWithTitle:@"+" titleColor:@"#343434" font:15 image:@""];
    [addBtn hl_addCornerRadius:FitPTScreen(4) bounds:CGRectMake(0, 0, FitPTScreen(40), FitPTScreen(35))  byRoundingCorners:UIRectCornerTopRight | UIRectCornerBottomRight];
    addBtn.backgroundColor = UIColorFromRGB(0xF2F3F5);
    [self addSubview:addBtn];
    [addBtn makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.dotInput.right).offset(FitPTScreen(1.5));
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
    return [NSString stringWithFormat:@"%@.%@",_intInput.text,_dotInput.text];
}

@end
