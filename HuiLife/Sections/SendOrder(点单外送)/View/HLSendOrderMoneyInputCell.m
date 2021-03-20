//
//  HLSendOrderMoneyInputCell.m
//  HuiLife
//
//  Created by 王策 on 2019/8/9.
//

#import "HLSendOrderMoneyInputCell.h"

@interface HLSendOrderMoneyInputCell () <UITextFieldDelegate>

@property (nonatomic, strong) UILabel *tipLab;
@property (nonatomic, strong) UIButton *delBtn;

@property (nonatomic, strong) UILabel *startTipLab;
@property (nonatomic, strong) UITextField *startInput;

@property (nonatomic, strong) UILabel *endTipLab;
@property (nonatomic, strong) UITextField *endInput;

@property (nonatomic, strong) UILabel *sendTipLab;
@property (nonatomic, strong) UITextField *sendInput;

@property (nonatomic, strong) UIView *bottomLine;

@end

@implementation HLSendOrderMoneyInputCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self initSubUI];
    }
    return self;
}

- (void)initSubUI{
    
    self.tipLab = [[UILabel alloc] init];
    [self.contentView addSubview:self.tipLab];
    self.tipLab.font = [UIFont systemFontOfSize:FitPTScreen(14)];
    self.tipLab.textColor = UIColorFromRGB(0x222222);
    self.tipLab.text = @"配送费";
    [self.tipLab makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(FitPTScreen(16));
        make.top.equalTo(FitPTScreen(19));
    }];
    
    _delBtn = [[UIButton alloc] init];
    [self.contentView addSubview:_delBtn];
    [_delBtn setTitle:@"删除" forState:UIControlStateNormal];
    [_delBtn setTitleColor:UIColorFromRGB(0xFF8E16) forState:UIControlStateNormal];
    _delBtn.titleLabel.font = [UIFont systemFontOfSize:FitPTScreen(13)];
    [_delBtn makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.tipLab.bottom);
        make.centerX.equalTo(self.tipLab);
        make.height.equalTo(FitPTScreen(30));
        make.width.equalTo(FitPTScreen(80));
    }];
    [_delBtn addTarget:self action:@selector(delBtnClick) forControlEvents:UIControlEventTouchUpInside];
    
    _endInput = [[UITextField alloc] init];
    [self.contentView addSubview:_endInput];
    _endInput.font = [UIFont systemFontOfSize:FitPTScreen(14)];
    _endInput.textColor = UIColorFromRGB(0x222222);
    _endInput.textAlignment = NSTextAlignmentCenter;
    _endInput.placeholder = @"¥金额";
    _endInput.delegate = self;
    _endInput.keyboardType = UIKeyboardTypeDecimalPad;
    [_endInput makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(FitPTScreen(0));
        make.right.equalTo(FitPTScreen(0));
        make.height.equalTo(FitPTScreen(53));
        make.width.equalTo(FitPTScreen(60));
    }];
    [_endInput addTarget:self action:@selector(endInputEdit:) forControlEvents:UIControlEventEditingChanged];
    
    self.endTipLab = [[UILabel alloc] init];
    [self.contentView addSubview:self.endTipLab];
    self.endTipLab.font = [UIFont systemFontOfSize:FitPTScreen(14)];
    self.endTipLab.textColor = UIColorFromRGB(0x222222);
    self.endTipLab.text = @"至";
    [self.endTipLab makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(_endInput.left).offset(FitPTScreen(-4));
        make.centerY.equalTo(self.tipLab);
    }];
    
    _startInput = [[UITextField alloc] init];
    [self.contentView addSubview:_startInput];
    _startInput.font = [UIFont systemFontOfSize:FitPTScreen(14)];
    _startInput.textColor = UIColorFromRGB(0x222222);
    _startInput.textAlignment = NSTextAlignmentCenter;
    _startInput.placeholder = @"¥金额";
    _startInput.delegate = self;
    _startInput.keyboardType = UIKeyboardTypeDecimalPad;
    [_startInput makeConstraints:^(MASConstraintMaker *make) {
        make.top.height.equalTo(_endInput);
        make.right.equalTo(_endTipLab.left).offset(FitPTScreen(-4));
        make.width.equalTo(FitPTScreen(60));
    }];
    [_startInput addTarget:self action:@selector(startInputEdit:) forControlEvents:UIControlEventEditingChanged];
    
    self.startTipLab = [[UILabel alloc] init];
    [self.contentView addSubview:self.startTipLab];
    self.startTipLab.font = [UIFont systemFontOfSize:FitPTScreen(14)];
    self.startTipLab.textColor = UIColorFromRGB(0x222222);
    self.startTipLab.text = @"消费";
    [self.startTipLab makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(_startInput.left).offset(FitPTScreen(-4));
        make.centerY.equalTo(self.tipLab);
    }];
    
    UIView *line = [[UIView alloc] init];
    [self.contentView addSubview:line];
    line.backgroundColor = SeparatorColor;
    [line makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(FitPTScreen(195));
        make.right.equalTo(0);
        make.height.equalTo(0.5);
        make.top.equalTo(_startInput.bottom);
    }];
    
    _sendInput = [[UITextField alloc] init];
    [self.contentView addSubview:_sendInput];
    _sendInput.font = [UIFont systemFontOfSize:FitPTScreen(14)];
    _sendInput.textColor = UIColorFromRGB(0x222222);
    _sendInput.textAlignment = NSTextAlignmentLeft;
    _sendInput.placeholder = @"¥配送金额";
    _sendInput.delegate = self;
    _sendInput.keyboardType = UIKeyboardTypeDecimalPad;
    [_sendInput makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(line.bottom);
        make.right.equalTo(FitPTScreen(0));
        make.bottom.equalTo(FitPTScreen(0));
        make.width.equalTo(FitPTScreen(122));
    }];
    [_sendInput addTarget:self action:@selector(sendInputEdit:) forControlEvents:UIControlEventEditingChanged];
    
    self.sendTipLab = [[UILabel alloc] init];
    [self.contentView addSubview:self.sendTipLab];
    self.sendTipLab.font = [UIFont systemFontOfSize:FitPTScreen(14)];
    self.sendTipLab.textColor = UIColorFromRGB(0x222222);
    self.sendTipLab.text = @"配送费";
    [self.sendTipLab makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(_sendInput.left).offset(FitPTScreen(-11));
        make.centerY.equalTo(_sendInput);
    }];
    
    _bottomLine = [[UIView alloc] init];
    [self.contentView addSubview:_bottomLine];
    _bottomLine.backgroundColor = SeparatorColor;
    [_bottomLine makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(FitPTScreen(15));
        make.right.equalTo(0);
        make.height.equalTo(0.5);
        make.bottom.equalTo(0);
    }];
}

