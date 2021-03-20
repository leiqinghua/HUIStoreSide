//
//  HLTextField.m
//  HuiLife
//
//  Created by 闻喜惠生活 on 2018/7/16.
//

#import "HLTextField.h"
#import "HLListView.h"
@interface HLTextField()<ZCDropDownDelegate,UITextFieldDelegate>{
    UIView * lineView ;
}

@property(copy,nonatomic)NSString * titleImage;
@property(copy,nonatomic)NSString * placeholder;
@property(copy,nonatomic)NSString * funImage;
@property(copy,nonatomic)NSString * selectImage;
@property(strong,nonatomic)HLListView * listView;
@property(strong,nonatomic)NSArray * lists;
@end

@implementation HLTextField

- (instancetype)initWithImage:(NSString *)imgName placeHolder:(NSString *)place funImgNormal:(NSString *)funImage select:(NSString *)selectImage {
    if (self = [super init]) {
        _titleImage = imgName;
        _placeholder = place;
        _funImage = funImage;
        _selectImage = selectImage;
        [self createUI];
    }
    return self;
}

-(NSString *)configeText{
    return self.textField.text;
}

-(void)createUI{
    UIImageView * titleView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:_titleImage]];
    [self addSubview:titleView];
    [titleView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.left).offset(FitPTScreen(15));
        make.centerY.equalTo(self);
    }];
    
    _textField = [[UITextField alloc]init];
    _textField.tintColor = UIColorFromRGB(0xff8717);
    _textField.placeholder = _placeholder;
    _textField.clearButtonMode = UITextFieldViewModeWhileEditing;
    _textField.delegate = self;
    _textField.font = [UIFont systemFontOfSize:FitPTScreen(13)];
    [self addSubview:_textField];
    [_textField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).offset(FitPTScreen(35));
        make.centerY.equalTo(self);
        make.width.equalTo(FitPTScreen(250));
        make.height.equalTo(self);
    }];
    
    lineView = [[UIView alloc]init];
    lineView.backgroundColor = UIColorFromRGB(0xF0F0F0);
    [self addSubview:lineView];
    [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.textField);
        make.bottom.equalTo(self);
        make.height.equalTo(FitPTScreen(0.8));
        make.width.equalTo(FitPTScreen(250));
    }];
    
//    UIButton *funBtn = [[UIButton alloc]init];
//    [funBtn setImage:[UIImage imageNamed:_funImage] forState:UIControlStateNormal];
//    [funBtn setImage:[UIImage imageNamed:[_selectImage hl_isAvailable]?_selectImage:_funImage] forState:UIControlStateSelected];
//    [self addSubview:funBtn];
//    [funBtn addTarget:self action:@selector(funBtnClick:) forControlEvents:UIControlEventTouchUpInside];
//    [funBtn mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.right.equalTo(self).offset(FitPTScreen(-0));
//        make.bottom.equalTo(self).offset(FitPTScreenH(-6));
//        make.width.height.equalTo(FitPTScreen(20));
//    }];
//    funBtn.hidden = ![_funImage hl_isAvailable];
//    //获取本地的工号
//    NSDictionary * dic = [[NSUserDefaults standardUserDefaults]valueForKey:user_name_key];
//    if (dic) {
//        _lists = [dic allValues];
//        //倒叙排列
//    }else{
//        _lists = @[];
//    }
}

-(void)funBtnClick:(UIButton *)sender{
    sender.selected = !sender.selected;
    [_textField resignFirstResponder];
    CGFloat f;
    if (!self.isPassword) {
        if (!_listView) {
            if (_lists.count < 4) {
                f = 40*_lists.count;
            }else{
                f = 120;
            }
            _listView = [[HLListView alloc]initWithShowDropDown:CGRectMake(self.frame.origin.x + lineView.frame.origin.x-15, self.frame.origin.y + lineView.frame.origin.y +1, lineView.frame.size.width, 0) height:f arr:_lists];
            [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(listChanged:) name:@"NOTI" object:nil];
            [self.superview addSubview:_listView];
            _listView.delegate = self;
        }else{
            [_listView hideDropDown:CGRectMake(self.frame.origin.x + lineView.frame.origin.x-15, self.frame.origin.y + lineView.frame.origin.y, lineView.frame.size.width, 0)];
            _listView = nil;
        }
    }else{
        _textField.secureTextEntry = !sender.selected;
    }
}

-(void)setIsPassword:(BOOL)isPassword{
    _isPassword = isPassword;
    _textField.secureTextEntry = isPassword;
    _textField.keyboardType = isPassword?UIKeyboardTypeNumbersAndPunctuation:UIKeyboardTypeDefault;
}

- (void)setKeyboardType:(UIKeyboardType)keyboardType {
    _textField.keyboardType = keyboardType;
}

- (void)dropDownDelegateMethod: (HLListView *) sender {
    _listView = nil;
}

-(void)didSelectItem:(NSString *)text{
    _textField.text = text;
}

- (void)listChanged:(NSNotification *)noti{
    self.lists = noti.object;
}

#pragma UITextFieldDelegate
-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    NSString *tem = [[string componentsSeparatedByCharactersInSet:[NSCharacterSet whitespaceCharacterSet]]componentsJoinedByString:@""];
    if (![string isEqualToString:tem]) {
        return NO;
    }
    return YES;
}
-(void)dealloc{
    NSLog(@"自定义textfield销毁");
}
@end
