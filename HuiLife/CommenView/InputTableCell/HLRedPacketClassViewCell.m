//
//  HLRedPacketClassViewCell.m
//  HuiLife
//
//  Created by 王策 on 2021/3/23.
//

#import "HLRedPacketClassViewCell.h"

@implementation HLRedPacketClassInfo

- (CGFloat)cellHeight{
    return FitPTScreen(47) + (self.showBottomPlace ? FitPTScreen(9) : 0) + (self.showTopPlace ? FitPTScreen(9) : 0);
}

@end

@interface HLRedPacketClassViewCell () <UITextFieldDelegate>

@property (nonatomic, strong) UIView *topPlaceV;
@property (nonatomic, strong) UIView *centerV;
@property (nonatomic, strong) UITextField *textField;
@property (nonatomic, strong) UIView *bottomPlaceV;

@end

@implementation HLRedPacketClassViewCell

- (void)initSubUI{
    [super initSubUI];
    
    self.contentView.clipsToBounds = YES;
    
    self.topPlaceV = [[UIView alloc] init];
    [self.contentView addSubview:self.topPlaceV];
    self.topPlaceV.backgroundColor = UIColorFromRGB(0xF8F8F8);
    [self.topPlaceV makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(0);
        make.top.equalTo(0);
        make.height.equalTo(FitPTScreen(9));
    }];
    
    self.centerV = [[UIView alloc] init];
    [self.contentView addSubview:self.centerV];
    self.centerV.backgroundColor = UIColorFromRGB(0xFFFFFF);
    [self.centerV makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.topPlaceV.bottom);
        make.height.equalTo(FitPTScreen(47));
        make.left.right.equalTo(0);
    }];
    
    self.bottomPlaceV = [[UIView alloc] init];
    [self.contentView addSubview:self.bottomPlaceV];
    self.bottomPlaceV.backgroundColor = UIColorFromRGB(0xF8F8F8);
    [self.bottomPlaceV makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(0);
        make.top.equalTo(self.centerV.bottom);
        make.height.equalTo(FitPTScreen(9));
    }];
    
    UILabel *percentLab = [[UILabel alloc] init];
    percentLab.text = @"%";
    percentLab.font = [UIFont systemFontOfSize:FitPTScreen(12)];
    percentLab.textColor = UIColorFromRGB(0x555555);
    [percentLab sizeToFit];
    [self.centerV addSubview:percentLab];
    [percentLab makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.centerV);
        make.right.equalTo(FitPTScreen(-12));
    }];
    
    _textField = [[UITextField alloc] init];
    [self.centerV addSubview:_textField];
    _textField.font = [UIFont systemFontOfSize:FitPTScreen(15)];
    _textField.textColor = UIColorFromRGB(0x333333);
    _textField.placeholder = @"0";
    _textField.textAlignment = NSTextAlignmentCenter;
    _textField.layer.borderColor = UIColorFromRGB(0xEDEDED).CGColor;
    _textField.layer.cornerRadius = FitPTScreen(2);
    _textField.layer.borderWidth = FitPTScreen(0.5);
    _textField.layer.masksToBounds = YES;
    _textField.keyboardType = UIKeyboardTypeNumberPad;
    [_textField makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.centerV);
        make.right.equalTo(percentLab.left).offset(FitPTScreen(-10));
        make.width.equalTo(FitPTScreen(81));
        make.height.equalTo(FitPTScreen(30));
    }];
    _textField.delegate = self;
    [_textField addTarget:self action:@selector(textFieldEditing:) forControlEvents:UIControlEventEditingChanged];
    
    UILabel *tipLab = [[UILabel alloc] init];
    tipLab.text = @"可用";
    tipLab.font = [UIFont systemFontOfSize:FitPTScreen(12)];
    tipLab.textColor = UIColorFromRGB(0x555555);
    [tipLab sizeToFit];
    [self.centerV addSubview:tipLab];
    [tipLab makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.centerV);
        make.right.equalTo(self.textField.left).offset(FitPTScreen(-10));
    }];
    
    [self.leftTipLab removeFromSuperview];
    [self.centerV addSubview:self.leftTipLab];
    [self.leftTipLab remakeConstraints:^(MASConstraintMaker *make) {
        make.right.lessThanOrEqualTo(percentLab.left).offset(3);
        make.left.equalTo(FitPTScreen(12));
        make.centerY.equalTo(self.centerV);
    }];
}

- (void)textFieldEditing:(UITextField *)sender{
    if (sender.text.intValue > 100) {
        sender.text = [NSString stringWithFormat:@"100"];
    }
    if ([sender.text isEqualToString:@"0"]) {
        sender.text = @"";
    }
    HLRedPacketClassInfo *info = (HLRedPacketClassInfo *)self.baseInfo;
    info.text = sender.text;
}

- (void)setBaseInfo:(HLBaseTypeInfo *)baseInfo{
    [super setBaseInfo:baseInfo];
    self.leftTipLab.font = [UIFont systemFontOfSize:FitPTScreen(12)];
    self.leftTipLab.textColor = UIColorFromRGB(0x555555);
    HLRedPacketClassInfo *info = (HLRedPacketClassInfo *)baseInfo;
    self.textField.text = info.text;
    
    self.bottomPlaceV.hidden = !info.showBottomPlace;
    self.topPlaceV.hidden = !info.showTopPlace;
    if (info.showTopPlace) {
        [self.topPlaceV updateConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(0);
        }];
    }else{
        [self.topPlaceV updateConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(FitPTScreen(-9));
        }];
    }
    self.separatorInset = UIEdgeInsetsMake(0, ScreenW, 0, 0);
}

#pragma mark - UITextFieldDelegate

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    
    //限制只能输入：1234567890.
    NSCharacterSet * characterSet = [[NSCharacterSet characterSetWithCharactersInString:@"1234567890"] invertedSet];
    NSString * filtered = [[string componentsSeparatedByCharactersInSet:characterSet] componentsJoinedByString:@""];
    return [string isEqualToString:filtered];
}


@end
