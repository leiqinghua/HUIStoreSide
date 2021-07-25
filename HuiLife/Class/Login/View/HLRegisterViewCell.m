//
//  HLRegisterViewCell.m
//  HuiLife
//
//  Created by 雷清华 on 2019/8/27.
//

#import "HLRegisterViewCell.h"

@interface HLRegisterViewCell ()

@property(nonatomic,strong)UIImageView * leftImgV;

@property(nonatomic,strong)UILabel * leftLb;

@property(nonatomic,strong)UILabel * tipLb;
//phone_tip
@property(nonatomic,strong)UIImageView * tipView;

@property(nonatomic,strong)UITextField * textField;

@property(nonatomic,strong)UIImageView * arrow;

@property(nonatomic,strong)UIButton * yzmBtn;

@property (nonatomic, strong) UIButton *controlBtn;

@end

@implementation HLRegisterViewCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self =[super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self initView];
    }
    return self;
}

-(void)initView{
    _leftImgV = [[UIImageView alloc]init];
    [self.contentView addSubview:_leftImgV];
    [_leftImgV makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(FitPTScreen(16));
        make.top.equalTo(FitPTScreen(27));
    }];
    
    _leftLb = [[UILabel alloc]init];
    _leftLb.textColor = UIColorFromRGB(0x555555);
    _leftLb.font = [UIFont systemFontOfSize:FitPTScreen(15)];
    [self.contentView addSubview:_leftLb];
    [_leftLb makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.leftImgV.right).offset(FitPTScreen(12));
        make.top.equalTo(FitPTScreen(25));
    }];
    
    _textField = [[UITextField alloc]init];
    _textField.textColor = UIColorFromRGB(0x333333);
    _textField.textAlignment = NSTextAlignmentRight;
    _textField.font = [UIFont systemFontOfSize:FitPTScreen(14)];
    _textField.tintColor = UIColorFromRGB(0xff8717);
    [self.contentView addSubview:_textField];
    [_textField makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(FitPTScreen(-16));
        make.centerY.equalTo(self.leftLb);
        make.width.equalTo(FitPTScreen(150));
        make.height.equalTo(FitPTScreen(40));
    }];
    
    UIView * line = [[UIView alloc]init];
    line.backgroundColor = UIColorFromRGB(0xE0E0E0);
    [self.contentView addSubview:line];
    [line makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.leftLb);
        make.top.equalTo(self.leftLb.bottom).offset(FitPTScreen(11));
        make.right.equalTo(FitPTScreen(-2));
        make.height.equalTo(0.7);
    }];
    
    
    _tipView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"ask_red"]];
    [self.contentView addSubview:_tipView];
    [_tipView makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(FitPTScreen(57));
        make.top.equalTo(line.bottom).offset(FitPTScreen(7));
    }];
    
    _tipLb = [[UILabel alloc]init];
    _tipLb.textColor = UIColorFromRGB(0xFF5555);
    _tipLb.font = [UIFont systemFontOfSize:FitPTScreen(10)];
    _tipLb.text = @"手机号是唯一登录账户";
    [self.contentView addSubview:_tipLb];
    [_tipLb makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.tipView.right).offset(FitPTScreen(3));
        make.centerY.equalTo(self.tipView);
    }];
    
    
    _arrow = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"arrow_right_grey"]];
    [self.contentView addSubview:_arrow];
    [_arrow makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(FitPTScreen(-27));
        make.centerY.equalTo(self.leftLb);
    }];
    _arrow.hidden = YES;
    
    _yzmBtn = [[UIButton alloc]init];
    _yzmBtn.layer.cornerRadius = FitPTScreen(5);
    _yzmBtn.backgroundColor = UIColorFromRGB(0xFFAC29);
    [_yzmBtn setTitle:@"获取验证码" forState:UIControlStateNormal];
    [_yzmBtn setTitleColor:UIColor.whiteColor forState:UIControlStateNormal];
    _yzmBtn.titleLabel.font = [UIFont systemFontOfSize:FitPTScreen(12)];
    [self.contentView addSubview:_yzmBtn];
    [_yzmBtn makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(FitPTScreen(-27));
        make.bottom.equalTo(line.top).offset(FitPTScreen(-12));
        make.width.equalTo(FitPTScreen(78));
        make.height.equalTo(FitPTScreen(27));
    }];
    _yzmBtn.hidden = YES;
    [_yzmBtn addTarget:self action:@selector(yzmClick) forControlEvents:UIControlEventTouchUpInside];
    
    [_textField addTarget:self action:@selector(textFieldEditing:) forControlEvents:UIControlEventEditingChanged];
    
    _controlBtn = [[UIButton alloc] init];
    [self.contentView addSubview:_controlBtn];
    [_controlBtn setImage:[UIImage imageNamed:@"user_password_show"] forState:UIControlStateNormal];
    [_controlBtn setImage:[UIImage imageNamed:@"user_password_isshow"] forState:UIControlStateSelected];
    [_controlBtn makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(0);
        make.centerY.equalTo(self.leftLb);
        make.width.height.equalTo(FitPTScreen(40));
    }];
    [_controlBtn addTarget:self action:@selector(controlBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    _controlBtn.hidden = YES;
}

- (void)controlBtnClick:(UIButton *)sender{
    sender.selected = !sender.selected;
    self.infoModel.entry = sender.selected;
    _textField.secureTextEntry = sender.selected;
}

- (void)textFieldEditing:(UITextField *)sender{
    self.infoModel.text = sender.text;
}

-(void)yzmClick{
    if ([self.delegate respondsToSelector:@selector(yzmClickWithInfo:sender:)]) {
        [self.delegate yzmClickWithInfo:self.infoModel sender:_yzmBtn];
    }
}

-(void)setInfoModel:(HLInfoModel *)infoModel{
    _infoModel = infoModel;
    _leftImgV.image = [UIImage imageNamed:infoModel.leftPic];
    _leftLb.text = infoModel.leftText;
    _textField.placeholder = infoModel.placeHolder;
    _textField.text = infoModel.text;
    _arrow.hidden = !infoModel.showArrow;
    _textField.enabled = infoModel.canInput;
    _yzmBtn.hidden = YES;
    _textField.keyboardType = infoModel.keyboardType;
    _textField.secureTextEntry = infoModel.entry;
    
    _tipView.hidden = !infoModel.phone;
    _tipLb.hidden = !infoModel.phone;
    _controlBtn.hidden = YES;
    
    if (infoModel.type == HLInfoModelYZM) {
        _yzmBtn.hidden = false;
        [_textField remakeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(self.yzmBtn.left).offset(FitPTScreen(-12));
            make.centerY.equalTo(self.leftLb);
            make.width.equalTo(FitPTScreen(120));
            make.height.equalTo(FitPTScreen(45));
        }];
    }else{
        if (infoModel.showArrow) {
            [_textField remakeConstraints:^(MASConstraintMaker *make) {
                make.right.equalTo(self.arrow.left).offset(FitPTScreen(-10));
                make.centerY.equalTo(self.leftLb);
                make.width.equalTo(FitPTScreen(150));
                make.height.equalTo(FitPTScreen(45));
            }];
            return;
        }
        
        if (infoModel.type == HLInfoCollegePassword) {
            _controlBtn.hidden = NO;
            _controlBtn.selected = infoModel.entry;
            [_textField remakeConstraints:^(MASConstraintMaker *make) {
                make.right.equalTo(self.controlBtn.left).offset(FitPTScreen(-0));
                make.centerY.equalTo(self.leftLb);
                make.width.equalTo(FitPTScreen(150));
                make.height.equalTo(FitPTScreen(45));
            }];
            return;
        }
        
        [_textField remakeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(FitPTScreen(-27));
            make.centerY.equalTo(self.leftLb);
            make.width.equalTo(FitPTScreen(150));
            make.height.equalTo(FitPTScreen(45));
        }];
    }
}
@end
