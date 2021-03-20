//
//  HLWithNotImgAlertView.m
//  HuiLife
//
//  Created by 闻喜惠生活 on 2018/7/27.
//

#import "HLWithNotImgAlertView.h"
#import "HLTextFieldCheckInputNumberTool.h"

@interface HLWithNotImgAlertView()<UITextFieldDelegate>{
    CGFloat _hight;
    NSString * _title;
    NSString * _text;
    NSString *_subTitle;
    NSString *_lastTitle;
    UIView * _showView;
    //subtitle
    UIColor * _color;
    UIColor * _lastcolor;
    NSString * _placeholder;
    
    HLTextFieldCheckInputNumberTool * checkTool;
}
@property(strong,nonatomic)UILabel * titleLable;

@property(strong,nonatomic)UILabel * subTitleLable;

@property(strong,nonatomic)UILabel * lastLable;

@property(strong,nonatomic)UITextField * textField;

@property(copy,nonatomic)Option concern;

@property(copy,nonatomic)Option cancel;

@property(copy,nonatomic)OptionWithPargram concernOption;

@property(strong,nonatomic)UIButton *cancelBtn;

@property(strong,nonatomic)UIButton *concernBtn;
@end

@implementation HLWithNotImgAlertView

//title和subtitle
-(instancetype)initWithTitle:(NSString *)title subTitle:(NSString *) subTitle hight:(CGFloat) hight subColor:(UIColor *)color oncern:(Option)concern cancel:(Option)cancel{
    if (self = [super init]) {
        _hight = hight;
        _title = title;
        _subTitle = subTitle;
        _color = color;
        _concern = concern;
        _cancel = cancel;
        [self createBagView];
        [self createShowViewWithHight:hight];
        [self createTitlesubTitle];
    }
    return self;
}
//只有一个title
-(instancetype)initWithTitle:(NSString *)title hight:(CGFloat) hight concern:(Option)concern cancel:(Option)cancel{
    if (self = [super init]) {
        _title = title;
        _hight = hight;
        _concern = concern;
        _cancel = cancel;
        [self createBagView];
        [self createShowViewWithHight:hight];
        [self createTitlesubTitle];
        _subTitleLable.hidden = YES;
        [_titleLable updateConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self->_showView).offset(FitPTScreen(50));
        }];
    }
    return self;
}


//title 和textfield
-(instancetype)initWithTitle:(NSString *)title placeHolder:(NSString *)place hight:(CGFloat) hight concern:(OptionWithPargram)concern cancel:(Option)cancel{
    if (self = [super init]) {
        _placeholder = place;
        _title = title;
        _hight = hight;
        _concernOption = concern;
        _cancel = cancel;
        [self createBagView];
        [self createShowViewWithHight:hight];
        [self createTitlesubTitle];
        [_showView updateConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self).offset(-60);
        }];
        [_subTitleLable removeFromSuperview];
        _subTitleLable = nil;
        [self creteTextField];
    }
    return self;
}

//给textfield赋值
-(instancetype)initWithTitle:(NSString *)title text:(NSString *)text placeHolder:(NSString *)place hight:(CGFloat) hight concern:(OptionWithPargram)concern cancel:(Option)cancel{
    if (self = [super init]) {
        _placeholder = place;
        _title = title;
        _hight = hight;
        _concernOption = concern;
        _cancel = cancel;
        _text = text;
        [self createBagView];
        [self createShowViewWithHight:hight];
        [self createTitlesubTitle];
        
        [_showView updateConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self).offset(-60);
        }];
        [_subTitleLable removeFromSuperview];
        _subTitleLable = nil;
        [self creteTextField];
    }
    return self;
}

//三个title
-(instancetype)initWithTitle:(NSString *)title subTitle:(NSString *)subTitle lastitle:(NSString *)lasttitle subColor:(UIColor *)color lastColor:(UIColor *)lastcolor hight:(CGFloat) hight concern:(Option)concern cancel:(Option)cancel{
    if (self = [super init]) {
        _title = title;
        _hight = hight;
        _color = color;
        _lastcolor = lastcolor;
        _concern = concern;
        _cancel = cancel;
        _subTitle = subTitle;
        _lastTitle = lasttitle;
        [self createBagView];
        [self createShowViewWithHight:hight];
        [self createTitlesubTitle];
        [self creatLastTitle];
    }
    return self;
}

-(void)createBagView{
    self.frame =[UIScreen mainScreen].bounds;
    UIView * bagView = [[UIView alloc]init];
    bagView.backgroundColor = [UIColor blackColor];
    bagView.alpha = 0.5;
    [self addSubview:bagView];
    [bagView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self);
    }];
}

