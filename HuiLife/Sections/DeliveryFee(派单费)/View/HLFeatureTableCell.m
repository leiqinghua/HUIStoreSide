//
//  HLFeatureTableCell.m
//  HuiLife
//
//  Created by 雷清华 on 2020/5/20.
//

#import "HLFeatureTableCell.h"
#import "HLFeatureMainInfo.h"

@interface HLFeatureTableCell () <UITextFieldDelegate>

@property(nonatomic, strong) UITextField *textField;

@end

@implementation HLFeatureTableCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self initSubView];
    }
    return self;
}

- (void)initSubView {
    UIView *bagView = [[UIView alloc]init];
    bagView.layer.cornerRadius = FitPTScreen(3);
    bagView.layer.borderColor = UIColorFromRGB(0xD9D9D9).CGColor;
    bagView.layer.borderWidth = 0.5;
    [self.contentView addSubview:bagView];
    [bagView makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(FitPTScreen(13));
        make.right.equalTo(FitPTScreen(-13));
        make.centerY.equalTo(self.contentView);
        make.height.equalTo(FitPTScreen(40));
    }];
    
    UIImageView *tipV = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"tag"]];
    [bagView addSubview:tipV];
    [tipV makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(FitPTScreen(13));
        make.centerY.equalTo(bagView);
    }];
    
    NSDictionary *attrs = @{NSForegroundColorAttributeName:UIColorFromRGB(0x999999),NSFontAttributeName:[UIFont systemFontOfSize:FitPTScreen(14)]};
    _textField = [[UITextField alloc]init];
    _textField.attributedPlaceholder = [[NSMutableAttributedString alloc]initWithString:@"请输入特色标题" attributes:attrs];
    _textField.textColor = UIColorFromRGB(0x222222);
    _textField.font = [UIFont systemFontOfSize:FitPTScreen(14)];
    _textField.delegate = self;
    [bagView addSubview:_textField];
    [_textField makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(FitPTScreen(39));
        make.right.equalTo(FitPTScreen(-39));
        make.centerY.equalTo(bagView);
        make.height.equalTo(FitPTScreen(30));
    }];
    [_textField addTarget:self action:@selector(textFieldDidChanged:) forControlEvents:UIControlEventEditingChanged];
}

- (void)setInfo:(HLFeatureInfo *)info {
    _info = info;
    _textField.text = info.value;
}

- (void)textFieldDidChanged:(UITextField *)textField {
    NSString *toBeString = textField.text;
    // 获取键盘输入模式
    NSString *lang = [[UITextInputMode currentInputMode] primaryLanguage];
    // 中文输入的时候,可能有markedText(高亮选择的文字),需要判断这种状态
    // zh-Hans表示简体中文输入, 包括简体拼音，健体五笔，简体手写
    if ([lang isEqualToString:@"zh-Hans"]) {
         UITextRange *selectedRange = [textField markedTextRange];
        //获取高亮选择部分
        UITextPosition *position = [textField positionFromPosition:selectedRange.start offset:0];
        // 没有高亮选择的字，表明输入结束,则对已输入的文字进行字数统计和限制
        if (!position) {
            if (toBeString.length > 5) {
                // 截取子串
                textField.text = [toBeString substringToIndex:5];
            }
        }
    }else {
         // 中文输入法以外的直接对其统计限制即可，不考虑其他语种情况
        if (toBeString.length > 5) {
            // 截取子串
            textField.text = [toBeString substringToIndex:5];
        }
    }
    _info.value = textField.text;
}

@end
