//
//  HLRuleDescHeader.m
//  HuiLife
//
//  Created by 闻喜惠生活 on 2019/8/6.
//

#import "HLRuleDescHeader.h"
#import "HLRuleModel.h"

@interface HLRuleDescHeader ()

@property(strong,nonatomic)UILabel * titleLb;

@property(strong,nonatomic)UITextView * textView;

@property(strong,nonatomic)NSArray * mutableContents;

@property(strong,nonatomic)UIButton * customBtn;

@property(strong,nonatomic)UIView * lineV;

@end

@implementation HLRuleDescHeader

- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        [self initSubView];
    }
    return self;
}

-(instancetype)init{
    if (self = [super init]) {
        [self initSubView];
    }
    return self;
}

-(void)initSubView{
    _titleLb = [[UILabel alloc]init];
    _titleLb.textColor = [UIColor hl_StringToColor:@"#333333"];
    _titleLb.font = [UIFont systemFontOfSize:FitPTScreen(14)];
    _titleLb.attributedText = [self textArrWithText:@"规则说明"];
    [self addSubview:_titleLb];
    [_titleLb makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(FitPTScreen(8));
        make.top.equalTo(FitPTScreen(19));
    }];
    
    UIView * bagView = [[UIView alloc]init];
    [self addSubview:bagView];
    [bagView makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(FitPTScreen(12));
        make.top.equalTo(self.titleLb.bottom).offset(FitPTScreen(18));
        make.width.equalTo(FitPTScreen(350));
        make.height.equalTo(FitPTScreen(37));
    }];
    
    _textView = [[UITextView alloc]init];
    _textView.backgroundColor = [UIColor hl_StringToColor:@"#F8F8F8"];
    _textView.font = [UIFont systemFontOfSize:FitPTScreen(13)];
    _textView.textColor =[UIColor hl_StringToColor:@"#999999"];
    _textView.layer.cornerRadius = FitPTScreen(5);
    _textView.placeholder = @"可自定义填写规则说明";
    _textView.layer.masksToBounds = YES;
    _textView.textContainerInset = UIEdgeInsetsMake(9,0, 9, 40);;
    [bagView addSubview:_textView];
    [_textView makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(bagView);
    }];
    
    UIButton * clear = [[UIButton alloc]init];
    [bagView addSubview:clear];
    [clear setImage:[UIImage imageNamed:@"close_x_circle"] forState:UIControlStateNormal];
    [clear makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.right.equalTo(bagView);
        make.width.height.equalTo(FitPTScreen(40));
    }];
    [clear addTarget:self action:@selector(clearClick:) forControlEvents:UIControlEventTouchUpInside];
    
    _customBtn = [[UIButton alloc]init];
    [_customBtn setTitle:@" 添加自定义预约信息" forState:UIControlStateNormal];
    [_customBtn setImage:[UIImage imageNamed:@"add_yellow"] forState:UIControlStateNormal];
    [_customBtn setTitleColor:[UIColor hl_StringToColor:@"#FFAB33"] forState:UIControlStateNormal];
    _customBtn.titleLabel.font = [UIFont systemFontOfSize:FitPTScreen(14)];
    [self addSubview:_customBtn];
    [_customBtn makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(bagView.bottom).offset(FitPTScreen(18));
        make.left.equalTo(self.titleLb);
    }];
    [_customBtn addTarget:self action:@selector(addRuleClick) forControlEvents:UIControlEventTouchUpInside];
    
    
    _lineV = [[UIView alloc]init];
    _lineV.backgroundColor = SeparatorColor;
    [self addSubview:_lineV];
    [_lineV makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(FitPTScreen(13));
        make.right.equalTo(1);
        make.bottom.equalTo(self);
        make.height.equalTo(FitPTScreen(0.7));
    }];
}


-(NSAttributedString *)textArrWithText:(NSString *)text{
    NSString * textStr = [NSString stringWithFormat:@"*%@",text];
    NSMutableAttributedString * attr = [[NSMutableAttributedString alloc]initWithString:textStr];
    NSRange range = NSMakeRange(0, 1);
    [attr addAttributes:@{NSForegroundColorAttributeName:UIColorFromRGB(0xFF4040)} range:range];
    return attr;
}

-(void)clearClick:(UIButton *)sender{
    self.textView.text = @"";
}

//添加自定义规则
-(void)addRuleClick{
    if (!_textView.text.length) {
        return;
    }
    
    HLRuleModel * model = [[HLRuleModel alloc]init];
    model.selected = YES;
    model.content = _textView.text;
    
    _textView.text = @"";
    if ([self.delegate respondsToSelector:@selector(ruleHeader:addRule:)]) {
        [self.delegate ruleHeader:self addRule:model];
    }
}
@end
