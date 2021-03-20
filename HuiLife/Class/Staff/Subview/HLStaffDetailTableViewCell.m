//
//  HLStaffDetailTableViewCell.m
//  HuiLife
//
//  Created by 闻喜惠生活 on 2018/10/18.
//

#import "HLStaffDetailTableViewCell.h"
#import "HLTextFieldCheckInputNumberTool.h"

@interface HLStaffDetailTableViewCell()<UITextFieldDelegate>{
//    UIView * topLine;
}

@property (strong,nonatomic)UILabel * titleLable;

@property (strong,nonatomic)UITextField * textField;

@property (strong,nonatomic)UIImageView * goImg;

@property (strong,nonatomic)UISwitch * switchView;

@property (strong,nonatomic)HLTextFieldCheckInputNumberTool * tool;

@end

@implementation HLStaffDetailTableViewCell


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
    _titleLable.font = [UIFont systemFontOfSize:FitPTScreen(15)];
    _titleLable.textColor = UIColorFromRGB(0xFF656565);
    [self.contentView addSubview:_titleLable];
    
    _textField = [[UITextField alloc]init];
    _textField.textColor = UIColorFromRGB(0xFF989898);
    _textField.textAlignment = NSTextAlignmentRight;
    _textField.font = [UIFont systemFontOfSize:FitPTScreen(14)];
    _textField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:_textField.text attributes:@{NSForegroundColorAttributeName: UIColorFromRGB(0xFFCACACA)}];
    _textField.delegate = self;
    [self.contentView addSubview:_textField];
    
    _tool = [[HLTextFieldCheckInputNumberTool alloc]init];
    [_textField addTarget:_tool action:@selector(textFieldDidChanged:) forControlEvents:UIControlEventEditingChanged];
    
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
    
    
//    topLine = [[UIView alloc]init];
//    topLine.backgroundColor = UIColorFromRGB(0xFFDDDDDD);
//    [self.contentView addSubview:topLine];
//    [topLine makeConstraints:^(MASConstraintMaker *make) {
//        make.left.equalTo(FitPTScreen(10));
//        make.right.equalTo(FitPTScreen(-10));
//        make.height.equalTo(FitPTScreen(1));
//        make.top.equalTo(self.contentView);
//    }];
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
    
}

-(void)setModel:(HLStaffDetailModel *)model{
    _model = model;
    self.titleLable.text = model.text;
    self.textField.text = model.showText;
    self.textField.placeholder = model.placeHolder;
    if (model.type == HLSwitchType) {
        self.switchView.on = [model.value integerValue] == 1;
    }
    self.switchView.hidden = model.type != HLSwitchType;
    self.textField.enabled = model.canEdit;
    self.goImg.hidden = !model.showGoImg;
    if (model.fieldType == HLTextFieldPassType) {
        self.textField.secureTextEntry = YES;
    }
    if (model.fieldType == HLTextFieldPhoneType) {
        self.textField.keyboardType = UIKeyboardTypeNumberPad;
    }
    _tool.MAX_STARWORDS_LENGTH = _model.input_num;
    
    [self layout];
}

//-(void)setIndexPath:(NSIndexPath *)indexPath{
//    _indexPath = indexPath;
//    
//    if (indexPath.row == 0) {
//        topLine.hidden = YES;
//    }
//}

#pragma mark - UITextFieldDelegate
-(void)textFieldDidEndEditing:(UITextField *)textField{
    NSLog(@"textField = %@",textField.text);
    _model.value = textField.text;
    _model.showText = textField.text;
    _model.pargram = [NSDictionary dictionaryWithObject:_model.value forKey:_model.pargram.allKeys.firstObject];
    [_pargram addEntriesFromDictionary:_model.pargram];
}

-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    if (_model.fieldType == HLTextFieldPhoneType ) {
       return [self validateNumber:string];
    }
    return YES;
}

- (BOOL)validateNumber:(NSString*)number {
    BOOL res = YES;
    NSCharacterSet* tmpSet = [NSCharacterSet characterSetWithCharactersInString:@"0123456789"];
    int i = 0;
    while (i < number.length) {
        NSString * string = [number substringWithRange:NSMakeRange(i, 1)];
        NSRange range = [string rangeOfCharacterFromSet:tmpSet];
        if (range.length == 0) {
            res = NO;
            break;
        }
        i++;
    }
    return res;
}

@end
