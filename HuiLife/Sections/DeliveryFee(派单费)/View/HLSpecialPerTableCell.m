//
//  HLSpecialPerTableCell.m
//  HuiLife
//
//  Created by 雷清华 on 2020/5/19.
//

#import "HLSpecialPerTableCell.h"

@interface HLSpecialPerTableCell () <UITextFieldDelegate>

@property(nonatomic, strong) UITextField *textField;
@property(nonatomic, strong) UILabel *nameLb;
@property(nonatomic, strong) UIView *optionBtn;
@property(nonatomic, strong) UIImageView *optionV;

@end

@implementation HLSpecialPerTableCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self initSubView];
    }
    return self;
}

#pragma mark - Event
- (void)optionClick:(UITapGestureRecognizer *)sender {
    [self.textField endEditing:YES];
    if ([self.delegate respondsToSelector:@selector(perCell:add:)]) {
        [self.delegate perCell:self add:_specialPer.add];
    }
}


#pragma mark - Method
//清空
- (void)clearAllNums {
    _specialPer.mobileText = @"";
    _specialPer.mobile = @"";
    _specialPer.is_authenticate = NO;
    _specialPer.tipStr = @"";
    _nameLb.text = @"";
    _nameLb.textColor = UIColorFromRGB(0x222222);
    _textField.textColor = UIColorFromRGB(0x222222);
}

#pragma mark - setter
- (void)setSpecialPer:(HLSpecialPeron *)specialPer {
    _specialPer = specialPer;
    _textField.text = specialPer.mobileText?:@"";
    if (specialPer.is_authenticate) { //验证通过的
        _nameLb.text = specialPer.authenticate_name;
        _nameLb.textColor = UIColorFromRGB(0x222222);
        _textField.textColor = UIColorFromRGB(0x222222);
    } else {
        _nameLb.text = specialPer.tipStr;
        _nameLb.textColor = UIColorFromRGB(0xFF3C3C);
        _textField.textColor = specialPer.mobileText.length?UIColorFromRGB(0xFF3C3C):UIColorFromRGB(0x222222);
    }
    _optionV.image = [UIImage imageNamed:specialPer.add?@"add_black":@"delete_black"];
}

#pragma mark - UITextFieldDelegate
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    //    数字以外的字符集
    //    NSCharacterSet *characterSet = [[NSCharacterSet decimalDigitCharacterSet] invertedSet];
    NSCharacterSet *characterSet = [[NSCharacterSet characterSetWithCharactersInString:@"0123456789\b"] invertedSet];
    //    根据字符集 拆分成数组（如果不是数字，就会拆分成空字符串数组）
    NSArray * arr = [string componentsSeparatedByCharactersInSet:characterSet];
    //    将数组转换为字符串
    NSString *joinString = [arr componentsJoinedByString:@""];
    
    if (![joinString isEqualToString:string]) {
        return NO;
    }
    //    限制11位，并且格式化手机号
    NSString *text = [textField.text stringByReplacingCharactersInRange:range withString:string];
    //    先清空所有的空格
    text = [text stringByReplacingOccurrencesOfString:@" " withString:@""];
    
    if (!text.length) { //清空的时候
        [self clearAllNums];
    }
    
    //    在第一个位置插入一个空格
    NSMutableString *mutString = [NSMutableString stringWithString:text];
    [mutString insertString:@" " atIndex:0];
    text = mutString;
    
    NSString *newString = @"";
    while (text.length > 0) {
        NSString *subString = [text substringToIndex:MIN(text.length, 4)];
        newString = [newString stringByAppendingString:subString];
        if (subString.length == 4) {
            newString = [newString stringByAppendingString:@" "];
        }
        text = [text substringFromIndex:MIN(text.length, 4)];
    }
    //    去除前面的空格
    newString = [newString stringByTrimmingCharactersInSet:characterSet];
    if (newString.length >= 14) {
        return NO;
    }
    
    [textField setText:newString];
    
    return NO;
}

