//
//  HLHotSekillDetailViewCell.m
//  HuiLife
//
//  Created by 王策 on 2019/8/7.
//

#import "HLHotSekillDetailViewCell.h"

NSInteger const kTextFieldTag = 101;
NSInteger const kSelectViewTag = 102;
NSInteger const kSelectLabTag = 1021;

@interface HLHotSekillDetailViewCell () <UITextFieldDelegate>

@property (nonatomic, strong) NSMutableArray *itemArr;

@end

@implementation HLHotSekillDetailViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.itemArr = [NSMutableArray array];
        [self initSubUI];
    }
    return self;
}

- (void)initSubUI{
    
    NSArray *tips = @[@"名称",@"数量",@"价格",@"备注"];
    NSArray *keyBoardTypes = @[@(UIKeyboardTypeDefault),@(UIKeyboardTypeNumberPad),@(UIKeyboardTypeDecimalPad),@(UIKeyboardTypeDefault)];
    NSArray *placeHoders = @[@"套餐内容名称",@"套餐内包含的数量",@"¥套餐内容原价",@""];
    
    CGFloat viewHeight = FitPTScreen(50);
    UIView *lastView = nil;
    for (NSInteger i = 0; i < tips.count; i++) {
        UIView *view = [self subViewWithTip:tips[i] placeHoder:placeHoders[i] showUnit:i == 1 keyBoardType:[keyBoardTypes[i] integerValue]];
        [self.contentView addSubview:view];
        view.tag = i;
        [view makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.equalTo(0);
            make.top.equalTo(i * viewHeight);
            make.height.equalTo(viewHeight);
        }];
        lastView = view;
        
        [self.itemArr addObject:view];
    }
    
    UIButton *deleteBtn = [[UIButton alloc] init];
    [self.contentView addSubview:deleteBtn];
    [deleteBtn setTitle:@" 删除" forState:UIControlStateNormal];
    [deleteBtn setTitleColor:UIColorFromRGB(0xFFAD2C) forState:UIControlStateNormal];
    deleteBtn.titleLabel.font = [UIFont systemFontOfSize:FitPTScreen(13)];
    [deleteBtn setImage:[UIImage imageNamed:@"delete_oriange"] forState:UIControlStateNormal];
    [deleteBtn makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(lastView.bottom);
        make.right.equalTo(FitPTScreen(0));
        make.width.equalTo(FitPTScreen(67));
        make.height.equalTo(FitPTScreen(44));
    }];
    [deleteBtn addTarget:self action:@selector(deleteBtnClick) forControlEvents:UIControlEventTouchUpInside];
    
    UIView *bottomLine = [[UIView alloc] init];
    [self.contentView addSubview:bottomLine];
    bottomLine.backgroundColor = UIColorFromRGB(0xF8F8F8);
    [bottomLine makeConstraints:^(MASConstraintMaker *make) {
        make.right.left.equalTo(0);
        make.top.equalTo(deleteBtn.bottom);
        make.bottom.equalTo(0);
    }];
}

- (void)deleteBtnClick{
    if (self.delegate) {
        [self.delegate detailViewCell:self deleteInputModel:self.inputModel];
    }
}

- (void)selectViewClick:(UITapGestureRecognizer *)tap{
    if (self.delegate) {
        [self.delegate detailViewCell:self showSelectDownView:tap.view];
    }
}

-(void)setInputModel:(HLHotSekillDetailInputModel *)inputModel{
    _inputModel = inputModel;
    
    [self configFieldTextWithIndex:0 text:inputModel.contentName];
    [self configFieldTextWithIndex:1 text:inputModel.num];
    [self configFieldTextWithIndex:2 text:inputModel.orinalPrice];
    [self configFieldTextWithIndex:3 text:inputModel.remark];

    // 设置单位
    UIView *view = self.itemArr[1];
    UIView *selectView = [view viewWithTag:kSelectViewTag];
    UILabel *showLab = [selectView viewWithTag:kSelectLabTag];
    showLab.text = inputModel.selectUnit.name;
}

/// 输入框输入
- (void)textFieldEditing:(UITextField *)sender{
    UIView *view = sender.superview;
    NSInteger index = [self.itemArr indexOfObject:view];
    if (index == 0) {
        self.inputModel.contentName = sender.text;
    }
    if (index == 1) {
        self.inputModel.num = sender.text;
    }
    if (index == 2) {
        self.inputModel.orinalPrice = sender.text;
    }
    if (index == 3) {
        self.inputModel.remark = sender.text;
    }
}


