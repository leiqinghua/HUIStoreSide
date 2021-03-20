//
//  HLAddressSearchView.m
//  HuiLife
//
//  Created by 王策 on 2019/9/29.
//

#import "HLAddressSearchView.h"

@interface HLAddressSearchView ()

@property (nonatomic, strong) UIView *inputView;
@property (nonatomic, strong) UITextField *textField;

@end

@implementation HLAddressSearchView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self creatSubViews];
    }
    return self;
}

- (void)creatSubViews{
    
    self.backgroundColor = UIColorFromRGB(0xFAFAFA);
    
    _inputView = [[UIView alloc] init];
    [self addSubview:_inputView];
    _inputView.backgroundColor = UIColor.whiteColor;
    _inputView.layer.cornerRadius = FitPTScreen(8);
    _inputView.layer.masksToBounds = YES;
    [_inputView makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self);
        make.left.equalTo(12);
        make.right.equalTo(-12);
        make.height.equalTo(FitPTScreen(35));
    }];
    
    UIImageView *imageView = [[UIImageView alloc] init];
    [_inputView addSubview:imageView];
    imageView.image = [UIImage imageNamed:@"search_darkGrey"];
    [imageView makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self);
        make.left.equalTo(FitPTScreen(11));
        make.height.width.equalTo(FitPTScreen(14));
    }];
    
    _textField = [[UITextField alloc] init];
    [_inputView addSubview:_textField];
    _textField.placeholder = @"请输入您的店铺地址";
    _textField.font = [UIFont systemFontOfSize:FitPTScreen(14)];
    _textField.textColor = UIColorFromRGB(0x222222);
    _textField.clearButtonMode = UITextFieldViewModeAlways;
    [_textField makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(imageView.right).offset(FitPTScreen(10));
        make.top.bottom.equalTo(0);
        make.right.equalTo(FitPTScreen(-10));
    }];
    [_textField addTarget:self action:@selector(textFieldEditing:) forControlEvents:UIControlEventEditingChanged];
}

- (void)textFieldEditing:(UITextField *)sender{
    if (self.delegate) {
        //获取是否有高亮
        UITextRange *selectedRange = [sender markedTextRange];
        BOOL canSearch = !selectedRange;
        [self.delegate searchView:self editChanged:sender.text canSearch:canSearch];
    }
}

- (NSString *)inputText{
    return _textField.text ?: @"";
}

@end
