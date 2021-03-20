//
//  HLTextFieldTableCell.m
//  HuiLife
//
//  Created by 闻喜惠生活 on 2019/8/3.
//

#import "HLTextFieldTableCell.h"

@interface HLTextFieldTableCell ()<UITextFieldDelegate>

@property(nonatomic,strong)UILabel * titleLb;

@property(nonatomic,strong)UITextField * textField;

@property(nonatomic,strong)UIView * bottomLine;

@property(nonatomic,strong)UIImageView * arrow;

@end

@implementation HLTextFieldTableCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self initView];
    }
    return self;
}

-(void)initView{
    _titleLb = [[UILabel alloc]init];
    _titleLb.textColor = UIColorFromRGB(0x333333);
    _titleLb.font = [UIFont systemFontOfSize:FitPTScreen(14)];
    _titleLb.text = @"店铺名称";
    [self.contentView addSubview:_titleLb];
    [_titleLb makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(FitPTScreen(16));
        make.centerY.equalTo(self.contentView);
    }];
    
    _textField = [[UITextField alloc]init];
    [self.contentView addSubview:_textField];
    _textField.delegate = self;
    _textField.textAlignment = NSTextAlignmentRight;
    _textField.textColor =UIColorFromRGB(0x666666);
    _textField.font = [UIFont systemFontOfSize:FitPTScreen(14)];
    _textField.tintColor = UIColorFromRGB(0xff8717);
    [_textField makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.contentView).offset(FitPTScreen(-16));
        make.centerY.equalTo(self.contentView);
        make.width.equalTo(FitPTScreen(250));
        make.height.equalTo(self.contentView);
    }];
    
    _textField.attributedPlaceholder = [[NSAttributedString alloc]initWithString:@"输入店铺名称" attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:FitPTScreen(14)],NSForegroundColorAttributeName:UIColorFromRGB(0x666666)}];
    
    _bottomLine = [[UIView alloc]init];
    _bottomLine.backgroundColor = UIColorFromRGB(0xF2F2F2);
    [self.contentView addSubview:_bottomLine];
    [_bottomLine makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(FitPTScreen(15));
        make.right.equalTo(FitPTScreen(-1));
        make.bottom.equalTo(self.contentView);
        make.height.equalTo(FitPTScreenH(1));
    }];
    
    _arrow = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"arrow_right_grey"]];
    _arrow.layer.cornerRadius = 4;
    [self.contentView addSubview:_arrow];
    [_arrow makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.contentView);
        make.right.equalTo(FitPTScreen(-13));
    }];
    _arrow.hidden = YES;
    
    [_textField addTarget:self action:@selector(textFieldEditing:) forControlEvents:UIControlEventEditingChanged];
}


- (void)textFieldEditing:(UITextField *)sender{
    self.inputModel.value = sender.text;
    
}

-(void)setLineHide:(BOOL)lineHide{
    _lineHide = lineHide;
    _bottomLine.hidden = lineHide;
}


-(void)setInputModel:(HLBaseInputModel *)inputModel{
    _inputModel = inputModel;
    _arrow.hidden = !inputModel.rightImg.length;
    _arrow.image = [UIImage imageNamed:inputModel.rightImg];
    
    [_textField updateConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(inputModel.rightImg.length?FitPTScreen(-35):FitPTScreen(-16));
    }];
    _textField.enabled = inputModel.canEdit;
    _titleLb.text = inputModel.text;
    _textField.attributedPlaceholder = [[NSAttributedString alloc]initWithString:inputModel.place attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:FitPTScreen(14)],NSForegroundColorAttributeName: inputModel.placeColor?:UIColorFromRGB(0x666666)}];
    _textField.text = [NSString stringWithFormat:@"%@",inputModel.value?:@""];
    
    if (inputModel.leftTipColor) {
        _titleLb.textColor = inputModel.leftTipColor;
    }
    
    
}
@end
