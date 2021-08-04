//
//  HLSotreBuyCodeViewCell.m
//  HuiLife
//
//  Created by 王策 on 2019/9/3.
//

#import "HLSotreBuyCodeViewCell.h"

@interface HLSotreBuyCodeViewCell ()

@property (nonatomic, strong) UIImageView *tipImgV;
@property (nonatomic, strong) UITextField *textField;

@end

@implementation HLSotreBuyCodeViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self initSubUI];
    }
    return self;
}

- (void)initSubUI{
    
    _tipImgV = [[UIImageView alloc] init];
    [self.contentView addSubview:_tipImgV];
    [_tipImgV makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(FitPTScreen(15));
        make.height.width.equalTo(FitPTScreen(15));
        make.right.equalTo(FitPTScreen(-30));
    }];
    _tipImgV.hidden = YES;
    
    UIView *inputView = [[UIView alloc] init];
    [self.contentView addSubview:inputView];
    inputView.layer.borderColor = UIColorFromRGB(0xE5E5E5).CGColor;
    inputView.layer.borderWidth = 0.7;
    inputView.layer.cornerRadius = FitPTScreen(4);
    inputView.layer.masksToBounds = YES;
    [inputView makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(FitPTScreen(45));
        make.right.equalTo(_tipImgV.left).offset(FitPTScreen(-12));
        make.height.equalTo(FitPTScreen(44));
        make.top.equalTo(0);
    }];
    
    UIImageView *imageV = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"buy_store_mima"]];
    [inputView addSubview:imageV];
    [imageV makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(FitPTScreen(11));
        make.width.equalTo(FitPTScreen(11));
        make.height.equalTo(FitPTScreen(13));
        make.centerY.equalTo(inputView);
    }];
    
    UITextField *textField = [[UITextField alloc] init];
    [inputView addSubview:textField];
    textField.font = [UIFont systemFontOfSize:FitPTScreen(14)];
    textField.textColor = UIColorFromRGB(0x333333);
    textField.placeholder = @"请输入商+号充值密码";
    textField.keyboardType = UIKeyboardTypeNumberPad;
    [textField makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.equalTo(0);
        make.left.equalTo(FitPTScreen(32));
        make.right.equalTo(FitPTScreen(-10));
    }];
    _textField = textField;
    [_textField addTarget:self action:@selector(textFieldEdit:) forControlEvents:UIControlEventEditingChanged];
}

- (void)textFieldEdit:(UITextField *)sender{
    self.codeInfo.password = sender.text;
}

-(void)setCodeInfo:(HLSotreBuyCodeInfo *)codeInfo{
    _codeInfo = codeInfo;
    _textField.text = codeInfo.password;
    _tipImgV.hidden = codeInfo.isRight == nil;
    _tipImgV.image = [UIImage imageNamed:codeInfo.isRight.integerValue == 1 ? @"success_light_green" : @"error_red"];
}

@end
