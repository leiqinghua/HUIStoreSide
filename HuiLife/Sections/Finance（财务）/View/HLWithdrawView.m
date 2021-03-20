//
//  HLWithdrawView.m
//  HuiLife
//
//  Created by 闻喜惠生活 on 2018/12/26.
//

#import "HLWithdrawView.h"

@interface HLWithdrawView()

@property(strong,nonatomic)UIView *bagView ;

@property(copy,nonatomic)PayBlock block;

@property(copy,nonatomic)NSString *money;

@property(assign,nonatomic)NSInteger index;

@property(strong,nonatomic)UIView *alertView;

@property(strong,nonatomic)UILabel *moneyLable;

@property(assign,nonatomic)BOOL isTx;

@end

@implementation HLWithdrawView

+(void)withDrawWithMoeny:(NSString *)money selectIndex:(NSInteger)index callBack:(PayBlock)block{
    [self withDrawWithMoeny:money isTx:YES selectIndex:index callBack:block];
}

+(void)withDrawWithMoeny:(NSString *)money isTx:(BOOL)isTx selectIndex:(NSInteger)index callBack:(PayBlock)block{
    HLWithdrawView * withDraw = [[HLWithdrawView alloc]initWithMoney:money isTx:isTx selectIndex:index];
    withDraw.block = block;
    [KEY_WINDOW addSubview:withDraw];
    [withDraw alertAnimate];
}

-(instancetype)initWithMoney:(NSString *)money isTx:(BOOL)isTx selectIndex:(NSInteger)index{
    if (self = [super initWithFrame:[UIScreen mainScreen].bounds]) {
        _money = money;
        _index = index;
        _isTx = isTx;
        [self initSubView];
    }
    return self;
}

-(void)initSubView{
    _bagView = [[UIView alloc]initWithFrame:self.bounds];
    _bagView.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0];
    [self addSubview:_bagView];
    UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapClick:)];
    [_bagView addGestureRecognizer:tap];
    
    
    _alertView = [[UIView alloc]initWithFrame:CGRectMake(0, self.bounds.size.height, ScreenW, FitPTScreenH(248))];
    _alertView.backgroundColor = UIColor.whiteColor;
    [self addSubview:_alertView];
    
    UILabel *tip = [[UILabel alloc]init];
    tip.textColor = [UIColor hl_StringToColor:@"#656565"];
    tip.font = [UIFont systemFontOfSize:FitPTScreen(15)];
    tip.text = _isTx?@"提现金额":@"金额";
    [_alertView addSubview:tip];
    [tip makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(FitPTScreen(31));
        make.top.equalTo(FitPTScreenH(25));
    }];
    
    _moneyLable = [[UILabel alloc]init];
    _moneyLable.textColor = [UIColor hl_StringToColor:@"#282828"];
    _moneyLable.font = [UIFont systemFontOfSize:FitPTScreenH(20)];
    _moneyLable.attributedText = [self attrWithMoney:_money];;
    [_alertView addSubview:_moneyLable];
    [_moneyLable makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(FitPTScreen(31));
        make.top.equalTo(FitPTScreenH(61));
    }];
    
    [_alertView addSubview:[HLTools lineWithGap:FitPTScreen(20) topMargn:FitPTScreenH(104)]];
    
    UILabel *way = [[UILabel alloc]init];
    way.textColor = [UIColor hl_StringToColor:@"#656565"];
    way.font = [UIFont systemFontOfSize:FitPTScreenH(15)];
    way.text = _isTx?@"提现方式":@"支付方式";
    [_alertView addSubview:way];
    [way makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(FitPTScreen(31));
        make.top.equalTo(FitPTScreenH(129));
    }];
    
    HLWithdrawWayView * wxView = [[HLWithdrawWayView alloc]init];
    wxView.img = @"weixin_logo";
    wxView.name = @"微信提现";
    [_alertView addSubview:wxView];
    [wxView makeConstraints:^(MASConstraintMaker *make) {
        make.left.width.equalTo(self.alertView);
        make.top.equalTo(way.mas_bottom);
        make.height.equalTo(FitPTScreenH(55));
    }];
    
    UIButton * concern = [[UIButton alloc]init];
    [concern setTitle:@"确认" forState:UIControlStateNormal];
    [concern setTitleColor:UIColorFromRGB(0xFFFFFF) forState:UIControlStateNormal];
    concern.backgroundColor =UIColorFromRGB(0xFF8D26);
    concern.titleLabel.font=[UIFont systemFontOfSize:FitPTScreenH(15)];
    [_alertView addSubview:concern];
    [concern addTarget:self action:@selector(liJiTixian:) forControlEvents:UIControlEventTouchUpInside];
    [concern mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.width.bottom.equalTo(self.alertView);
        make.height.equalTo(FitPTScreenH(49) + Height_Bottom_Margn);
    }];
}

