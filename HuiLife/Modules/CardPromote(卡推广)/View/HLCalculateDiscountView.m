//
//  HLCalculateDiscountView.m
//  HuiLife
//
//  Created by 雷清华 on 2019/11/7.
//

#import "HLCalculateDiscountView.h"

@interface HLCalculateDiscountView ()

{
    NSInteger _maxInt;//最大值整数部分
    NSInteger _maxDot;//最大值小数部分
    NSInteger _minInt;
    NSInteger _minDot;
}

@property(nonatomic, strong) UIButton *deleteBtn;

@property(nonatomic, strong) UIButton *increaseBtn;
//整数部分
@property(nonatomic, strong) UITextField *intField;
//小数部分
@property(nonatomic, strong) UITextField *dotField;
//整数值
@property(nonatomic, assign) NSInteger intValue;
//小数值
@property(nonatomic, assign) NSInteger dotValue;

@end

@implementation HLCalculateDiscountView

- (instancetype)init {
    if (self = [super init]) {
        [self initSubView];
    }
    return self;
}

- (void)initSubView {
    
    UIView *dotView = [[UIView alloc]init];
    dotView.backgroundColor = UIColorFromRGB(0xD3D3D3);
    dotView.layer.cornerRadius = FitPTScreen(4)/2;
    [self addSubview:dotView];
    [dotView makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self);
        make.bottom.equalTo(FitPTScreen(-2));
        make.width.height.equalTo(FitPTScreen(4));
    }];
    
    _intField = [[UITextField alloc]init];
    _intField.keyboardType = UIKeyboardTypeNumberPad;
    _intField.textColor = UIColorFromRGB(0x333333);
    _intField.placeholder = @"0";
    _intField.textAlignment = NSTextAlignmentCenter;
    _intField.font = [UIFont systemFontOfSize:FitPTScreen(17)];
    _intField.layer.borderColor = UIColorFromRGB(0xE1E1E1).CGColor;
    _intField.layer.borderWidth = 0.5;
    _intField.layer.cornerRadius = FitPTScreen(1.5);
    _intField.layer.masksToBounds = YES;
    _intField.tintColor = UIColorFromRGB(0xff8717);
    [self addSubview:_intField];
    [_intField makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(dotView.left).offset(FitPTScreen(-10));
        make.bottom.equalTo(self);
        make.width.equalTo(FitPTScreen(55));
        make.height.equalTo(FitPTScreen(34));
    }];
    
    _dotField = [[UITextField alloc]init];
    _dotField.textColor = UIColorFromRGB(0x333333);
    _dotField.placeholder = @"0";
    _dotField.keyboardType = UIKeyboardTypeNumberPad;
    _dotField.textAlignment = NSTextAlignmentCenter;
    _dotField.font = [UIFont systemFontOfSize:FitPTScreen(17)];
    _dotField.layer.borderColor = UIColorFromRGB(0xE1E1E1).CGColor;
    _dotField.layer.borderWidth = 0.5;
    _dotField.layer.cornerRadius = FitPTScreen(1.5);
    _dotField.layer.masksToBounds = YES;
    _dotField.tintColor = UIColorFromRGB(0xff8717);
    [self addSubview:_dotField];
    [_dotField makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(dotView.right).offset(FitPTScreen(10));
        make.bottom.equalTo(self);
        make.width.equalTo(FitPTScreen(55));
        make.height.equalTo(FitPTScreen(34));
    }];
    
    [_intField addTarget:self action:@selector(textFieldEditing:) forControlEvents:UIControlEventEditingChanged];
    [_dotField addTarget:self action:@selector(textFieldEditing:) forControlEvents:UIControlEventEditingChanged];
    
    _deleteBtn = [[UIButton alloc]init];
    [_deleteBtn setImage:[UIImage imageNamed:@"card_delete"] forState:UIControlStateNormal];
    [self addSubview:_deleteBtn];
    [_deleteBtn makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.intField.left).offset(FitPTScreen(-32));
        make.centerY.equalTo(self.intField);
        make.width.height.equalTo(FitPTScreen(33));
    }];
    
    
    UILabel *disLb = [[UILabel alloc]init];
    disLb.textColor = UIColorFromRGB(0xABABAB);
    disLb.font = [UIFont systemFontOfSize:FitPTScreen(16)];
    disLb.text = @"折";
    [self addSubview:disLb];
    [disLb makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.dotField.right).offset(FitPTScreen(6));
        make.bottom.equalTo(self);
    }];
    
    _increaseBtn = [[UIButton alloc]init];
    [_increaseBtn setImage:[UIImage imageNamed:@"add_oriange"] forState:UIControlStateNormal];
    [self addSubview:_increaseBtn];
    [_increaseBtn makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(disLb.right).offset(FitPTScreen(21));
        make.centerY.equalTo(self.intField);
        make.width.height.equalTo(FitPTScreen(33));
    }];
    
    [_deleteBtn addTarget:self action:@selector(deleteClick:) forControlEvents:UIControlEventTouchUpInside];
    [_increaseBtn addTarget:self action:@selector(increaseClick:) forControlEvents:UIControlEventTouchUpInside];
}

