//
//  HLCustomField.m
//  HuiLife
//
//  Created by 闻喜惠生活 on 2019/8/13.
//

#import "HLCustomField.h"

#define ButtonTag       100000
#define inputW          30
#define imgSearchW      15

@interface HLCustomField ()<UITextFieldDelegate>

@property (nonatomic , strong) UIView *inputView;     //左边输入视图

@property (nonatomic , strong) UITextField *nameTextField; //搜索框

@property (nonatomic , strong) UIImageView *imgSearch; //搜索图片

@end

@implementation HLCustomField


-(void)setTextFont:(UIFont *)textFont{
    _textFont = textFont;
    _nameTextField.font = _textFont;
}

-(void)setTextColor:(UIColor *)textColor{
    _textColor = textColor;
    _nameTextField.textColor = _textColor;
}

-(void)setPlaceHolder:(NSString *)placeHolder{
    _placeHolder = placeHolder;
    _nameTextField.placeholder = _placeHolder;
}

-(void)setPlaceAttr:(NSAttributedString *)placeAttr{
    _placeAttr = placeAttr;
    _nameTextField.attributedPlaceholder = placeAttr;
}

-(instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        
        self.placeAttr = [[NSAttributedString alloc]initWithString:@"搜索门店名称" attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:FitPTScreen(14)],NSForegroundColorAttributeName:UIColorFromRGB(0xACACAC)}];
        [self inputTextField];
        [self notificationCenterAction];
        [self hiddenSearchAnimation];
        [self notificationCenterAction];
    }
    return self;
}

-(void) inputTextField {
    
    self.layer.masksToBounds = YES;
    //添加手势，单击收起键盘
    self.nameTextField = [[UITextField alloc] init];
    _nameTextField.backgroundColor = UIColor.clearColor;
//    _nameTextField.borderStyle = UITextBorderStyleRoundedRect;
    _nameTextField.placeholder = self.placeHolder;
    _nameTextField.delegate = self;
    //设置输入框内容的字体样式和大小
    _nameTextField.font = [UIFont systemFontOfSize:FitPTScreen(14)];
    _nameTextField.textColor = UIColorFromRGB(0xACACAC);
    _nameTextField.attributedPlaceholder = self.placeAttr;
//    设置为搜索键盘
    _nameTextField.returnKeyType = UIReturnKeySearch;
    [self addSubview:_nameTextField];
    [_nameTextField makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self).insets(UIEdgeInsetsMake(1, 1, 1, 1));
    }];
}

-(void) notificationCenterAction
{
    //监听键盘的事件
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:)
                                                 name:UIKeyboardWillShowNotification
                                               object:self.window];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:)
                                                 name:UIKeyboardWillHideNotification
                                               object:self.window];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(TextFieldTextDidChange)
                                                 name:UITextFieldTextDidChangeNotification
                                               object:self.window];
}



//显示搜索状态
-(void) searchAnimation
{
    self.inputView = [[UIView alloc] init];
    self.inputView.frame= CGRectMake(0, 0 ,inputW , inputW);
    
    self.imgSearch = [[UIImageView alloc] init];
    self.imgSearch.image = [UIImage imageNamed:@"search_grey"];
    CGRect rx = CGRectMake( 12,(inputW - imgSearchW)/2 , imgSearchW, imgSearchW);
    self.imgSearch.frame = rx;
    
    [self.inputView addSubview:self.imgSearch];
    // 把leftVw设置给文本框
    _nameTextField.leftView = self.inputView;
    _nameTextField.leftViewMode = UITextFieldViewModeAlways;
}

//显示隐藏状态
-(void) hiddenSearchAnimation {
    
    [self layoutIfNeeded];
    self.inputView = [[UIView alloc] init];
    CGSize size = [_nameTextField.placeholder sizeWithFont:_nameTextField.font];
    CGFloat textFieldW = (_nameTextField.frame.size.width-size.width)/2;
    self.inputView.frame= CGRectMake(0, 0 ,textFieldW , inputW);
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(inputViewTapped)];
    tap.cancelsTouchesInView = NO;
    [self.inputView addGestureRecognizer:tap];
    
    self.imgSearch = [[UIImageView alloc] init];
    self.imgSearch.image = [UIImage imageNamed:@"search_grey"];
    CGRect rx = CGRectMake( textFieldW -imgSearchW - 10 , (inputW - imgSearchW)/2 , imgSearchW, imgSearchW);
    self.imgSearch.frame = rx;
    
    [self.inputView addSubview:self.imgSearch];
    // 把leftVw设置给文本框
    _nameTextField.leftView = self.inputView;
    _nameTextField.leftViewMode = UITextFieldViewModeAlways;
    
}

- (void)inputViewTapped {
    [_nameTextField becomeFirstResponder];
}

#pragma mark -UITextFieldDelegate
-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    [self.nameTextField resignFirstResponder];
    if ([self.delegate respondsToSelector:@selector(customField:searchWithText:)]) {
        [self.delegate customField:self searchWithText:textField.text];
    }
    return YES;
}


-(BOOL)textFieldShouldBeginEditing:(UITextField *)textField{
    if ([self.delegate respondsToSelector:@selector(customFieldShouldBeginEditing)]) {
        [self.delegate customFieldShouldBeginEditing];
    }
    return YES;
}

- (void)TextFieldTextDidChange {
    if ([self.delegate respondsToSelector:@selector(customField:searchDidChangeText:)]) {
        [self.delegate customField:self searchDidChangeText:_nameTextField.text];
    }
}



#pragma mark - 屏幕的伸缩
//键盘升起时动画
- (void)keyboardWillShow:(NSNotification*)notif
{
    //动态提起整个屏幕
    [UIView animateWithDuration:2 animations:^{
        [self searchAnimation];
    } completion:nil];
}

//键盘关闭时动画
- (void)keyboardWillHide:(NSNotification*)notif
{
    
    [UIView animateWithDuration:2 animations:^{
        [self hiddenSearchAnimation];
    } completion:nil];
}



@end
