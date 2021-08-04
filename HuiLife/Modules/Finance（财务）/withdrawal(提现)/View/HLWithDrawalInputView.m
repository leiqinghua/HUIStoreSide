//
//  HLWithDrawalInputView.m
//  HuiLife
//
//  Created by 王策 on 2019/9/10.
//

#import "HLWithDrawalInputView.h"

@interface HLWithDrawalInputView () <UITextFieldDelegate>

@property (nonatomic, strong) UITextField *textField;
@property (nonatomic, strong) UILabel *poundageLab;
@property (nonatomic, strong) UILabel *acceptLab;

@end

@implementation HLWithDrawalInputView

- (instancetype)init
{
    self = [super init];
    if (self) {
        [self creatSubViews];
    }
    return self;
}

- (void)creatSubViews{
    
    UIView *leftLine1 = [[UIView alloc] init];
    [self addSubview:leftLine1];
    leftLine1.backgroundColor = UIColorFromRGB(0xFF9616);
    leftLine1.layer.cornerRadius = FitPTScreen(1.5);
    leftLine1.layer.masksToBounds = YES;
    [leftLine1 makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(FitPTScreen(15));
        make.top.equalTo(FitPTScreen(17));
        make.width.equalTo(FitPTScreen(3));
        make.height.equalTo(FitPTScreen(14));
    }];
    
    UILabel *inputTipLab = [[UILabel alloc] init];
    [self addSubview:inputTipLab];
    inputTipLab.text = @"输入提现金额";
    inputTipLab.font = [UIFont systemFontOfSize:FitPTScreen(13)];
    inputTipLab.textColor = UIColorFromRGB(0x222222);
    [inputTipLab makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(leftLine1);
        make.left.equalTo(leftLine1.right).offset(FitPTScreen(5));
    }];
    
    UILabel *unitLab = [[UILabel alloc] init];
    [self addSubview:unitLab];
    unitLab.text = @"￥";
    unitLab.font = [UIFont boldSystemFontOfSize:FitPTScreen(25)];
    unitLab.textColor = UIColorFromRGB(0x282828);
    [unitLab makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(leftLine1.bottom).offset(FitPTScreen(22));
        make.left.equalTo(FitPTScreen(13));
    }];
    
    UIButton *allBtn = [[UIButton alloc] init];
    [self addSubview:allBtn];
    [allBtn setTitle:@"全部提现" forState:UIControlStateNormal];
    [allBtn setTitleColor:UIColorFromRGB(0xFF8D26) forState:UIControlStateNormal];
    allBtn.titleLabel.font = [UIFont systemFontOfSize:FitPTScreen(13)];
    [allBtn makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(unitLab);
        make.right.equalTo(FitPTScreen(0));
        make.width.equalTo(FitPTScreen(82));
        make.height.equalTo(FitPTScreen(35));
    }];
    [allBtn addTarget:self action:@selector(allBtnClick) forControlEvents:UIControlEventTouchUpInside];
    
    _textField = [[UITextField alloc] init];
    _textField.tintColor = UIColorFromRGB(0xff8717);
    [self addSubview:_textField];
    _textField.placeholder = @"请输入金额";
    _textField.textColor = UIColorFromRGB(0x222222);
    _textField.font = [UIFont systemFontOfSize:FitPTScreen(14)];
    _textField.keyboardType = UIKeyboardTypeDecimalPad;
    _textField.delegate = self;
    [_textField makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(unitLab);
        make.left.equalTo(FitPTScreen(38));
        make.height.equalTo(FitPTScreen(50));
        make.right.equalTo(allBtn.left);
    }];
    [_textField addTarget:self action:@selector(textFieldEditChanged:) forControlEvents:UIControlEventEditingChanged];
    
    UIView *inputLine = [[UIView alloc] init];
    [self addSubview:inputLine];
    inputLine.backgroundColor = UIColorFromRGB(0xE5E5E5);
    [inputLine makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(FitPTScreen(15));
        make.right.equalTo(FitPTScreen(-15));
        make.height.equalTo(0.8);
        make.top.equalTo(_textField.bottom);
    }];
    
//    _poundageLab = [[UILabel alloc] init];
//    [self addSubview:_poundageLab];
//    _poundageLab.text = @"提现手续费0.00元";
//    _poundageLab.font = [UIFont systemFontOfSize:FitPTScreen(11)];
//    _poundageLab.textColor = UIColorFromRGB(0x666666);
//    [_poundageLab makeConstraints:^(MASConstraintMaker *make) {
//        make.top.equalTo(inputLine.bottom).offset(FitPTScreen(11));
//        make.left.equalTo(inputLine);
//    }];
    