/// 设置index个输入框的值
- (void)configFieldTextWithIndex:(NSInteger)index text:(NSString *)text{
    UIView *view = self.itemArr[index];
    UITextField *textField = [view viewWithTag:kTextFieldTag];
    textField.text = text;
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    
    if (textField.keyboardType != UIKeyboardTypeDecimalPad) {
        return YES;
    }
    NSString * toBeString = [textField.text stringByReplacingCharactersInRange:range withString:string];
    //限制.后面最多有两位，且不能再输入.
    if ([textField.text rangeOfString:@"."].location != NSNotFound) {
        //有.了 且.后面输入了两位  停止输入
        if (toBeString.length > [toBeString rangeOfString:@"."].location+3) {
            return NO;
        }
        //有.了，不允许再输入.
        if ([string isEqualToString:@"."]) {
            return NO;
        }
    }
    
    // 限制首位0，后面只能输入.
    if ([textField.text isEqualToString:@"0"]) {
        if (![string isEqualToString:@"."] && ![string isEqualToString:@""]) {
            return NO;
        }
    }
    
    // 第一个字符不能输入0
    if (textField.text.length == 0 && [string isEqualToString:@"0"]) {
        return NO;
    }
    
    // 如果第一个输入的是点，那么直接变成 0.
    if (textField.text.length == 0 && [string isEqualToString:@"."]) {
        textField.text = @"0";
    }
    
    //限制只能输入：1234567890.
    NSCharacterSet * characterSet = [[NSCharacterSet characterSetWithCharactersInString:@"1234567890."] invertedSet];
    NSString * filtered = [[string componentsSeparatedByCharactersInSet:characterSet] componentsJoinedByString:@""];
    return [string isEqualToString:filtered];
}

/// 修改view
- (UIView *)subViewWithTip:(NSString *)tip placeHoder:(NSString *)placeHoder showUnit:(BOOL)showUnit keyBoardType:(UIKeyboardType)keyBoardType{
    UIView *view = [[UIView alloc] init];
    
    UILabel *leftLab = [[UILabel alloc] init];
    leftLab.text = tip;
    leftLab.textColor = UIColorFromRGB(0x333333);
    leftLab.font = [UIFont systemFontOfSize:FitPTScreen(14)];
    [view addSubview:leftLab];
    [leftLab makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(FitPTScreen(17));
        make.centerY.equalTo(view);
    }];
    
    UIView *selectView = nil;
    if (showUnit) {
        selectView = [[UIView alloc] init];
        [view addSubview:selectView];
        selectView.layer.cornerRadius = FitPTScreen(3);
        selectView.layer.masksToBounds = YES;
        selectView.layer.borderWidth = 0.6;
        selectView.layer.borderColor = UIColorFromRGB(0xCDCDCD).CGColor;
        [selectView makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(FitPTScreen(-12));
            make.height.equalTo(FitPTScreen(25));
            make.centerY.equalTo(view);
            make.width.equalTo(FitPTScreen(56));
        }];
        selectView.tag = kSelectViewTag;
        [selectView hl_addTarget:self action:@selector(selectViewClick:)];
        
        UILabel *showLab = [[UILabel alloc] init];
        [selectView addSubview:showLab];
        showLab.tag = kSelectLabTag;
        showLab.textColor = UIColorFromRGB(0x333333);
        showLab.font = [UIFont systemFontOfSize:FitPTScreen(13)];
        [showLab makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(FitPTScreen(13));
            make.centerY.equalTo(selectView);
        }];
        
        UIImageView *arrowImgV = [[UIImageView alloc] init];
        [selectView addSubview:arrowImgV];
        arrowImgV.image = [UIImage imageNamed:@"arrow_down_grey"];
        [arrowImgV makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(FitPTScreen(-8));
            make.centerY.equalTo(selectView);
            make.width.equalTo(FitPTScreen(9));
            make.height.equalTo(FitPTScreen(5));
        }];
    }
    
    UITextField *textField = [[UITextField alloc] init];
    [view addSubview:textField];
    textField.placeholder = placeHoder;
    textField.tag = kTextFieldTag;
    textField.textAlignment = NSTextAlignmentRight;
    textField.keyboardType = keyBoardType;
    textField.font = [UIFont systemFontOfSize:FitPTScreen(14)];
    textField.textColor = UIColorFromRGB(0x333333);
    [textField makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.equalTo(0);
        make.left.equalTo(FitPTScreen(100));
        make.right.equalTo(showUnit ? FitPTScreen(-79) : FitPTScreen(-12));
    }];
    textField.delegate = self;
    [textField addTarget:self action:@selector(textFieldEditing:) forControlEvents:UIControlEventEditingChanged];
    
    UIView *line = [[UIView alloc] init];
    [view addSubview:line];
    line.backgroundColor = UIColorFromRGB(0xEDEDED);
    [line makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(FitPTScreen(18));
        make.right.equalTo(0);
        make.height.equalTo(0.5);
        make.bottom.equalTo(0);
    }];
    
    return view;
}

@end