-(void)createShowViewWithHight:(CGFloat)hight{
    _showView = [[UIView alloc]init];
    _showView.backgroundColor = [UIColor whiteColor];
    _showView.layer.cornerRadius = 5;
    _showView.clipsToBounds = YES;
    [self addSubview:_showView];
    [_showView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.centerY.equalTo(self);
        make.width.equalTo(FitPTScreen(300));
        make.height.equalTo(hight);
    }];
    
    UIView * lineView = [[UIView alloc]init];
    lineView.backgroundColor = UIColorFromRGB(0xCCCCCC);
    [_showView addSubview:lineView];
    [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.equalTo(1);
        make.width.equalTo(self->_showView);
        make.left.equalTo(self->_showView);
        make.bottom.equalTo(self->_showView.mas_bottom).offset(FitPTScreenH(-40));
    }];
    
    _concernBtn = [[UIButton alloc]init];
    [_concernBtn setTitle:@"确定" forState:UIControlStateNormal];
    _concernBtn.titleLabel.font = MicrosoftYaHeiFont(17);
    [_concernBtn setTitleColor:UIColorFromRGB(0xFF8D26) forState:UIControlStateNormal];
    _concernBtn.backgroundColor = [UIColor whiteColor];
    [_showView addSubview:_concernBtn];
    [_concernBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.bottom.equalTo(self->_showView);
        make.height.equalTo(FitPTScreenH(40));
        make.width.equalTo(FitPTScreen(150));
    }];
    
    [_concernBtn addTarget:self action:@selector(concernClick) forControlEvents:UIControlEventTouchUpInside];

        _cancelBtn = [[UIButton alloc]init];
        [_cancelBtn setTitle:@"取消" forState:UIControlStateNormal];
        _cancelBtn.titleLabel.font = MicrosoftYaHeiFont(17);
        [_cancelBtn setTitleColor:UIColorFromRGB(0x009FF5) forState:UIControlStateNormal];
        [_showView addSubview:_cancelBtn];
        [_cancelBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.bottom.equalTo(self->_showView);
            make.height.equalTo(FitPTScreenH(40));
            make.width.equalTo(FitPTScreen(150));
        }];
        
        [_cancelBtn addTarget:self action:@selector(cancelClick) forControlEvents:UIControlEventTouchUpInside];
        
        UIView *failLineView= [[UIView alloc]init];
        failLineView.backgroundColor =UIColorFromRGB(0xCCCCCC);
        [self->_showView addSubview:failLineView];
        [failLineView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.cancelBtn.mas_right);
            make.top.equalTo(lineView.mas_bottom);
            make.width.equalTo(1);
            make.height.equalTo(FitPTScreenH(40));
        }];
    
    [_showView hl_addPopAnimation];
}

//确定按钮
-(void)concernClick{
    [self removeFromSuperview];
    if (_concern) {
        _concern();
    }else if (_concernOption){
        _concernOption(_textField.text);
    }
}

//取消按钮
-(void)cancelClick{
    [self removeFromSuperview];
    if (_cancel) {
        _cancel();
    }
}

#pragma title and subtitle
-(void)createTitlesubTitle{
    _titleLable = [[UILabel alloc]init];
    _titleLable.text = _title;
    _titleLable.textAlignment = NSTextAlignmentCenter;
    _titleLable.textColor = UIColorFromRGB(0x555555);
    _titleLable.font = [UIFont systemFontOfSize:FitPTScreenH(14)];
    [_showView addSubview:_titleLable];
    [_titleLable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self);
        make.height.equalTo(FitPTScreenH(30));
        make.top.equalTo(self->_showView).offset(FitPTScreenH(30));
    }];
    
    _subTitleLable = [[UILabel alloc]init];
    _subTitleLable.text = _subTitle;
    _subTitleLable.textAlignment = NSTextAlignmentCenter;
    _subTitleLable.textColor = _color;
    _subTitleLable.font = [UIFont systemFontOfSize:FitPTScreenH(14)];
    [_showView addSubview:_subTitleLable];
    [_subTitleLable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self);
        make.top.equalTo(self.titleLable.mas_bottom).offset(FitPTScreenH(15));
    }];
}

-(void)creteTextField{
    _textField = [[UITextField alloc]init];
    _textField.text = _text;
    _textField.layer.borderColor = UIColorFromRGB(0xDDDDDD).CGColor;
    _textField.layer.borderWidth = FitPTScreen(1);
    _textField.attributedPlaceholder = [[NSAttributedString alloc]initWithString:_placeholder attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:FitPTScreenH(12)],NSForegroundColorAttributeName:UIColorFromRGB(0xAAAAAA)}];
    UIView * leftView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, FitPTScreenH(10),0)];
    leftView.backgroundColor = [UIColor clearColor];
    _textField.leftView = leftView;
    _textField.leftViewMode = UITextFieldViewModeAlways;
    _textField.delegate= self;
    
    [_showView addSubview:_textField];
    [_textField makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self->_showView);
        make.top.equalTo(self.titleLable.mas_bottom).offset(FitPTScreenH(20));
        make.width.equalTo(FitPTScreen(225));
        make.height.equalTo(FitPTScreenH(34));
    }];
    
    checkTool = [[HLTextFieldCheckInputNumberTool alloc]init];
    checkTool.MAX_STARWORDS_LENGTH = 14;
    [_textField addTarget:checkTool action:@selector(textFieldDidChanged:) forControlEvents:UIControlEventEditingChanged];
    //第一响应者
    [_textField becomeFirstResponder];
}

-(void)creatLastTitle{
    _lastLable = [[UILabel alloc]init];
    _lastLable.text = _lastTitle;
    _lastLable.textAlignment = NSTextAlignmentCenter;
    _lastLable.textColor = _lastcolor;
    _lastLable.font = MicrosoftYaHeiFont(13);
    [_showView addSubview:_lastLable];
    [_lastLable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self);
        make.top.equalTo(self.subTitleLable.mas_bottom).offset(FitPTScreenH(15));
    }];
}

-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self endEditing:YES];
}

-(void)setCancelTitle:(NSString *)title concern:(NSString *)concernTit{
    [_cancelBtn setTitle:title forState:UIControlStateNormal];
    [_concernBtn setTitle:concernTit forState:UIControlStateNormal];
    [_cancelBtn setTitleColor:UIColor.grayColor forState:UIControlStateNormal];
}

@end