- (void)delBtnClick{
    if (self.delegate) {
        [self.delegate inputCell:self deleteInputInfo:self.inputInfo];
    }
}

- (void)endInputEdit:(UITextField *)sender{
    self.inputInfo.endMoneyText = sender.text;
}

- (void)sendInputEdit:(UITextField *)sender{
    self.inputInfo.sendMoneyText = sender.text;
}

- (void)startInputEdit:(UITextField *)sender{
    self.inputInfo.startMoneyText = sender.text;
}

-(void)setIndex:(NSInteger)index{
    _index = index;
    _delBtn.hidden = index == 0;
    _tipLab.text = [NSString stringWithFormat:@"配送费%@",index > 0 ? [NSString stringWithFormat:@"%ld",index + 1] : @""];
}

-(void)setInputInfo:(HLSendOrderMoneyInputInfo *)inputInfo{
    _inputInfo = inputInfo;
    _startInput.text = inputInfo.startMoneyText;
    _endInput.text = inputInfo.endMoneyText;
    _sendInput.text = inputInfo.sendMoneyText;
}

-(void)textFieldDidEndEditing:(UITextField *)textField{
    if ([textField.text hasSuffix:@"."]) {
        textField.text = [textField.text stringByReplacingOccurrencesOfString:@"." withString:@""];
    }
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    
    if (textField.keyboardType != UIKeyboardTypeDecimalPad) {
        return YES;
    }
    
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
