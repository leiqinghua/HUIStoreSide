//
//  HLRedBagSetView.m
//  HuiLife
//
//  Created by 雷清华 on 2020/11/16.
//

#import "HLRedBagSetView.h"
#import "HLRedBagInfo.h"

@interface HLRedBagSetView ()
@property(nonatomic, strong) UILabel *titleLb;
@property(nonatomic, strong) UIView *priceInput;
@property(nonatomic, strong) UIView *numInput;
@property(nonatomic, strong) UILabel *timeTipLb;
@property(nonatomic, strong) UILabel *rangeLb;
@property(nonatomic, strong) NSMutableArray *timeBtns;
@property(nonatomic, strong) UIView *selfView;//本店
@property(nonatomic, strong) UIView *cityView;//同城

@property(nonatomic, strong) UIButton *selectBtn;
@property(nonatomic, strong) UIView *rangeView;
@end

@implementation HLRedBagSetView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self initSubView];
    }
    return self;
}

- (void)seletTimeAtIndex:(NSInteger)index {
    UIButton *button = self.timeBtns[index];
    [self buttonClick:button];
}

- (void)selectRangeAtIndex:(NSInteger)index {
    UIView *tapView = index == 0?_selfView:_cityView;
    [self rangeWithTapView:tapView];
}

- (void)setTitle:(NSString *)title {
    _titleLb.text = title;
}

- (void)setTimeTitle:(NSString *)timeTitle {
    _timeTipLb.text = timeTitle;
}

- (void)setRangeTitle:(NSString *)rangeTitle {
    _rangeLb.text = rangeTitle;
}

- (void)setPriceTitle:(NSString *)priceTitle {
    UILabel *lable = (UILabel *)[_priceInput viewWithTag:1000];
    lable.text = priceTitle;
}

- (void)setPricePlace:(NSString *)pricePlace {
    UITextField *field = (UITextField *)[_priceInput viewWithTag:1001];
    field.keyboardType = UIKeyboardTypeDecimalPad;
    NSAttributedString *placeAttri = [[NSAttributedString alloc]initWithString:pricePlace attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:FitPTScreen(14)],NSForegroundColorAttributeName:UIColorFromRGB(0xCCCCCC)}];
    field.attributedPlaceholder = placeAttri;
}

- (void)setNumPlace:(NSString *)numPlace {
    UITextField *field = (UITextField *)[_numInput viewWithTag:1001];
    field.keyboardType = UIKeyboardTypeNumberPad;
    NSAttributedString *placeAttri = [[NSAttributedString alloc]initWithString:numPlace attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:FitPTScreen(14)],NSForegroundColorAttributeName:UIColorFromRGB(0xCCCCCC)}];
    field.attributedPlaceholder = placeAttri;
}

- (void)setNumTitle:(NSString *)numTitle {
    UILabel *lable = (UILabel *)[_numInput viewWithTag:1000];
    lable.text = numTitle;
}

- (void)setTimes:(NSArray *)times {
    _timeTipLb.hidden = !times.count;
    for (UIButton *button in self.timeBtns) {
        button.hidden = !times.count;
        NSInteger index = [self.timeBtns indexOfObject:button];
        [button setTitle:times[index] forState:UIControlStateNormal];
    }
    if (!times.count) {
        [_rangeLb updateConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.numInput.bottom).offset(FitPTScreen(20));
        }];
    } else {
        [_rangeLb updateConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.timeTipLb.bottom).offset(FitPTScreen(70));
        }];
    }
}

#pragma mark - Method
- (void)configRangeView:(UIView *)rangeView select:(BOOL)select {
    UIImageView *imageV = (UIImageView *)[rangeView viewWithTag:1001];
    imageV.image = select?[UIImage imageNamed:@"single_ring_normal"]:[UIImage imageNamed:@"circle_white_border_normal"];
}

#pragma mark - Event
- (void)buttonClick:(UIButton *)sender {
    if (![sender isEqual:_selectBtn]) {
        _selectBtn.selected = NO;
        [_selectBtn setBackgroundColor:UIColorFromRGB(0xF8F8F8)];

        sender.selected = YES;
        [sender setBackgroundColor:UIColorFromRGB(0xFD942E)];
    }
    _selectBtn = sender;
    NSInteger index =  [self.timeBtns indexOfObject:sender];
    self.redBagInfo.timeType = self.redBagInfo.rangTimes[index];
}

