//
//  HLBuyCardListViewCell.m
//  HuiLife
//
//  Created by 王策 on 2021/3/20.
//

#import "HLBuyCardListViewCell.h"

@implementation HLBuyCardListViewModel

@end

@interface HLBuyCardListViewCell () <UITextFieldDelegate>

@property (nonatomic, strong) UILabel *tipLab;
@property (nonatomic, strong) UITextField *textField;

@end

@implementation HLBuyCardListViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self creatSubViews];
        self.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    return self;
}

- (void)creatSubViews{
    
    self.tipLab = [[UILabel alloc] init];
    [self.contentView addSubview:self.tipLab];
    self.tipLab.font = [UIFont systemFontOfSize:FitPTScreen(14)];
    self.tipLab.textColor = [UIColor hl_StringToColor:@"#666666"];
    [self.tipLab makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.contentView);
        make.left.equalTo(FitPTScreen(12.5));
        make.width.mas_lessThanOrEqualTo(FitPTScreen(90));
    }];
    
    self.textField = [[UITextField alloc] init];
    [self.contentView addSubview:self.textField];
    self.textField.delegate = self;
    self.textField.textAlignment = NSTextAlignmentRight;
    self.textField.font = [UIFont systemFontOfSize:FitPTScreen(14)];
    self.textField.textColor = [UIColor hl_StringToColor:@"#333333"];
    [self.textField makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.tipLab.right).offset(FitPTScreen(5));
        make.top.bottom.equalTo(0);
        make.right.equalTo(FitPTScreen(-12));
    }];
    [self.textField addTarget:self action:@selector(textFieldChanged:) forControlEvents:UIControlEventEditingChanged];
}

- (void)textFieldChanged:(UITextField *)sender{
    self.listModel.inputValue = sender.text;
    
    if (self.delegate) {
        [self.delegate cardListViewCell:self editWithListModel:self.listModel];
    }
}

- (void)setListModel:(HLBuyCardListViewModel *)listModel{
    _listModel = listModel;
    self.tipLab.text = listModel.tip;
    self.textField.enabled = listModel.canEdit;
    self.textField.keyboardType = listModel.keyboardType;
    self.textField.placeholder = listModel.placeHolder;
    self.textField.text = listModel.inputValue;
}

- (void)changeEditState{
    [self.textField becomeFirstResponder];
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


