//
//  HLStoreDetailTableViewCell.m
//  HuiLife
//
//  Created by 闻喜惠生活 on 2018/10/22.
//

#import "HLStoreDetailTableViewCell.h"

@interface HLStoreDetailTableViewCell()<UITextFieldDelegate,UITextViewDelegate>{
  UIView * topLine;
}
@property (strong,nonatomic)UILabel * titleLable;

@property (strong,nonatomic)UITextField * textField;

@property (strong,nonatomic)UIImageView * goImg;

@property (strong,nonatomic)UISwitch * switchView;

@property (strong,nonatomic)UITextView * textView;

@property (strong,nonatomic)UILabel * subLable;

@end

@implementation HLStoreDetailTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

}

- (void)changeValue:(UISwitch*)sender{
    _model.value = [NSString stringWithFormat:@"%@",sender.on?@"1":@"0"];
    _model.pargram =[NSDictionary dictionaryWithObject:_model.value forKey:_model.pargram.allKeys.firstObject];
    [_pargram addEntriesFromDictionary:_model.pargram];
}

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self createUI];
    }
    return self;
}

-(void)createUI{
    _titleLable = [[UILabel alloc]init];
    _titleLable.text = @"功能";
    _titleLable.font = [UIFont systemFontOfSize:FitPTScreenH(15)];
    _titleLable.textColor = UIColorFromRGB(0xFF656565);
    [self.contentView addSubview:_titleLable];
    
    _textField = [[UITextField alloc]init];
    _textField.textColor = UIColorFromRGB(0xFF989898);
    _textField.textAlignment = NSTextAlignmentRight;
    _textField.font = [UIFont systemFontOfSize:FitPTScreenH(14)];
    _textField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:_textField.text attributes:@{NSForegroundColorAttributeName: UIColorFromRGB(0xFFCACACA)}];
    _textField.delegate = self;
    [self.contentView addSubview:_textField];
    
    _goImg = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"arrow_right_grey"]];
    [self.contentView addSubview:_goImg];
    
    _switchView = [[UISwitch alloc]init];
    _switchView.tintColor = [UIColor clearColor];
    _switchView.onTintColor = UIColorFromRGB(0xFF8D26);
    [_switchView setBackgroundColor:UIColorFromRGB(0xFFF2F2F2)];
    _switchView.layer.cornerRadius = _switchView.bounds.size.height/2.0;
    [self.contentView addSubview:_switchView];
    _switchView.hidden = YES;
    [_switchView addTarget:self action:@selector(changeValue:) forControlEvents:UIControlEventValueChanged];
    
    
    topLine = [[UIView alloc]init];
    topLine.backgroundColor = UIColorFromRGB(0xFFDDDDDD);
    [self.contentView addSubview:topLine];
    [topLine makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(FitPTScreen(10));
        make.right.equalTo(FitPTScreen(-10));
        make.height.equalTo(FitPTScreen(1));
        make.top.equalTo(self.contentView);
    }];
    
    _textView = [[UITextView alloc]init];
    [self.contentView addSubview:_textView];
    _textView.textColor = UIColorFromRGB(0x989898);
    _textView.textAlignment = NSTextAlignmentRight;
    _textView.font = [UIFont systemFontOfSize:FitPTScreenH(14)];
    _textView.zw_placeHolderColor = UIColorFromRGB(0xCACACA);
    _textView.delegate = self;
    _textView.hidden = YES;
    
    [self layout];
}

-(void)layout{
    [_titleLable remakeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.contentView);
        make.left.equalTo(FitPTScreen(20));
    }];
    
    [_textField remakeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.model.showGoImg?FitPTScreen(-39): FitPTScreen(-20));
        make.width.equalTo(FitPTScreen(240));
        make.height.centerY.equalTo(self.contentView);
    }];
    
    [_goImg remakeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(FitPTScreen(-20));
        make.centerY.equalTo(self.contentView);
    }];
    
    [_switchView remakeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.contentView);
        make.right.equalTo(FitPTScreen(-20));
    }];
    
    [_textView updateConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.contentView);
        make.right.equalTo(self.contentView).offset(FitPTScreen(-20));
        make.width.equalTo(FitPTScreen(228));
    }];
    
    [self changeTextViewHight];
}

-(void)setModel:(HLStoreDetailModel *)model{
    _model = model;
    self.titleLable.text = model.text;
    self.textField.placeholder = model.placeHolder;
    self.textField.text = model.showText;
    
    self.switchView.hidden = model.type != HLStoreDetailSwitch;
    self.textField.enabled = model.canEdit;
    self.goImg.hidden = !model.showGoImg;
    if (model.type == HLStoreDetailSwitch) {
        self.switchView.on = [model.value integerValue] == 1;
    }
    if (model.type == HLStoreDetailTextView) {
        self.textField.hidden = YES;
        self.textView.hidden = NO;
    }
    self.textView.zw_placeHolder = model.placeHolder;
    self.textView.text = model.showText;
    
    [self layout];
}

-(void)setIndexPath:(NSIndexPath *)indexPath{
    _indexPath = indexPath;
    if (indexPath.section == 1 || (indexPath.section == 0 && indexPath.row == 0)) {
        topLine.hidden = YES;
    }
    
    if (!self.tool) {
        self.tool = [[HLTextFieldCheckInputNumberTool alloc]init];
    }
    if (indexPath.section == 0 && indexPath.row == 0) {
        _tool.MAX_STARWORDS_LENGTH = 20;
    }else if (indexPath.section == 0 && indexPath.row == 3){
        _tool.MAX_STARWORDS_LENGTH = 11;
        self.textField.keyboardType = UIKeyboardTypeNumberPad;
    }
    [self.textField addTarget:self.tool action:@selector(textFieldDidChanged:) forControlEvents:UIControlEventEditingChanged];
}

#pragma mark - UITextViewDelegate
-(void)changeTextViewHight{
    CGFloat hight = self.textView.contentSize.height;
    if (self.textView.contentSize.height >68) {
        hight = 68;
    }else if (self.textView.contentSize.height < 30){
        hight = 30;
    }
    [_textView updateConstraints:^(MASConstraintMaker *make) {
        make.height.equalTo(hight);
    }];
}

-(BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text{
    
    [self changeTextViewHight];
    NSLog(@"range.location = %ld",range.location);
    return YES;
}



-(void)textViewDidChange:(UITextView *)textView{
    NSLog(@"textViewDidChange = %@",textView.text);
    if (textView.text.length > 200) {
        textView.text = [textView.text substringToIndex:200];
    }
    _model.value = textView.text;
    _model.showText = textView.text;
    _model.pargram = [NSDictionary dictionaryWithObject:_model.value forKey:_model.pargram.allKeys.firstObject];
    [_pargram addEntriesFromDictionary:_model.pargram];
}

#pragma mark - UITextFieldDelegate
-(void)textFieldDidEndEditing:(UITextField *)textField{
    NSLog(@"textField = %@",textField.text);
    _model.value = textField.text;
    _model.showText = textField.text;
    _model.pargram = [NSDictionary dictionaryWithObject:_model.value forKey:_model.pargram.allKeys.firstObject];
    [_pargram addEntriesFromDictionary:_model.pargram];
}

@end
