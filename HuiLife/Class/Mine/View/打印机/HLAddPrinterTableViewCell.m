//
//  HLAddPrinterTableViewCell.m
//  HuiLife
//
//  Created by 闻喜惠生活 on 2018/11/23.
//

#import "HLAddPrinterTableViewCell.h"
#import "HLTextFieldCheckInputNumberTool.h"

@interface HLAddPrinterTableViewCell()<UITextFieldDelegate>{
    UIView * _topLine;
    UIView * _bottomLine;
}

@property (strong,nonatomic)UILabel * titleLable;

@property (strong,nonatomic)UITextField * textField;

//输入字数限制
@property (assign,nonatomic)NSInteger inputNum;

@property (strong,nonatomic)HLTextFieldCheckInputNumberTool * tool;
@end

@implementation HLAddPrinterTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self initSubViews];
    }
    return self;
}

-(void)initSubViews{
    
    _titleLable = [[UILabel alloc]init];
    _titleLable.font = [UIFont systemFontOfSize:FitPTScreenH(15)];
    _titleLable.textColor = UIColorFromRGB(0x656565);
    [self.contentView addSubview:_titleLable];
    
    [_titleLable makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(FitPTScreen(20));
        make.centerY.equalTo(self.contentView);
    }];
    
    _textField = [[UITextField alloc]init];
    _textField.textAlignment = NSTextAlignmentRight;
    _textField.delegate = self;
    _textField.textColor = UIColorFromRGB(0x282828);
    _textField.font = [UIFont systemFontOfSize:FitPTScreenH(14)];
    [self.contentView addSubview:_textField];
    
   _tool = [[HLTextFieldCheckInputNumberTool alloc]init];
   [_textField addTarget:_tool action:@selector(textFieldDidChanged:) forControlEvents:UIControlEventEditingChanged];
    
    [_textField makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(-FitPTScreen(20));
        make.centerY.height.equalTo(self.contentView);
        make.width.equalTo(FitPTScreen(200));
    }];
    
    //顶部
    _topLine =[[UIView alloc]init];
    _topLine.backgroundColor = UIColorFromRGB(0xECECEC);
    [self.contentView addSubview:_topLine];
    [_topLine makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView).offset(FitPTScreen(10));
        make.right.equalTo(self.contentView).offset(FitPTScreen(-10));
        make.top.equalTo(self.contentView);
        make.height.equalTo(FitPTScreen(1));
    }];
    
    //底部
    _bottomLine =[[UIView alloc]init];
    _bottomLine.backgroundColor = UIColorFromRGB(0xECECEC);
    [self.contentView addSubview:_bottomLine];
    [_bottomLine makeConstraints:^(MASConstraintMaker *make) {
        make.right.left.equalTo(self.contentView);
        make.bottom.equalTo(self.contentView);
        make.height.equalTo(FitPTScreen(1));
    }];
    _bottomLine.hidden = YES;
}

-(void)updateLineWithTopHiden:(BOOL)top bottomHiden:(BOOL)bottom topFull:(BOOL)topFull bottomFull:(BOOL)bottomFull{
    
    _topLine.hidden = top;
    _bottomLine.hidden = bottom;
    
    [_topLine updateConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(FitPTScreen(topFull?0:10));
        make.right.equalTo(FitPTScreen(topFull?0:-10));
    }];
    
    [_bottomLine updateConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(FitPTScreen(bottomFull?0:10));
        make.right.equalTo(FitPTScreen(bottomFull?0:-10));
    }];

}

-(void)setModel:(HLPrinterSetModel *)model{
    _model = model;
    _titleLable.text = _model.title;
    _textField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:_model.placeholder attributes:@{NSForegroundColorAttributeName: UIColorFromRGB(0xCACACA),NSFontAttributeName:[UIFont systemFontOfSize:FitPTScreenH(14)]}];
    _textField.text = _model.subTitle;
    _inputNum = _model.max_inputNum;
    _tool.MAX_STARWORDS_LENGTH = _inputNum;
}

#pragma mark - UITextFieldDelegate
-(void)textFieldDidEndEditing:(UITextField *)textField{
    _model.subTitle = textField.text;
    if ([self.delegate respondsToSelector:@selector(editWithModel:key:)]) {
        [self.delegate editWithModel:_model key:_key];
    }
}


@end