//    _acceptLab = [[UILabel alloc] init];
//    [self addSubview:_acceptLab];
//    _acceptLab.text = @"实际到账0.00元";
//    _acceptLab.font = [UIFont systemFontOfSize:FitPTScreen(11)];
//    _acceptLab.textColor = UIColorFromRGB(0x666666);
//    [_acceptLab makeConstraints:^(MASConstraintMaker *make) {
//        make.top.equalTo(inputLine.bottom).offset(FitPTScreen(11));
//        make.right.equalTo(inputLine);
//    }];
    
    UIView *leftLine2 = [[UIView alloc] init];
    [self addSubview:leftLine2];
    leftLine2.backgroundColor = UIColorFromRGB(0xFF9616);
    leftLine2.layer.cornerRadius = FitPTScreen(1.5);
    leftLine2.layer.masksToBounds = YES;
    [leftLine2 makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(FitPTScreen(15));
        make.top.equalTo(inputLine.bottom).offset(FitPTScreen(40));
        make.width.equalTo(FitPTScreen(3));
        make.height.equalTo(FitPTScreen(14));
    }];
    
    UILabel *typeTipLab = [[UILabel alloc] init];
    [self addSubview:typeTipLab];
    typeTipLab.text = @"选择提现方式:";
    typeTipLab.font = [UIFont systemFontOfSize:FitPTScreen(13)];
    typeTipLab.textColor = UIColorFromRGB(0x222222);
    [typeTipLab makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(leftLine2);
        make.left.equalTo(leftLine2.right).offset(FitPTScreen(5));
    }];
    
    UIImageView *wxImgV = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"wx_tag"]];
    [self addSubview:wxImgV];
    [wxImgV makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(leftLine2);
        make.top.equalTo(leftLine2.bottom).offset(FitPTScreen(16));
        make.width.equalTo(FitPTScreen(19));
        make.height.equalTo(FitPTScreen(17));
    }];
    
    UILabel *wxTipLab = [[UILabel alloc] init];
    [self addSubview:wxTipLab];
    wxTipLab.text = @"提现至微信";
    wxTipLab.font = [UIFont systemFontOfSize:FitPTScreen(13)];
    wxTipLab.textColor = UIColorFromRGB(0x555555);
    [wxTipLab makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(wxImgV);
        make.left.equalTo(wxImgV.right).offset(FitPTScreen(5));
    }];
    
    UIImageView *selectImgV = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"single_ring_normal"]];
    [self addSubview:selectImgV];
    [selectImgV makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(FitPTScreen(-15));
        make.centerY.equalTo(wxImgV);
        make.width.equalTo(FitPTScreen(17));
        make.height.equalTo(FitPTScreen(17));
    }];
}

/// 配置输入框的金额
- (void)configWithdrawalMoney:(double)money{
    _textField.text = [NSString stringWithFormat:@"%@",[NSString hl_stringWithNoZeroMoney:money]];
    if (money == 0) {
        _textField.text = @"";
        _textField.font = [UIFont systemFontOfSize:FitPTScreen(14)];
    }else{
        _textField.font = [UIFont systemFontOfSize:FitPTScreen(27)];
    }
}

/// 配置手续费和实际到账金额
- (void)configAcceptMoney:(double)acceptMoney{
    _acceptLab.text = [NSString stringWithFormat:@"实际到账%@元",[NSString hl_stringWithNoZeroMoney:acceptMoney]];
}

/// 获取输入框的金额
- (NSString *)inputWithdrawalMoney{
    return _textField.text?:@"";
}

/// 点击全部提现
- (void)allBtnClick{
    if (self.delegate) {
        [self.delegate clickAllMoneyBtnWithInputView:self];
    }
}

- (void)textFieldEditChanged:(UITextField *)sender{
    if(sender.text.length == 0){
        sender.font = [UIFont systemFontOfSize:FitPTScreen(14)];
    }else{
        sender.font = [UIFont systemFontOfSize:FitPTScreen(27)];
    }
    if (self.delegate) {
        [self.delegate inputMoneyChanged:sender.text inputView:self];
    }
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    
    NSString * toBeString = [textField.text stringByReplacingCharactersInRange:range withString:string];
    
    //限制.后面最多有两位，且不能再输入.
    if ([textField.text rangeOfString:@"."].location != NSNotFound) {
        //有.了 且.后面输入了两位  停止输入
        if (toBeString.length > [toBeString rangeOfString:@"."].location+3) {
            return NO;
        }
        //有.了，不允许再输入.
        if ([string isEqualToString:@"."]) {
            return NO;
        }
    }
    
    // 限制首位0，后面只能输入.
    if ([textField.text isEqualToString:@"0"]) {
        if (![string isEqualToString:@"."] && ![string isEqualToString:@""]) {
            return NO;
        }
    }
    
    // 第一个字符不能输入0
    if ([string isEqualToString:@"0"] && [textField.text isEqualToString:@"0"]) {
        return NO;
    }
    
    // 如果第一个输入的是点，那么直接变成 0.
    if (textField.text.length == 0 && [string isEqualToString:@"."]) {
        textField.text = @"0";
    }
    
    //限制只能输入：1234567890.
    NSCharacterSet * characterSet = [[NSCharacterSet characterSetWithCharactersInString:@"1234567890."] invertedSet];
    NSString * filtered = [[string componentsSeparatedByCharactersInSet:characterSet] componentsJoinedByString:@""];
    return [string isEqualToString:filtered];
}


@end