- (void)textFieldEditing:(UITextField *)sender {
    if ([sender isEqual:_intField]) {
        _intValue = [_intField.text integerValue];
    } else {
        _dotValue = [_dotField.text integerValue];
    }
}

#pragma mark - event
//减
- (void)deleteClick:(UIButton *)sender {

    if (_intValue <= _minInt && _dotValue <= _minDot) {
        NSString *hint = [NSString stringWithFormat:@"最高%@折",_minValue];
        HLShowHint(hint, nil);
        return;
    }
    
    if (_dotValue <= 0) {
        _dotValue = 9;
        _dotField.text = [NSString stringWithFormat:@"%ld",_dotValue];
        
        _intValue -= 1;
        _intField.text = [NSString stringWithFormat:@"%ld",_intValue];
        return;
    }
    
    _dotValue --;
    _dotField.text = [NSString stringWithFormat:@"%ld",_dotValue];
}

//增
- (void)increaseClick:(UIButton *)sender {
    
    if (_intValue == _maxInt && _dotValue == _maxDot) {
        NSString *hint = [NSString stringWithFormat:@"最低%@折",_maxValue];
        HLShowHint(hint, nil);
        return;
    }
    
    if (_dotValue >= 9) {
        _dotValue = 0;
        _dotField.text = [NSString stringWithFormat:@"%ld",_dotValue];
        _intValue += 1;
        _intField.text = [NSString stringWithFormat:@"%ld",_intValue];
        return;
    }
    
    _dotValue ++;
    _dotField.text = [NSString stringWithFormat:@"%ld",_dotValue];
    
}

#pragma mark - public
//设置两个值
- (void)setValueWithInt:(NSInteger)intValue dotValue:(NSInteger)dotValue {
    _intValue = intValue;
    _dotValue = dotValue;
    _intField.text = [NSString stringWithFormat:@"%ld",_intValue];
    _dotField.text = [NSString stringWithFormat:@"%ld",_dotValue];
}

- (NSArray *)getDiscountValues {
    return @[@(_intValue),@(_dotValue)];
}

- (void)setMaxValue:(NSString *)maxValue {
    _maxValue = maxValue;
    if ([_maxValue containsString:@"."]) {
        NSArray *values = [maxValue componentsSeparatedByString:@"."];
        _maxInt = [values.firstObject integerValue];
        _maxDot = [values.lastObject integerValue];
    } else {
        _maxInt = [maxValue integerValue];
    }
}

- (void)setMinValue:(NSString *)minValue {
    _minValue = minValue;
    if ([_minValue containsString:@"."]) {
        NSArray *values = [_minValue componentsSeparatedByString:@"."];
        _minInt = [values.firstObject integerValue];
        _minDot = [values.lastObject integerValue];
    } else {
        _minInt = [minValue integerValue];
    }
}

@end
