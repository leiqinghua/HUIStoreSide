//
//  HLSendOrderCodeInputCell.m
//  HuiLife
//
//  Created by 王策 on 2019/8/10.
//

#import "HLSendOrderCodeInputCell.h"

@interface HLSendOrderCodeInputCell ()

@property (nonatomic, strong) UILabel *tipLab;
@property (nonatomic, strong) UITextField *textField;
@property (nonatomic, strong) UIButton *delBtn;
@property (nonatomic, strong) UIView *bottomLine;

@end

@implementation HLSendOrderCodeInputCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self initSubUI];
    }
    return self;
}

- (void)initSubUI{
    
    _tipLab = [[UILabel alloc] init];
    [self.contentView addSubview:_tipLab];
    _tipLab.text = @"桌号";
    _tipLab.textColor = UIColorFromRGB(0x333333);
    _tipLab.font = [UIFont systemFontOfSize:FitPTScreen(14)];
    [_tipLab makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(FitPTScreen(17));
        make.centerY.equalTo(self.contentView);
    }];
    
    _delBtn = [[UIButton alloc] init];
    [self.contentView addSubview:_delBtn];
    [_delBtn setImage:[UIImage imageNamed:@"delete_black_light"] forState:UIControlStateNormal];
    [_delBtn makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.equalTo(0);
        make.right.equalTo(FitPTScreen(0));
        make.width.equalTo(FitPTScreen(50));
    }];
    [_delBtn addTarget:self action:@selector(delBtnClick) forControlEvents:UIControlEventTouchUpInside];
    
    UITextField *textField = [[UITextField alloc] init];
    textField.placeholder = @"请输入桌牌号";
    textField.font = [UIFont systemFontOfSize:FitPTScreen(14)];
    textField.textColor = UIColorFromRGB(0x333333);
    textField.textAlignment = NSTextAlignmentRight;
    [self.contentView addSubview:textField];
    [textField makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(_delBtn.left).offset(FitPTScreen(0));
        make.left.equalTo(FitPTScreen(70));
        make.top.bottom.equalTo(0);
    }];
    _textField = textField;
    _textField.enabled = NO;
    
    _bottomLine = [[UIView alloc] init];
    [self.contentView addSubview:_bottomLine];
    _bottomLine.backgroundColor = UIColorFromRGB(0xECECEC);
    [_bottomLine makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(FitPTScreen(15));
        make.right.equalTo(0);
        make.height.equalTo(0.5);
        make.bottom.equalTo(0);
    }];
    _bottomLine.hidden = YES;
}

- (void)delBtnClick{
    if (self.delegate) {
        [self.delegate deleteBtnClickWithInputCell:self];
    }
}

- (void)configBottomLine:(BOOL)showLine{
    _bottomLine.hidden = !showLine;
}

- (void)setInputInfo:(HLSendOrderCodeInputInfo *)inputInfo{
    _inputInfo = inputInfo;
    _textField.text = inputInfo.number;
}

-(void)setIndex:(NSInteger)index{
    _index = index;
    _tipLab.text = [NSString stringWithFormat:@"点单牌%ld",index + 1];
}

@end