- (void)rangeClick:(UITapGestureRecognizer *)sender {
    UIView *tapView = sender.view;
    [self rangeWithTapView:tapView];
}

- (void)rangeWithTapView:(UIView *)tapView {
    if (![tapView isEqual:_rangeView]) {
        [self configRangeView:_rangeView select:NO];
        [self configRangeView:tapView select:YES];
    }
    _rangeView = tapView;
    self.redBagInfo.scopeType = [tapView isEqual:_selfView]?0:1;
}

- (void)textFieldEditing:(UITextField *)textField {
    UITextField *priceField = [_priceInput viewWithTag:1001];
    if ([textField isEqual:priceField]) {
        self.redBagInfo.total = textField.text;
    } else {
        self.redBagInfo.num = [textField.text integerValue];
    }
    if ([self.delegate respondsToSelector:@selector(textFieldDidEdit:price:)]) {
        [self.delegate textFieldDidEdit:textField price:[textField isEqual:priceField]];
    }
}
#pragma mark - UIView
- (void)initSubView {
    _titleLb = [UILabel hl_singleLineWithColor:@"#222222" font:14 bold:YES];
    [self addSubview:_titleLb];
    [_titleLb makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(FitPTScreen(12));
        make.top.equalTo(FitPTScreen(16));
    }];
    
    _priceInput = [self creteInputViewWithTip:YES];
    [self addSubview:_priceInput];
    [_priceInput makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(FitPTScreen(12));
        make.top.equalTo(self.titleLb.bottom).offset(FitPTScreen(15));
        make.size.equalTo(CGSizeMake(FitPTScreen(351), FitPTScreen(44)));
    }];
    
    _numInput = [self creteInputViewWithTip:NO];
    [self addSubview:_numInput];
    [_numInput makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(FitPTScreen(12));
        make.top.equalTo(self.priceInput.bottom).offset(FitPTScreen(10));
        make.size.equalTo(CGSizeMake(FitPTScreen(351), FitPTScreen(44)));
    }];
    
    _timeTipLb = [UILabel hl_singleLineWithColor:@"#222222" font:14 bold:YES];
    _timeTipLb.text = @"推广时间";
    [self addSubview:_timeTipLb];
    [_timeTipLb makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(FitPTScreen(12));
        make.top.equalTo(self.numInput.bottom).offset(FitPTScreen(20));
    }];
    
    _timeBtns = [NSMutableArray array];
    CGFloat width = FitPTScreen(110);
    CGFloat height = FitPTScreen(35);
    CGFloat gap = FitPTScreen(10);
    for (NSInteger index = 0; index < 3; index ++) {
        UIButton *button = [[UIButton alloc]init];
        button.tag = 10000+index;
        [button setBackgroundColor:UIColorFromRGB(0xF8F8F8)];
        [button setTitleColor:UIColorFromRGB(0x666666) forState:UIControlStateNormal];
        [button setTitleColor:UIColor.whiteColor forState:UIControlStateSelected];
        button.titleLabel.font = [UIFont systemFontOfSize:FitPTScreen(14)];
        button.layer.cornerRadius = FitPTScreen(3);
        [self addSubview:button];
        [button makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(gap*(index + 1) +index *width);
            make.top.equalTo(self.timeTipLb.bottom).offset(FitPTScreen(11));
            make.size.equalTo(CGSizeMake(width, height));
        }];
        [self.timeBtns addObject:button];
        [button addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    
    _rangeLb = [UILabel hl_singleLineWithColor:@"#222222" font:14 bold:YES];
    _rangeLb.text = @"领取范围";
    [self addSubview:_rangeLb];
    [_rangeLb makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(FitPTScreen(12));
        make.top.equalTo(self.timeTipLb.bottom).offset(FitPTScreen(70));
    }];
    
    _selfView = [self createRangeView];
    [self addSubview:_selfView];
    [_selfView makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self);
        make.top.equalTo(self.rangeLb.bottom).offset(FitPTScreen(10));
        make.height.equalTo(FitPTScreen(33));
    }];
    
    _cityView = [self createRangeView];
    [self addSubview:_cityView];
    [_cityView makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self);
        make.top.equalTo(self.selfView.bottom);
        make.height.equalTo(FitPTScreen(30));
    }];
    
    UILabel *selfLb = (UILabel *)[_selfView viewWithTag:1000];
    selfLb.text = @"仅限本店顾客领取";
    UILabel *cityLb = (UILabel *)[_cityView viewWithTag:1000];
    cityLb.text = @"同城顾客领取";
    
    UITapGestureRecognizer *tap1 = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(rangeClick:)];
    [_selfView addGestureRecognizer:tap1];
    
    UITapGestureRecognizer *tap2 = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(rangeClick:)];
    [_cityView addGestureRecognizer:tap2];

}