-(void)liJiTixian:(UIButton *)sender{
    [self hideAnimate];
    if (self.block) {
        self.block(0);//就一个所以为0
    }
}

-(void)alertAnimate{
    [UIView animateWithDuration:0.3 animations:^{
        self.bagView.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.4];
        CGRect frame = self.alertView.frame;
        frame.origin.y = self.bounds.size.height - CGRectGetMaxY(self.alertView.bounds);
        self.alertView.frame = frame;
    }];
    
    
}

-(void)hideAnimate{
    [UIView animateWithDuration:0.3 animations:^{
        CGRect frame = self.alertView.frame;
        frame.origin.y = self.bounds.size.height;
        self.alertView.frame = frame;
        self.bagView.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0];
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
}


-(void)tapClick:(UITapGestureRecognizer *)sender{
    [self hideAnimate];
}

-(NSAttributedString *)attrWithMoney:(NSString *)money{
    if (![money hl_isAvailable]) {
        return nil;
    }
    NSString * text = [NSString stringWithFormat:@"￥%@",money];
    NSMutableAttributedString * attr = [[NSMutableAttributedString alloc]initWithString:text];
    NSRange range = NSMakeRange(0, 1);
    NSDictionary *dict = @{NSFontAttributeName:[UIFont systemFontOfSize:FitPTScreenH(25)]};
    [attr addAttributes:dict range:range];
    return attr;
}
@end


@interface HLWithdrawWayView()

@property(strong,nonatomic)UIImageView *imageView;

@property(strong,nonatomic)UILabel *nameLable;

@property(strong,nonatomic)UIButton *selectBtn;
@end

@implementation HLWithdrawWayView

-(instancetype)init{
    if (self = [super init]) {
        [self initSubView];
    }
    return self;
}

-(void)initSubView{
    _imageView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@""]];
    [self addSubview:_imageView];
    [_imageView makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(FitPTScreen(29));
        make.centerY.equalTo(self);
    }];
    
    _nameLable = [[UILabel alloc]init];
    _nameLable.textAlignment = NSTextAlignmentCenter;
    _nameLable.font = [UIFont systemFontOfSize:FitPTScreenH(14)];
    _nameLable.text = @"";
    _nameLable.textColor = UIColorFromRGB(0x282828);
    [self addSubview:_nameLable];
    [_nameLable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.imageView.mas_right).offset(FitPTScreen(10));
        make.centerY.equalTo(self);
    }];
    
    _selectBtn = [[UIButton alloc]init];
    [_selectBtn setImage:[UIImage imageNamed:@"success_oriange"] forState:UIControlStateNormal];
    [self addSubview:_selectBtn];
    [_selectBtn makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(FitPTScreen(-10));
        make.centerY.equalTo(self);
        make.width.height.equalTo(FitPTScreen(40));
    }];
}

-(void)setImg:(NSString *)img{
    _imageView.image = [UIImage imageNamed:img];
}

-(void)setName:(NSString *)name{
    _nameLable.text = name;
}

@end

