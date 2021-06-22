//
//  HLRightInputViewCell.m
//  HuiLife
//
//  Created by 王策 on 2019/8/2.
//

#import "HLRightInputViewCell.h"

@interface HLRightInputViewCell () <UITextFieldDelegate>

@property (nonatomic, strong) UILabel *rightTipLab;

@property (nonatomic, strong) UILabel *showLab;

@end

@implementation HLRightInputViewCell

- (void)initSubUI{
    
    [super initSubUI];
    
    _rightTipLab = [[UILabel alloc] init];
    [self.contentView addSubview:_rightTipLab];
    _rightTipLab.textColor = UIColorFromRGB(0x666666);
    _rightTipLab.font = [UIFont systemFontOfSize:FitPTScreen(14)];
    [_rightTipLab makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.contentView);
        make.right.equalTo(FitPTScreen(-13));
    }];
    
    _textField = [[UITextField alloc] init];
    _textField.tintColor = UIColorFromRGB(0xff8717);
    [self.contentView addSubview:_textField];
    _textField.font = [UIFont systemFontOfSize:FitPTScreen(14)];
    _textField.textColor = UIColorFromRGB(0x333333);
    _textField.textAlignment = NSTextAlignmentRight;
    [_textField makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.equalTo(0);
        make.left.equalTo(FitPTScreen(115));
        make.right.equalTo(FitPTScreen(-20));
    }];
    _textField.delegate = self;
    [_textField addTarget:self action:@selector(textFieldEditing:) forControlEvents:UIControlEventEditingChanged];
    
    _arrowImgV = [[UIImageView alloc] init];
    [self.contentView addSubview:_arrowImgV];
    _arrowImgV.image = [UIImage imageNamed:@"arrow_right_grey"];
    _arrowImgV.contentMode = UIViewContentModeScaleAspectFit;
    _arrowImgV.clipsToBounds = YES;
    _arrowImgV.userInteractionEnabled = YES;
    [_arrowImgV makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(FitPTScreen(-13));
        make.centerY.equalTo(self.textField);
        make.width.equalTo(FitPTScreen(15));
        make.height.equalTo(FitPTScreen(15));
    }];
    UITapGestureRecognizer *rightTap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(rightImgClick)];
    [_arrowImgV addGestureRecognizer:rightTap];
    
    
    
    _showLab = [[UILabel alloc] init];
    [self.contentView addSubview:_showLab];
    _showLab.font = [UIFont systemFontOfSize:FitPTScreen(14)];
    _showLab.textColor = UIColorFromRGB(0x333333);
    _showLab.numberOfLines = 2;
    _showLab.textAlignment = NSTextAlignmentRight;
    [_showLab makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.equalTo(0);
        make.left.equalTo(FitPTScreen(115));
        make.right.equalTo(_arrowImgV.left).offset(FitPTScreen(-12));
    }];
    _showLab.hidden = YES;
}


- (void)rightImgClick {
    HLRightInputTypeInfo *info = (HLRightInputTypeInfo *)self.baseInfo;
    if (!info.rightClick) {
        return;
    }
    if ([self.delegate respondsToSelector:@selector(inputViewCell:rightImgClick:)]) {
        [self.delegate inputViewCell:self rightImgClick:(HLRightInputTypeInfo *)self.baseInfo];
    }
}

- (void)textFieldEditing:(UITextField *)sender{
    
    HLRightInputTypeInfo *info = (HLRightInputTypeInfo *)self.baseInfo;
    if (info.maxInputNum > 0 && info.minInputNum >= 0 && sender.text.length > 0) {
        if (sender.text.doubleValue > info.maxInputNum) {
            sender.text = [NSString stringWithFormat:@"%ld",info.maxInputNum];
        }
        if (sender.text.doubleValue < info.minInputNum) {
            sender.text = [NSString stringWithFormat:@"%ld",info.minInputNum];
        }
    }
    
    self.baseInfo.text = sender.text;
    if ([self.delegate respondsToSelector:@selector(inputViewCell:textChanged:)]) {
        [self.delegate inputViewCell:self textChanged:(HLRightInputTypeInfo *)self.baseInfo];
    }
}


- (void)setBaseInfo:(HLRightInputTypeInfo *)baseInfo {
    [super setBaseInfo:baseInfo];
    
    _arrowImgV.hidden = !baseInfo.showRightArrow;
    _arrowImgV.image = baseInfo.rightImage ?: [UIImage imageNamed:@"arrow_right_grey"];
    
    if (baseInfo.enabled) {
        _textField.enabled = baseInfo.canInput;
    }else{
        _textField.enabled = NO;
    }
    
    _textField.keyboardType = baseInfo.keyBoardType;
    _rightTipLab.hidden = baseInfo.rightText.length == 0;
    
    if (baseInfo.showRightArrow) {
        _textField.text = baseInfo.text;
        _textField.placeholder = baseInfo.placeHoder;
        [_textField remakeConstraints:^(MASConstraintMaker *make) {
            make.top.bottom.equalTo(0);
            make.left.equalTo(FitPTScreen(110));
            make.right.equalTo(self.arrowImgV.left).offset(-5);
        }];
        
    } else {
        _showLab.hidden = YES;
        _textField.hidden = NO;
        _textField.placeholder = baseInfo.placeHoder;
        _textField.text = baseInfo.text;
        _rightTipLab.text = baseInfo.rightText;
        [_textField remakeConstraints:^(MASConstraintMaker *make) {
            make.top.bottom.equalTo(0);
            make.left.equalTo(FitPTScreen(115));
            make.right.equalTo(baseInfo.rightText.length ? FitPTScreen(-35) : FitPTScreen(-20));
        }];
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
    
    // 第一个字符不能输入0
    if (![(HLRightInputTypeInfo *)self.baseInfo canInputZero] && textField.text.length == 0 && [string isEqualToString:@"0"]) {
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

@implementation HLRightInputTypeInfo

-(BOOL)checkParamsIsOk{
    if (!self.needCheckParams) {
        return YES;
    }
    
    if (self.text.length == 0 && self.mParams.count == 0) {
        return NO;
    }
    
    return YES;
}

@end
