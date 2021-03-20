//
//  HLRightBoxInputViewCell.m
//  HuiLife
//
//  Created by 闻喜惠生活 on 2019/8/8.
//

#import "HLRightBoxInputViewCell.h"

@interface HLRightBoxInputViewCell ()

@property (nonatomic, strong) UITextField *textField;

@end

@implementation HLRightBoxInputViewCell

-(void)initSubUI{
    [super initSubUI];
    
    _textField = [[UITextField alloc] init];
    [self.contentView addSubview:_textField];
    _textField.font = [UIFont systemFontOfSize:FitPTScreen(14)];
    _textField.textColor = UIColorFromRGB(0x999999);
    _textField.textAlignment = NSTextAlignmentRight;
    _textField.layer.borderColor = UIColorFromRGB(0xD9D9D9).CGColor;
    _textField.layer.borderWidth = FitPTScreen(1);
    _textField.layer.cornerRadius = FitPTScreen(5);
    _textField.tintColor = UIColorFromRGB(0xff8717);
    [_textField makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(FitPTScreen(-12));
        make.centerY.equalTo(self.contentView);
        make.width.equalTo(FitPTScreen(298));
        make.height.equalTo(FitPTScreen(40));
    }];
    
    
    UIView * rightView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, FitPTScreen(40), FitPTScreen(40))];
    _textField.rightView = rightView;
    _textField.rightViewMode = UITextFieldViewModeAlways;
    
    UIImageView * cancelImv = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"close_x_circle"]];
    cancelImv.frame = CGRectMake(0, 0, 15, 15);
    cancelImv.center = CGPointMake(CGRectGetMaxX(rightView.bounds)/2, CGRectGetMaxY(rightView.bounds)/2);
    [rightView addSubview:cancelImv];
    
    UITapGestureRecognizer * cancelTap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(cancelClick:)];
    [rightView addGestureRecognizer:cancelTap];
    
    [_textField addTarget:self action:@selector(textFieldEditing:) forControlEvents:UIControlEventEditingChanged];
}


-(void)cancelClick:(UITapGestureRecognizer *)sender{
    _textField.text = @"";
    self.baseInfo.text = @"";
}

- (void)textFieldEditing:(UITextField *)sender{
    self.baseInfo.text = sender.text;
}


-(void)setBaseInfo:(HLRightBoxInputInfo *)baseInfo{
    [super setBaseInfo:baseInfo];
    _textField.placeholder = baseInfo.placeHolder;
    _textField.text = baseInfo.text;
}

@end


@implementation HLRightBoxInputInfo

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
