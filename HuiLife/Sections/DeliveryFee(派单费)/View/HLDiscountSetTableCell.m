//
//  HLDiscountSetTableCell.m
//  HuiLife
//
//  Created by 雷清华 on 2020/5/20.
//

#import "HLDiscountSetTableCell.h"
#import "HLFeeInputView.h"
#import "HLDiscountMainInfo.h"

@interface HLDiscountSetTableCell () <HLFeeInputViewDelegate>

@property(nonatomic, strong) HLFeeInputView *orderInput;
@property(nonatomic, strong) HLFeeInputView *priceInput;
@property(nonatomic, strong) HLFeeInputView *discountInput;
@property(nonatomic, strong) UIButton *optionBtn;

@end

@implementation HLDiscountSetTableCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self initSubView];
    }
    return self;
}

#pragma mark - Event
- (void)optionClick {
    if ([self.delegate respondsToSelector:@selector(discountCell:add:)]) {
        [self.delegate discountCell:self add:_info.add];
    }
}

#pragma mark - setter
- (void)setInfo:(HLDiscountInfo *)info {
    _info = info;
    _orderInput.text = info.start_price;
    _priceInput.text = info.end_price;
    _discountInput.text = info.discount;
    _orderInput.title = info.title;
    _discountInput.title = info.label;
    _discountInput.tip = info.unit;
    if (info.add) {
        [_optionBtn setImage:[UIImage imageNamed:@"add_circle"] forState:UIControlStateNormal];
    } else {
        [_optionBtn setImage:[UIImage imageNamed:@"delete_circle"] forState:UIControlStateNormal];
    }
}

#pragma mark - HLFeeInputViewDelegate
- (void)inputView:(HLFeeInputView *)inputView editText:(NSString *)text {
    
    HLLog(@"text = %@",text);
    
    if ([inputView isEqual:_orderInput]) {
        _info.start_price = text;
    } else if ([inputView isEqual:_priceInput]) {
        _info.end_price = text;
    } else {
        _info.discount = text;
    }
    [_info.pargrams setObject:_info.start_price?:@"" forKey:_info.start_key];
    [_info.pargrams setObject:_info.end_price?:@"" forKey:_info.end_key];
    [_info.pargrams setObject:_info.discount?:@"" forKey:_info.discount_key];
}
//结束编辑
- (void)inputView:(HLFeeInputView *)inputView didEndText:(UITextField *)textField {
   
}

- (BOOL)inputView:(HLFeeInputView *)inputView textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
//    只能输入数字
    NSCharacterSet *characterSet = [[NSCharacterSet characterSetWithCharactersInString:@"0123456789"] invertedSet];
    if ([inputView isEqual:_discountInput]) {
        characterSet = [[NSCharacterSet characterSetWithCharactersInString:@"0123456789."] invertedSet];
    }
    
    //    根据字符集 拆分成数组（如果不是数字，就会拆分成空字符串数组）
    NSArray * arr = [string componentsSeparatedByCharactersInSet:characterSet];
    //    将数组转换为字符串
    NSString *joinString = [arr componentsJoinedByString:@""];
    
    if (![joinString isEqualToString:string]) {
        return NO;
    }
    NSString *text = [textField.text stringByReplacingCharactersInRange:range withString:string];
    if (text.length > 4 && ([inputView isEqual:_orderInput] || [inputView isEqual:_priceInput])) {
        return NO;
    }
    
    if ([inputView isEqual:_discountInput]) {
        if ([text isEqualToString:@"."]) {
            return NO;
        }
        if ([textField.text containsString:@"."] && [string isEqualToString:@"."]) {
            return NO;
        }
        
        if ([text integerValue] > _limitNum) {
            return NO;
        }
    }
    
    return YES;
}

#pragma mark - UIView
- (void)initSubView {
    
    _optionBtn = [[UIButton alloc]init];
    [_optionBtn setImage:[UIImage imageNamed:@"add_circle"] forState:UIControlStateNormal];
    [self.contentView addSubview:_optionBtn];
    [_optionBtn makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(FitPTScreen(-12));
        make.top.equalTo(FitPTScreen(20));
    }];
    [_optionBtn addTarget:self action:@selector(optionClick) forControlEvents:UIControlEventTouchUpInside];
    
    _discountInput = [[HLFeeInputView alloc]init];
    _discountInput.title = @"则享受";
    _discountInput.tip = @"折";
    _discountInput.placeHolder = @"0.0";
    _discountInput.inputWidth = FitPTScreen(41);
    _discountInput.inputHight = FitPTScreen(35);
    _discountInput.delegate = self;
    [self.contentView addSubview:_discountInput];
    [_discountInput makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.optionBtn.left).offset(FitPTScreen(-15));
        make.centerY.equalTo(self.optionBtn);
        make.height.equalTo(FitPTScreen(40));
    }];
    
    _priceInput = [[HLFeeInputView alloc]init];
    _priceInput.delegate = self;
    _priceInput.title = @" ~ ";
    _priceInput.tip = @"";
    _priceInput.placeHolder = @"0";
    _priceInput.keyBoardType = UIKeyboardTypeNumberPad;
    _priceInput.inputWidth = FitPTScreen(41);
    _priceInput.inputHight = FitPTScreen(35);
    [self.contentView addSubview:_priceInput];
    [_priceInput makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.discountInput.left);
        make.centerY.equalTo(self.optionBtn);
        make.height.equalTo(FitPTScreen(40));
    }];

    _orderInput = [[HLFeeInputView alloc]init];
    _orderInput.delegate = self;
    _orderInput.tip = @" ";
    _orderInput.keyBoardType = UIKeyboardTypeNumberPad;
    _orderInput.placeHolder = @"0";
    _orderInput.inputWidth = FitPTScreen(41);
    _orderInput.inputHight = FitPTScreen(35);
    [self.contentView addSubview:_orderInput];
    [_orderInput makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.priceInput.left);
        make.centerY.equalTo(self.optionBtn);
        make.height.equalTo(FitPTScreen(40));
    }];
}


@end
