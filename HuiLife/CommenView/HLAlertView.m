//
//  HLAlertView.m
//  HuiLife
//
//  Created by 闻喜惠生活 on 2018/12/26.
//

#import "HLAlertView.h"

@interface HLAlertView()

@property (copy,nonatomic)NSString * title;

@property (copy,nonatomic)NSString * subTitle;

@property (assign,nonatomic)HLAlertViewButtonType type;

@property (strong,nonatomic)UIView *alertView;

@property(copy,nonatomic)HLAlertCallBack callBack;

@property (strong,nonatomic)NSArray *titles;

@property (strong,nonatomic)NSArray *colors;

@end

@implementation HLAlertView

+(void)alertWithTitle:(NSString *)title subTitltle:(NSString *)sub type:(HLAlertViewButtonType)type{
    [self showAlertViewTitle:title message:sub buttonTitles:@[@"知道了"] buttonColors:@[[UIColor hl_StringToColor:@"FF8D26"]] callBack:nil];
}

+(void)showAuthAlertViewTitle:(NSString *)title message:(NSString *)message buttonTitles:(NSArray *)buttonTitles callBack:(HLAlertCallBack)callBack{
    [self showAlertViewTitle:title message:message buttonTitles:buttonTitles buttonColors:@[UIColorFromRGB(0X333333),UIColorFromRGB(0xFF9900)] callBack:callBack];
}

+(void)showAlertViewTitle:(NSString *)title message:(NSString *)message buttonTitles:(NSArray *)buttonTitles buttonColors:(NSArray *)colors callBack:(HLAlertCallBack)callBack{
    HLAlertView * alert = [[HLAlertView alloc]initWithTitle:title subTitltle:message buttonTitles:buttonTitles buttonColors:colors callBack:callBack];
    [KEY_WINDOW addSubview:alert];
}

-(instancetype)initWithTitle:(NSString *)title subTitltle:(NSString *)sub buttonTitles:(NSArray *)buttonTitles buttonColors:(NSArray *)colors callBack:(HLAlertCallBack)callBack{
    if (self = [super  initWithFrame:[UIScreen mainScreen].bounds]) {
        _title = title;
        _subTitle = sub;
        _titles = buttonTitles;
        _colors = colors;
        _callBack = callBack;
        [self initSubView];
    }
    return self;
}

-(void)initSubView{
    UIView * bagView = [[UIView alloc]initWithFrame:self.bounds];
    bagView.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.5];
    [self addSubview:bagView];
    
    _alertView = [[UIView alloc]init];
    _alertView.layer.cornerRadius = FitPTScreen(5);
    _alertView.backgroundColor = UIColor.whiteColor;
    _alertView.center = bagView.center;
    [self addSubview:_alertView];
    [_alertView makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.centerY.equalTo(self);
        make.width.equalTo(FitPTScreen(300));
    }];
    
    UILabel * title = [[UILabel alloc]init];
    title.text = _title;
    title.font = [UIFont systemFontOfSize:FitPTScreen(16)];
    title.textColor = [UIColor hl_StringToColor:@"#282828"];
    [_alertView addSubview:title];
    [title makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.alertView);
        make.top.equalTo(FitPTScreen(30));
    }];
    
    UILabel * subTitle = [[UILabel alloc]init];
    subTitle.attributedText = [self attrWithText:_subTitle];
    subTitle.numberOfLines = 0;
    subTitle.textAlignment = NSTextAlignmentCenter;
    subTitle.font = [UIFont systemFontOfSize:FitPTScreen(14)];
    subTitle.textColor = [UIColor hl_StringToColor:@"#AAAAAA"];
    [_alertView addSubview:subTitle];
    [subTitle makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.alertView);
        make.top.equalTo(title.mas_bottom).offset(FitPTScreen(20));
        make.width.equalTo(FitPTScreen(260));
    }];
    
    UIView * line = [[UIView alloc]init];
    line.backgroundColor = [UIColor hl_StringToColor:@"#CCCCCC"];
    [_alertView addSubview:line];
    [line makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.alertView);
        make.top.equalTo(subTitle.mas_bottom).offset(FitPTScreen(20));
        make.height.equalTo(FitPTScreen(1));
    }];
    
    
    // 按钮
    CGFloat itemWidth = FitPTScreen(300) / _titles.count;
    for (NSInteger i = 0; i < _titles.count; i++) {
        UIButton *button = [[UIButton alloc] init];
        [button setTitle:_titles[i] forState:UIControlStateNormal];
        [button setTitleColor:_colors[i] forState:UIControlStateNormal];
        button.titleLabel.font = [UIFont systemFontOfSize:FitPTScreen(14)];
        [_alertView addSubview:button];
        button.tag = i;
        [button addTarget:self action:@selector(knowClick:) forControlEvents:UIControlEventTouchUpInside];
        [button makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo(self.alertView);
            make.left.equalTo(i * itemWidth);
            make.height.equalTo(FitPTScreen(46));
            make.width.equalTo(itemWidth);
            make.top.equalTo(line.mas_bottom);
        }];
    }
    
    if(_titles.count == 2){
        UIView *centerLine = [[UIView alloc] init];
        [self.alertView addSubview:centerLine];
        centerLine.backgroundColor = UIColorFromRGB(0xEDEDED);
        [centerLine makeConstraints:^(MASConstraintMaker *make) {
            make.top.bottom.centerX.equalTo(self.alertView);
            make.width.equalTo(FitPTScreen(0.5));
        }];
    }
    
    [_alertView hl_addPopAnimation];
}

-(void)knowClick:(UIButton *)sender{
    [self removeFromSuperview];
    if (self.callBack) {
        self.callBack(sender.tag);
    }
}

-(NSAttributedString *)attrWithText:(NSString *)text{
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    [paragraphStyle setLineSpacing:1.5];
    
    NSAttributedString * attr = [[NSAttributedString alloc]initWithString:text attributes:@{NSParagraphStyleAttributeName:paragraphStyle}];
    
    return attr;
}
@end
