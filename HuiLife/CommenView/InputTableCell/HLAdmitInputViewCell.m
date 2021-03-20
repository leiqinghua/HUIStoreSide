//
//  HLAdmitInputViewCell.m
//  HuiLife
//
//  Created by 闻喜惠生活 on 2019/8/8.
//

#import "HLAdmitInputViewCell.h"

@interface HLAdmitInputViewCell ()

@property(nonatomic,strong)UIButton * noAdmitBtn;

@property(nonatomic,strong)UIButton * admitBtn;

@property(nonatomic,strong)UILabel * tipLb;

@property(nonatomic,strong)UITextField * textField;

@property(nonatomic,strong)UIButton * lastSelectBtn;

@property (nonatomic, strong) UIImageView *arrowImgV;

@end

@implementation HLAdmitInputViewCell

-(void)initSubUI{
    [super initSubUI];
    
    [self.leftTipLab remakeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(FitPTScreen(15));
        make.top.equalTo(FitPTScreen(18));
    }];
    
    _admitBtn = [[UIButton alloc]init];
    _admitBtn.tag = 1001;
    [_admitBtn setTitle:@" 每人限领" forState:UIControlStateNormal];
    [_admitBtn setImage:[UIImage imageNamed:@"circle_normal"] forState:UIControlStateNormal];
    [_admitBtn setImage:[UIImage imageNamed:@"single_ring_normal"] forState:UIControlStateSelected];
    [_admitBtn setTitleColor:UIColorFromRGB(0x333333) forState:UIControlStateNormal];
    _admitBtn.titleLabel.font = [UIFont systemFontOfSize:FitPTScreen(14)];
    [self.contentView addSubview:_admitBtn];
    [_admitBtn makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(FitPTScreen(-13));
        make.centerY.equalTo(self.leftTipLab);
    }];
    
    _noAdmitBtn = [[UIButton alloc]init];
    _noAdmitBtn.tag = 1000;
    [_noAdmitBtn setTitle:@" 不限领取" forState:UIControlStateNormal];
    [_noAdmitBtn setImage:[UIImage imageNamed:@"circle_normal"] forState:UIControlStateNormal];
    [_noAdmitBtn setImage:[UIImage imageNamed:@"single_ring_normal"] forState:UIControlStateSelected];
    [_noAdmitBtn setTitleColor:UIColorFromRGB(0x333333) forState:UIControlStateNormal];
    _noAdmitBtn.titleLabel.font = [UIFont systemFontOfSize:FitPTScreen(14)];
    [self.contentView addSubview:_noAdmitBtn];
    [_noAdmitBtn makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.admitBtn.left).offset(FitPTScreen(-24));
        make.centerY.equalTo(self.leftTipLab);
    }];
    _noAdmitBtn.selected = YES;
    _lastSelectBtn = _noAdmitBtn;
    
    
    [_noAdmitBtn addTarget:self action:@selector(admintBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [_admitBtn addTarget:self action:@selector(admintBtnClick:) forControlEvents:UIControlEventTouchUpInside];

    _textField = [[UITextField alloc] init];
    UIView * rightView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, FitPTScreen(15), FitPTScreen(15))];
    _textField.rightView = rightView;
    _textField.rightViewMode = UITextFieldViewModeAlways;
    _textField.hidden = YES;
    [_textField addTarget:self action:@selector(textFieldEditing:) forControlEvents:UIControlEventEditingChanged];
    [self.contentView addSubview:_textField];
    _textField.font = [UIFont systemFontOfSize:FitPTScreen(14)];
    _textField.textColor = UIColorFromRGB(0x999999);
    _textField.textAlignment = NSTextAlignmentRight;
    _textField.placeholder = @"";
    _textField.tintColor = UIColorFromRGB(0xff8717);
    _textField.layer.cornerRadius = FitPTScreen(5);
    [_textField makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(FitPTScreen(-12));
        make.bottom.equalTo(FitPTScreen(-10));
        make.width.equalTo(FitPTScreen(273));
        make.height.equalTo(FitPTScreen(40));
    }];

    _tipLb = [[UILabel alloc]init];
    _tipLb.textColor =UIColorFromRGB(0x333333);
    _tipLb.font = [UIFont systemFontOfSize:FitPTScreen(14)];
    _tipLb.text = @"";
    [self.contentView addSubview:_tipLb];
    [_tipLb makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.leftTipLab);
        make.centerY.equalTo(self.textField);
    }];
    _tipLb.hidden = YES;
    
    _arrowImgV = [[UIImageView alloc] init];
    [self.contentView addSubview:_arrowImgV];
    _arrowImgV.image = [UIImage imageNamed:@"arrow_right_grey"];
    _arrowImgV.contentMode = UIViewContentModeScaleAspectFit;
    _arrowImgV.clipsToBounds = YES;
    [_arrowImgV makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(FitPTScreen(-13));
        make.centerY.equalTo(self.textField);
        make.width.equalTo(FitPTScreen(12));
        make.height.equalTo(FitPTScreen(12));
    }];
    _arrowImgV.hidden = YES;
}

- (void)textFieldEditing:(UITextField *)sender{
    self.baseInfo.text = sender.text;
}

-(void)admintBtnClick:(UIButton *)sender{
    _lastSelectBtn.selected = false;
    sender.selected = YES;
    _lastSelectBtn = sender;
    
    HLAdmitInputInfo * info = (HLAdmitInputInfo *)self.baseInfo;
    info.admit = sender.tag == 1001;
    if ([self.delegate respondsToSelector:@selector(admitViewWithModel:admit:)]) {
        [self.delegate admitViewWithModel:self.baseInfo admit:(sender.tag != 1000)];
    }
}

-(void)removeAdmitInputView{
    _tipLb.hidden = YES;
    _textField.hidden = YES;
    _arrowImgV.hidden = YES;
}

-(void)showAdmitInputView{
    
    HLAdmitInputInfo *info = (HLAdmitInputInfo *)self.baseInfo;
    _tipLb.hidden = false;
    _textField.hidden = false;
    _arrowImgV.hidden = !info.showArrow;
}

-(void)setBaseInfo:(HLAdmitInputInfo *)baseInfo{
    [super setBaseInfo:baseInfo];
    _textField.enabled = baseInfo.canInput;
    _textField.placeholder = baseInfo.placeHolder;
    _textField.text = baseInfo.text;
    _textField.keyboardType = baseInfo.keyBoardType;
    _tipLb.text = baseInfo.subText;
    _arrowImgV.hidden = !baseInfo.showArrow;
    _textField.layer.borderColor = baseInfo.showBox?UIColorFromRGB(0xD9D9D9).CGColor:UIColor.clearColor.CGColor;
    _textField.layer.borderWidth = baseInfo.showBox?FitPTScreen(1):0;
    [_textField updateConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(baseInfo.showArrow?FitPTScreen(-27):FitPTScreen(-16));
    }];
    
    [_noAdmitBtn setTitle:[NSString stringWithFormat:@" %@",baseInfo.titles.firstObject] forState:UIControlStateNormal];
    [_admitBtn setTitle:[NSString stringWithFormat:@" %@",baseInfo.titles.lastObject] forState:UIControlStateNormal];
    
    if (baseInfo.admit) {
        [self showAdmitInputView];
    }else{
        [self removeAdmitInputView];
    }
}
@end


@implementation HLAdmitInputInfo

-(BOOL)checkParamsIsOk{
    if (!self.needCheckParams) {
        return YES;
    }
    if ((!self.text.length && _admit) || (!self.text.length && !self.mParams.count)) {
        return NO;
    }
    return YES;
}

@end
