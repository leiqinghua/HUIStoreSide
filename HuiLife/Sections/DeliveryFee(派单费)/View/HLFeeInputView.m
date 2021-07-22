//
//  HLFeeInputView.m
//  HuiLife
//
//  Created by 雷清华 on 2020/5/18.
//

#import "HLFeeInputView.h"


@interface HLFeeInputView () <UITextFieldDelegate>

@property(nonatomic, strong) UILabel *titleLb;
@property(nonatomic, strong) UITextField *textField;
@property(nonatomic, strong) UILabel *tipLb;

@end

@implementation HLFeeInputView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self initSubView];
    }
    return self;
}

- (void)initSubView {
    _tipLb = [[UILabel alloc]init];
    _tipLb.textColor = UIColorFromRGB(0x333333);
    _tipLb.font = [UIFont systemFontOfSize:FitPTScreen(12)];
    _tipLb.text = @"元";
    [self addSubview:_tipLb];
    [_tipLb makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self);
        make.centerY.equalTo(self);
    }];
    
    NSDictionary *attrs = @{NSForegroundColorAttributeName:UIColorFromRGB(0x999999),NSFontAttributeName:[UIFont systemFontOfSize:FitPTScreen(14)]};
    _textField = [[UITextField alloc]init];
    _textField.attributedPlaceholder = [[NSMutableAttributedString alloc]initWithString:@"0.0" attributes:attrs];;
    _textField.keyboardType = UIKeyboardTypeDecimalPad;
    _textField.layer.cornerRadius = FitPTScreen(3);
    _textField.layer.borderColor = UIColorFromRGB(0xD9D9D9).CGColor;
    _textField.layer.borderWidth = 0.5;
    _textField.textAlignment = NSTextAlignmentCenter;
    _textField.font = [UIFont systemFontOfSize:FitPTScreen(14)];
    _textField.textColor = UIColorFromRGB(0x222222);
    _textField.tintColor = UIColorFromRGB(0xFD9E30);
    _textField.delegate = self;
    [self addSubview:_textField];
    [_textField makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(_tipLb.left).offset(FitPTScreen(-5));
        make.centerY.equalTo(self);
        make.size.equalTo(CGSizeMake(FitPTScreen(55), FitPTScreen(30)));
    }];
    [_textField addTarget:self action:@selector(textFieldDidChanged:) forControlEvents:UIControlEventEditingChanged];
    
    _titleLb = [[UILabel alloc]init];
    _titleLb.textColor = UIColorFromRGB(0x333333);
    _titleLb.font = [UIFont systemFontOfSize:FitPTScreen(12)];
    _titleLb.text = @"则加派单费￥";
    [self addSubview:_titleLb];
    [_titleLb makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.textField.left).offset(FitPTScreen(-7));
        make.left.centerY.equalTo(self);
    }];
}

- (void)setTitle:(NSString *)title {
    _title = title;
    _titleLb.text = title;
}

- (void)setText:(NSString *)text {
    _text = text;
    _textField.text = text;
}

- (void)setTip:(NSString *)tip {
    _tipLb.text = tip;
}

- (void)setEnableEdit:(BOOL)enableEdit {
    _enableEdit = enableEdit;
    _textField.enabled = enableEdit;
    if (enableEdit) {
        _textField.backgroundColor = UIColorFromRGB(0xFFFFFF);
        _textField.layer.borderColor = UIColorFromRGB(0xD9D9D9).CGColor;
    } else {
        _textField.backgroundColor = UIColorFromRGB(0xF5F5F5);
        _textField.layer.borderColor = UIColorFromRGB(0xF5F5F5).CGColor;
    }
}

- (void)setInputWidth:(CGFloat)inputWidth {
    _inputWidth = inputWidth;
    [_textField updateConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(inputWidth);
    }];
}

- (void)setInputHight:(CGFloat)inputHight {
    _inputHight = inputHight;
    [_textField updateConstraints:^(MASConstraintMaker *make) {
        make.height.equalTo(inputHight);
    }];
}

- (void)setPlaceHolder:(NSString *)placeHolder {
    _placeHolder = placeHolder;
    NSDictionary *attrs = @{NSForegroundColorAttributeName:UIColorFromRGB(0x999999),NSFontAttributeName:[UIFont systemFontOfSize:FitPTScreen(14)]};
    _textField.attributedPlaceholder = [[NSMutableAttributedString alloc]initWithString:placeHolder attributes:attrs];;
}

- (void)setKeyBoardType:(UIKeyboardType)keyBoardType {
    _textField.keyboardType = keyBoardType;
}

- (void)setTitleAttr:(NSAttributedString *)titleAttr {
    _titleAttr = titleAttr;
    _titleLb.attributedText = titleAttr;
}

- (void)textFieldDidChanged:(UITextField *)textField {
    if ([self.delegate respondsToSelector:@selector(inputView:editText:)]) {
        [self.delegate inputView:self editText:textField.text];
    }
}

#pragma mark - UITextFieldDelegate
- (void)textFieldDidEndEditing:(UITextField *)textField {
    if ([self.delegate respondsToSelector:@selector(inputView:didEndText:)]) {
        [self.delegate inputView:self didEndText:textField];
    }
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    if ([self.delegate respondsToSelector:@selector(inputView:textField:shouldChangeCharactersInRange:replacementString:)]) {
        return [self.delegate inputView:self textField:textField shouldChangeCharactersInRange:range replacementString:string];
    }
    return YES;
}



@end
