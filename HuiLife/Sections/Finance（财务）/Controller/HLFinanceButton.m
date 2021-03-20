//
//  HLFinanceButton.m
//  HuiLife
//
//  Created by 闻喜惠生活 on 2018/12/26.
//

#import "HLFinanceButton.h"

@interface HLFinanceButton()

@property(copy,nonatomic)NSString *title;

@property (assign,nonatomic)HLFinanceButtonType type;

@property(strong,nonatomic)UILabel * titleLable;

@end

@implementation HLFinanceButton

-(instancetype)initWithTitle:(NSString *)title type:(HLFinanceButtonType)type{
    if (self = [super init]) {
        _type = type;
        _title = title;
        [self initSubView];
    }
    return self;
}

-(void)initSubView{
    _titleLable = [[UILabel alloc]init];
    _titleLable.text = _title;
    _titleLable.textColor = _type == HLFinanceButtonFirstType?[UIColor hl_StringToColor:@"#282828"]:[UIColor hl_StringToColor:@"#989898"];
    _titleLable.font = [UIFont systemFontOfSize:FitPTScreenH(13)];
    [self addSubview:_titleLable];
    [_titleLable makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(FitPTScreen(20));
        make.top.equalTo(FitPTScreenH(20));
    }];
    
    _value = [[UILabel alloc]init];
    _value.textColor = _type == HLFinanceButtonFirstType?[UIColor hl_StringToColor:@"#FF8D26"]:[UIColor hl_StringToColor:@"#989898"];
    _value.font = [UIFont systemFontOfSize:FitPTScreenH(13)];
    [self addSubview:_value];
    [_value makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(FitPTScreen(20));
        make.top.equalTo(self.titleLable.mas_bottom).offset(FitPTScreenH(10));
    }];
    
    UIView * line = [[UIView alloc]init];
    line.backgroundColor = [UIColor hl_StringToColor:@"#DDDDDD"];
    [self addSubview:line];
    [line makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mas_right);
        make.centerY.equalTo(self);
        make.width.equalTo(FitPTScreen(1));
        make.height.equalTo(FitPTScreenH(50));
    }];
    
    UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapClick)];
    [self addGestureRecognizer:tap];
}

-(void)tapClick{
    if ([self.delegate respondsToSelector:@selector(clickFinanceButton:)]) {
        [self.delegate clickFinanceButton:self];
    }
}

@end