- (UIView *)creteInputViewWithTip:(BOOL)tip {
    UIView *inputView = [[UIView alloc]init];
    inputView.layer.borderWidth = 0.5;
    inputView.layer.borderColor = [UIColor hl_StringToColor:@"#EDEDED" andAlpha:1].CGColor;
    inputView.layer.cornerRadius = 3;
    
    if (tip) {
        UIView *tipV = [[UIView alloc]init];
        tipV.backgroundColor = UIColorFromRGB(0xFD942E);
        inputView.layer.cornerRadius = 1.5;
        inputView.layer.masksToBounds = YES;
        [inputView addSubview:tipV];
        [tipV makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(FitPTScreen(13));
            make.centerY.equalTo(inputView);
            make.size.equalTo(CGSizeMake(FitPTScreen(18), FitPTScreen(18)));
        }];
        
        UILabel *lable = [UILabel hl_regularWithColor:@"#FFFFFF" font:12];
        lable.text = @"拼";
        [tipV addSubview:lable];
        [lable makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.centerY.equalTo(tipV);
        }];
    }
    
    UILabel *tipLb = [UILabel hl_regularWithColor:@"#666666" font:14];
    tipLb.tag = 1000;
    [inputView addSubview:tipLb];
    [tipLb makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(tip?FitPTScreen(44):FitPTScreen(13));
        make.centerY.equalTo(inputView);
    }];
    
    UITextField *textField = [[UITextField alloc]init];
    textField.textColor = UIColorFromRGB(0x111111);
    textField.font = [UIFont boldSystemFontOfSize:FitPTScreen(14)];
    textField.tag = 1001;
    textField.tintColor = UIColorFromRGB(0xFD942E);
    [inputView addSubview:textField];
    [textField makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(inputView);
        make.left.equalTo(FitPTScreen(127));
        make.size.equalTo(CGSizeMake(FitPTScreen(150), FitPTScreen(40)));
    }];
    [textField addTarget:self action:@selector(textFieldEditing:) forControlEvents:UIControlEventEditingChanged];
    
    UILabel *rightLb = [UILabel hl_regularWithColor:@"#666666" font:14];
    rightLb.tag = 1002;
    [inputView addSubview:rightLb];
    [rightLb makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(FitPTScreen(-15));
        make.centerY.equalTo(inputView);
    }];
    
    return inputView;;
}

- (UIView *)createRangeView {
    UIView *bottomView = [[UIView alloc]init];
    UILabel *titleLb = [UILabel hl_regularWithColor:@"#333333" font:14];
    titleLb.tag = 1000;
    [bottomView addSubview:titleLb];
    [titleLb makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(FitPTScreen(12));
        make.centerY.equalTo(bottomView);
    }];
    
    UIImageView *selectImV = [[UIImageView alloc]init];
    selectImV.tag = 1001;
    selectImV.image = [UIImage imageNamed:@"select_md_normal"];
    [bottomView addSubview:selectImV];
    [selectImV makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(FitPTScreen(-12));
        make.centerY.equalTo(bottomView);
        make.size.equalTo(CGSizeMake(FitPTScreen(18), FitPTScreen(18)));
    }];
    return bottomView;
}


@end