//结束编辑
- (void)textFieldDidEndEditing:(UITextField *)textField {
    NSCharacterSet *characterSet = [[NSCharacterSet characterSetWithCharactersInString:@"0123456789\b"] invertedSet];
    //    根据字符集 拆分成数组（如果不是数字，就会拆分成空字符串数组）
    NSArray * arr = [textField.text componentsSeparatedByCharactersInSet:characterSet];
    //    将数组转换为字符串
    NSString *joinString = [arr componentsJoinedByString:@""];
    NSString *phoneNum = [joinString stringByReplacingOccurrencesOfString:@" " withString:@""];
    if ([self.delegate respondsToSelector:@selector(perCell:phoneNum:showNum:)]) {
        [self.delegate perCell:self phoneNum:phoneNum showNum:textField.text];
    }
}
//开始编辑
- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField {
    if (!textField.text.length) {
        [self clearAllNums];
    }
    return YES;
}
#pragma mark - UIView
- (void)initSubView {
    UIView *bagView = [[UIView alloc]init];
    bagView.layer.cornerRadius = FitPTScreen(6);
    bagView.layer.borderColor = UIColorFromRGB(0xD9D9D9).CGColor;
    bagView.layer.borderWidth = 0.5;
    [self.contentView addSubview:bagView];
    [bagView makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(FitPTScreen(12));
        make.centerY.equalTo(self.contentView);
        make.size.equalTo(CGSizeMake(FitPTScreen(149), FitPTScreen(41)));
    }];
    
    NSDictionary *attrs = @{NSForegroundColorAttributeName:UIColorFromRGB(0x999999),NSFontAttributeName:[UIFont systemFontOfSize:FitPTScreen(14)]};
    _textField = [[UITextField alloc]init];
    _textField.attributedPlaceholder = [[NSMutableAttributedString alloc]initWithString:@"请输入手机号" attributes:attrs];
    _textField.textColor = UIColorFromRGB(0x222222);
    _textField.font = [UIFont systemFontOfSize:FitPTScreen(14)];
    _textField.delegate = self;
    _textField.keyboardType = UIKeyboardTypeNumberPad;
    [bagView addSubview:_textField];
    
    
    UIView *leftView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, FitPTScreen(22), FitPTScreen(35))];
    
    UIImageView *tipImV = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"user"]];
    tipImV.center = CGPointMake(CGRectGetMidX(leftView.bounds), CGRectGetMidY(leftView.bounds));
    [leftView addSubview:tipImV];
    
    _textField.leftView = leftView;
    _textField.leftViewMode = UITextFieldViewModeAlways;
    
    [_textField makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(FitPTScreen(6));
        make.centerY.equalTo(bagView);
        make.width.equalTo(FitPTScreen(130));
        make.height.equalTo(FitPTScreen(35));
    }];
    
    _nameLb = [[UILabel alloc]init];
    _nameLb.textColor = UIColorFromRGB(0x222222);
    _nameLb.font = [UIFont systemFontOfSize:FitPTScreen(12)];
    [self addSubview:_nameLb];
    [_nameLb makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(bagView.right).offset(FitPTScreen(9));
        make.centerY.equalTo(self.contentView);
    }];
    
    _optionBtn = [[UIView alloc]init];
    _optionBtn.layer.cornerRadius = FitPTScreen(6);
    _optionBtn.layer.borderColor = UIColorFromRGB(0xD9D9D9).CGColor;
    _optionBtn.layer.borderWidth = 0.5;
    [self.contentView addSubview:_optionBtn];
    [_optionBtn makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(-FitPTScreen(12));
        make.centerY.equalTo(self.contentView);
        make.size.equalTo(CGSizeMake(FitPTScreen(42), FitPTScreen(41)));
    }];
    
    _optionV = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"add_black"]];
    [self.optionBtn addSubview:_optionV];
    [_optionV makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.centerX.equalTo(self.optionBtn);
    }];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(optionClick:)];
    [_optionBtn addGestureRecognizer:tap];
}


@end
